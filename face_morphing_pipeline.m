function face_morphing_pipeline(young_path, old_path)
    test_preprocessing = 1;
    test_feature_finding = 1;
    test_mesh_generation = 1;
    run_full_pipeline = 1;

    if test_preprocessing
        fprintf('\n=== Testing Pre-processing ===\n');
        test_preprocessing_module(young_path);
    end

    if test_feature_finding
        fprintf('\n=== Testing Feature Finding ===\n');
        test_feature_detection(young_path);
    end

    if test_mesh_generation
        fprintf('\n=== Testing Mesh Generation ===\n');
        test_mesh_generation_module();
    end

    if run_full_pipeline
        fprintf('\n=== Running Full Pipeline ===\n');
        main_morphing_pipeline(young_path, old_path);
    end
end

function main_morphing_pipeline(young_path, old_path)
    youngImg = imread(young_path);
    oldImg = imread(old_path);

    [youngFace, oldFace] = preprocess_images(youngImg, oldImg);

    youngFeatures = detectFacialFeatures(youngFace);
    oldFeatures = detectFacialFeatures(oldFace);

    [youngMesh, youngTri] = createFaceMesh(youngFeatures, size(youngFace));
    [oldMesh, oldTri] = createFaceMesh(oldFeatures, size(oldFace));

    visualize_results(youngFace, oldFace, youngFeatures, oldFeatures, youngTri, oldTri);
    run_face_morphing(youngFace, oldFace, youngFeatures, oldFeatures);
end

function test_preprocessing_module(young_path)
    testImg = imread(young_path);
    faceDetector = vision.CascadeObjectDetector();
    try
        detectAndCropFace(testImg, faceDetector);
        fprintf('Pre-processing test passed: Face detected\n');
    catch
        warning('Pre-processing test failed: No face detected');
    end
end

function test_feature_detection(young_path)
    try
        testFace = imread('cropped_face.jpg');
        fprintf('Loaded previously cropped face\n');
    catch
        testFace = imread(young_path);
        faceDetector = vision.CascadeObjectDetector();
        detectAndCropFace(testFace, faceDetector);
        testFace = imresize(testFace, [500 500]);
    end

    features = detectFacialFeatures(testFace);

    if size(features,1) == 4
        fprintf('Feature detection test passed: 4 features found\n');
    else
        warning('Feature detection test failed: Incorrect number of features');
    end
end

function test_mesh_generation_module()
    dummyFeatures = [120 180; 380 180; 200 420; 280 420];
    [mesh, tri] = createFaceMesh(dummyFeatures, [500 500]);
    num_triangles = size(tri.ConnectivityList,1);
    if num_triangles >= 12
        fprintf('Mesh generation test passed: %d triangles created\n', num_triangles);
    else
        warning('Mesh generation test failed: Only %d triangles', num_triangles);
    end
end

function [youngFace, oldFace] = preprocess_images(youngImg, oldImg)
    faceDetector = vision.CascadeObjectDetector();
    detectAndCropFace(youngImg, faceDetector);
    detectAndCropFace(oldImg, faceDetector);
    targetSize = [500, 500];
    youngFace = imresize(youngImg, targetSize);
    oldFace = imresize(oldImg, targetSize);
end

function features = detectFacialFeatures(img)
    detector = vision.CascadeObjectDetector();
    bbox = detector(img);
    if isempty(bbox)
        error('No face detected.');
    end

    % Use ML-based landmark detector
    landmarks = detectFacialLandmarks(img, bbox(1,:));

    % Key points: left eye, right eye, left mouth, right mouth
    leftEye = landmarks(1,:);
    rightEye = landmarks(2,:);
    leftMouth = landmarks(5,:);
    rightMouth = landmarks(6,:);

    features = [leftEye; rightEye; leftMouth; rightMouth];
end

function [mesh, tri] = createFaceMesh(features, imgSize)
    [h, w] = deal(imgSize(1), imgSize(2));
    extendedPoints = [
        1, features(1,2);
        w, features(2,2);
        features(3,1), h;
        features(4,1), h;
        (features(1,1)+features(3,1))/2, 1;
        (features(2,1)+features(4,1))/2, 1
    ];
    mesh = [features; extendedPoints];
    tri = delaunayTriangulation(mesh);
end

function visualize_results(youngFace, oldFace, youngFeatures, oldFeatures, youngTri, oldTri)
    figure('Name','Final Pipeline Results', 'Position', [100 100 1200 600]);
    subplot(2,2,1);
    imshow(youngFace); hold on;
    plot(youngFeatures(:,1), youngFeatures(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    triplot(youngTri, 'g-', 'LineWidth', 1);
    title('Young Face Features & Mesh');

    subplot(2,2,2);
    imshow(oldFace); hold on;
    plot(oldFeatures(:,1), oldFeatures(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    triplot(oldTri, 'g-', 'LineWidth', 1);
    title('Old Face Features & Mesh');

    subplot(2,2,[3 4]);
    triplot(youngTri, 'b-'); hold on;
    triplot(oldTri, 'r-');
    title('Mesh Comparison (Blue: Young, Red: Old)');
    legend('Young Mesh', 'Old Mesh');
    axis equal;
    grid on;
end

function detectAndCropFace(img, detector)
    bbox = detector(img);
    if ~isempty(bbox)
        imwrite(img, 'cropped_face.jpg');
    else
        error('Face detection failed.');
    end
end

function run_face_morphing(img1, img2, points1, points2)
    img_size = [size(img1,1), size(img1,2)];
    boundary_pts = [0, 0; img_size(2)/2, 0; img_size(2), 0;
                    0, img_size(1)/2; img_size(2), img_size(1)/2;
                    0, img_size(1); img_size(2)/2, img_size(1); img_size(2), img_size(1)];
    points1 = [points1; boundary_pts];
    points2 = [points2; boundary_pts];
    triangles = delaunay(points1(:,1), points1(:,2));

    alpha = 0.5;
    morphed_points = (1 - alpha) * points1 + alpha * points2;
    morphed_img = uint8(zeros(size(img1)));

    for i = 1:size(triangles, 1)
        tri1 = points1(triangles(i,:), :);
        tri2 = points2(triangles(i,:), :);
        tri_morphed = morphed_points(triangles(i,:), :);

        T1 = fitgeotrans(tri1, tri_morphed, 'affine');
        T2 = fitgeotrans(tri2, tri_morphed, 'affine');

        mask = poly2mask(tri_morphed(:,1), tri_morphed(:,2), img_size(1), img_size(2));
        warp1 = imwarp(img1, T1, 'OutputView', imref2d(size(img1)));
        warp2 = imwarp(img2, T2, 'OutputView', imref2d(size(img2)));

        blended = uint8((1 - alpha) * double(warp1) + alpha * double(warp2));
        for ch = 1:3
            region = morphed_img(:,:,ch);
            blend = blended(:,:,ch);
            region(mask) = blend(mask);
            morphed_img(:,:,ch) = region;
        end
    end

    figure, imshow(morphed_img), title('Final Morphed Image');
    imwrite(morphed_img, 'final_morphed.png');
end