clc; clear; close all;

path = './test1/'; 

% Load images
img1 = imread(fullfile(path, 'young.png'));  % Young face
img2 = imread(fullfile(path, 'old.png'));    % Old face

% Ensure RGB
if size(img1, 3) == 1
    img1 = cat(3, img1, img1, img1);
end
if size(img2, 3) == 1
    img2 = cat(3, img2, img2, img2);
end

% Resize to same size
img_size = [500, 500];
img1 = imresize(img1, img_size);
img2 = imresize(img2, img_size);

num_points = 17;

% ---- Select points on young image ----
disp('Select exactly 17 feature points in the Young image.');
figure, imshow(img1), title('Select 17 points in Young image');
points1 = zeros(num_points, 2);
for i = 1:num_points
    [x, y] = ginput(1);
    points1(i, :) = [x, y];
    hold on; plot(x, y, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); drawnow;
end
pause(0.5); close;

% ---- Select points on old image ----
disp('Select exactly 17 corresponding feature points in the Old image.');
figure, imshow(img2), title('Select 17 points in Old image');
points2 = zeros(num_points, 2);
for i = 1:num_points
    [x, y] = ginput(1);
    points2(i, :) = [x, y];
    hold on; plot(x, y, 'go', 'MarkerSize', 5, 'MarkerFaceColor', 'g'); drawnow;
end
pause(0.5); close;

% ---- Add boundary points ----
boundary_pts = [0, 0; img_size(2)/2, 0; img_size(2), 0;
                0, img_size(1)/2; img_size(2), img_size(1)/2;
                0, img_size(1); img_size(2)/2, img_size(1); img_size(2), img_size(1)];
points1 = [points1; boundary_pts];
points2 = [points2; boundary_pts];

% ---- Compute Delaunay triangulation ----
triangles = delaunay(points1(:,1), points1(:,2));

% ---- Morphing loop for GIF ----
alphas = linspace(0, 1, 30); % 30 frames
gif_filename = fullfile(path, 'age_progression.gif');

for idx = 1:length(alphas)
    alpha = alphas(idx);
    morphed_points = (1 - alpha) * points1 + alpha * points2;
    morphed_img = uint8(zeros(size(img1))); 

    for i = 1:size(triangles, 1)
        tri1 = points1(triangles(i, :), :);
        tri2 = points2(triangles(i, :), :);
        tri_morphed = morphed_points(triangles(i, :), :);

        T1 = fitgeotrans(tri1, tri_morphed, 'affine');
        T2 = fitgeotrans(tri2, tri_morphed, 'affine');


        x_min = max(1, floor(min(tri_morphed(:,1))));
        x_max = min(img_size(2), ceil(max(tri_morphed(:,1))));
        y_min = max(1, floor(min(tri_morphed(:,2))));
        y_max = min(img_size(1), ceil(max(tri_morphed(:,2))));

        mask = poly2mask(tri_morphed(:,1), tri_morphed(:,2), img_size(1), img_size(2));
        warp1 = imwarp(img1, T1, 'OutputView', imref2d(size(img1)));
        warp2 = imwarp(img2, T2, 'OutputView', imref2d(size(img2)));

        if size(warp1, 3) == 1
            warp1 = repmat(warp1, [1 1 3]);
        end
        if size(warp2, 3) == 1
            warp2 = repmat(warp2, [1 1 3]);
        end

        blended = (1 - alpha) * double(warp1) + alpha * double(warp2);
        blended = uint8(blended);

        for ch = 1:3
            channel = morphed_img(y_min:y_max, x_min:x_max, ch);
            blend_region = blended(y_min:y_max, x_min:x_max, ch);
            channel(mask(y_min:y_max, x_min:x_max)) = blend_region(mask(y_min:y_max, x_min:x_max));
            morphed_img(y_min:y_max, x_min:x_max, ch) = channel;
        end
    end

    % Display current frame
    imshow(morphed_img);
    title(sprintf('Alpha = %.2f', alpha));
    drawnow;

    % Convert to indexed frame for GIF
    [A, map] = rgb2ind(morphed_img, 256);
    if idx == 1
        imwrite(A, map, gif_filename, 'gif', 'LoopCount', Inf, 'DelayTime', 0.005);
    else
        imwrite(A, map, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.005);
    end
end

disp('GIF export complete!');
