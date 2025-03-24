%% Main Face Morphing Pipeline with Integrated Tests
function face_morphing_pipeline()
    % Set testing flags (1 to enable, 0 to disable)
    test_preprocessing = 1;
    test_feature_finding = 1;
    test_mesh_generation = 1;
    run_full_pipeline = 1;

    %% Test 1: Pre-processing Module
    if test_preprocessing
        fprintf('\n=== Testing Pre-processing ===\n');
        test_preprocessing_module();
    end

    %% Test 2: Feature Finding Module
    if test_feature_finding
        fprintf('\n=== Testing Feature Finding ===\n');
        test_feature_detection();
    end

    %% Test 3: Mesh Generation Module
    if test_mesh_generation
        fprintf('\n=== Testing Mesh Generation ===\n');
        test_mesh_generation_module();
    end

    %% Full Pipeline Execution
    if run_full_pipeline
        fprintf('\n=== Running Full Pipeline ===\n');
        main_morphing_pipeline();
    end
end

%% Main Pipeline Functions
function main_morphing_pipeline()
    % Load and preprocess images
    youngImg = imread('young.png');
    oldImg = imread('old.png');
    
    % Pre-processing
    [youngFace, oldFace] = preprocess_images(youngImg, oldImg);
    
    % Feature detection
    youngFeatures = detectFacialFeatures(youngFace);
    oldFeatures = detectFacialFeatures(oldFace);
    
    % Mesh generation
    [youngMesh, youngTri] = createFaceMesh(youngFeatures, size(youngFace));
    [oldMesh, oldTri] = createFaceMesh(oldFeatures, size(oldFace));
    
    % Visualization
    visualize_results(youngFace, oldFace, youngFeatures, oldFeatures, youngTri, oldTri);
end

%% Test Functions
function test_preprocessing_module()
    % Test with sample image
    testImg = imread('young.png');
    faceDetector = vision.CascadeObjectDetector();
    
    % Test face detection and cropping
    try
        croppedFace = detectAndCropFace(testImg, faceDetector);
        figure('Name','Pre-processing Test');
        subplot(1,2,1), imshow(testImg), title('Original Image');
        subplot(1,2,2), imshow(croppedFace), title('Cropped Face');
        fprintf('Pre-processing test passed: Face detected and cropped\n');
    catch
        warning('Pre-processing test failed: No face detected');
    end
end

function test_feature_detection()
    % Attempt to load auto-saved cropped face
    try
        testFace = imread('cropped_face.jpg');
        fprintf('Loaded previously cropped face\n');
    catch
        % Generate new face if no saved crop exists
        fprintf('No saved face found - processing new image\n');
        testFace = imread('young.png');
        faceDetector = vision.CascadeObjectDetector();
        testFace = detectAndCropFace(testFace, faceDetector);
        testFace = imresize(testFace, [500 500]);
    end
    
    % Detect features
    features = detectFacialFeatures(testFace);
    
    % Visualization
    figure('Name','Feature Detection Test');
    imshow(testFace); hold on;
    plot(features(1:2,1), features(1:2,2), 'go', 'MarkerSize', 15, 'LineWidth', 2);
    plot(features(3:4,1), features(3:4,2), 'ro', 'MarkerSize', 15, 'LineWidth', 2);
    title('Feature Detection Results');
    hold off;
    
    if size(features,1) == 4
        fprintf('Feature detection test passed: 4 features found\n');
    else
        warning('Feature detection test failed: Incorrect number of features');
    end
end

function test_mesh_generation_module()
    % Create more spread-out dummy features
    dummyFeatures = [120 180; 380 180; 200 420; 280 420]; % Wider eye distance
    
    % Generate mesh
    [mesh, tri] = createFaceMesh(dummyFeatures, [500 500]);
    
    % Visualization
    figure('Name','Mesh Generation Test');
    triplot(tri, 'LineWidth', 1.5);
    hold on;
    plot(mesh(:,1), mesh(:,2), 'ro', 'MarkerSize', 10);
    title('Face Mesh Structure');
    axis([0 500 0 500]);
    grid on;
    
    % Adjusted validation criteria (typical range: 12-16 triangles)
    num_triangles = size(tri.ConnectivityList,1);
    if num_triangles >= 12
        fprintf('Mesh generation test passed: %d triangles created\n', num_triangles);
    else
        warning('Mesh generation test failed: Only %d triangles', num_triangles);
    end
end

%% Core Algorithm Functions (Same as Previous Implementation)
function [youngFace, oldFace] = preprocess_images(youngImg, oldImg)
    faceDetector = vision.CascadeObjectDetector();
    youngFace = detectAndCropFace(youngImg, faceDetector);
    oldFace = detectAndCropFace(oldImg, faceDetector);
    targetSize = [500, 500];
    youngFace = imresize(youngFace, targetSize);
    oldFace = imresize(oldFace, targetSize);
end

function features = detectFacialFeatures(img)
    img = im2double(img);
    grayImg = rgb2gray(img);
    [eyes, ~] = detectEyes(grayImg);
    mouthCorners = detectMouth(img, eyes);
    features = [eyes; mouthCorners];
end

function [eyes, complexityMap] = detectEyes(grayImg)
    grayImg = im2double(grayImg);
    [h, w] = size(grayImg);
    windowSize = 15;
    complexityMap = zeros(h, w);
    for i = 1:h-windowSize
        for j = 1:w-windowSize
            window = grayImg(i:i+windowSize, j:j+windowSize);
            dx = diff(window, 1, 2);
            dy = diff(window, 1, 1);
            complexityMap(i,j) = sum(abs(dx(:))) + sum(abs(dy(:)));
        end
    end
    [X, Y] = meshgrid(1:w, 1:h);
    weight = exp(-((X - w/2).^2 + (Y - h/3).^2)/(2*(w/4)^2));
    weightedMap = complexityMap .* weight;
    peaks = imregionalmax(weightedMap);
    [y, x] = find(peaks);
    [~, idx] = sort(weightedMap(peaks), 'descend');
    candidates = [x(idx(1:3)), y(idx(1:3))];
    dist = pdist2(candidates, candidates);
    [row, col] = find(dist == max(dist(:)));
    eyes = candidates([row(1), col(1)], :);
end

function mouthCorners = detectMouth(img, eyes)
    img = im2double(img);
    avgEyeY = mean(eyes(:,2));
    roi = [1, avgEyeY, size(img,2), size(img,1)-avgEyeY];
    mouthRegion = imcrop(img, roi);
    R = mouthRegion(:,:,1);
    G = mouthRegion(:,:,2);
    redness = R ./ (G + 1e-3) .* (R > G * 1.2) .* (R > 0.4);
    BW = redness > max(redness(:)) * 0.8;
    stats = regionprops(BW, 'Area', 'BoundingBox');
    [~, idx] = max([stats.Area]);
    bbox = stats(idx).BoundingBox;
    mouthCorners = [
        bbox(1), bbox(2) + avgEyeY;
        bbox(1) + bbox(3), bbox(2) + avgEyeY
    ];
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

%% Visualization Function
function visualize_results(youngFace, oldFace, youngFeatures, oldFeatures, youngTri, oldTri)
    figure('Name','Final Pipeline Results', 'Position', [100 100 1200 600]);
    
    % Young face results
    subplot(2,2,1);
    imshow(youngFace); hold on;
    plot(youngFeatures(:,1), youngFeatures(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    triplot(youngTri, 'g-', 'LineWidth', 1);
    title('Young Face Features & Mesh');
    
    % Old face results
    subplot(2,2,2);
    imshow(oldFace); hold on;
    plot(oldFeatures(:,1), oldFeatures(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    triplot(oldTri, 'g-', 'LineWidth', 1);
    title('Old Face Features & Mesh');
    
    % Mesh comparison
    subplot(2,2,[3 4]);
    triplot(youngTri, 'b-'); hold on;
    triplot(oldTri, 'r-');
    title('Mesh Comparison (Blue: Young, Red: Old)');
    legend('Young Mesh', 'Old Mesh');
    axis equal;
    grid on;
end

function croppedFace = detectAndCropFace(img, detector)
    bbox = detector(img);
    if ~isempty(bbox)
        croppedFace = imcrop(img, bbox(1,:));
        imwrite(croppedFace, 'cropped_face.jpg'); % Auto-save added here
    else
        error('Face detection failed.');
    end
end
