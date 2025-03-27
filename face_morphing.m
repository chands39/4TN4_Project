clc; clear; close all;

% Load images
img1 = imread('./test1/young.png');  % Young face
img2 = imread('./test1/old.png');    % Old face

% Resize images to be the same size
img_size = [500, 500]; 
img1 = imresize(img1, img_size);
img2 = imresize(img2, img_size);

num_points = 12; % Limit point selection to exactly 12

% ---- Select points for first image ----
disp('Select exactly 12 feature points in the Young image.');
figure, imshow(img1), title('Select 12 points in Young image');
hold on;
points1 = zeros(num_points, 2); % Pre-allocate memory

for i = 1:num_points
    [x, y] = ginput(1); % Capture one point at a time
    points1(i, :) = [x, y];
    plot(x, y, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); % Display point
    drawnow; % Update plot immediately
end
hold off;
pause(0.5); % Small pause for clarity
close; % Close the first image automatically

% ---- Select points for second image ----
disp('Select exactly 12 corresponding feature points in the Old image.');
figure, imshow(img2), title('Select 12 points in Old image');
hold on;
points2 = zeros(num_points, 2); % Pre-allocate memory

for i = 1:num_points
    [x, y] = ginput(1); % Capture one point at a time
    points2(i, :) = [x, y];
    plot(x, y, 'go', 'MarkerSize', 5, 'MarkerFaceColor', 'g'); % Display point
    drawnow; % Update plot immediately
end
hold off;
pause(0.5); % Small pause for clarity
close; % Close the second image automatically

% ---- Add boundary points ----
boundary_pts = [0, 0; img_size(2)/2, 0; img_size(2), 0;
                0, img_size(1)/2; img_size(2), img_size(1)/2;
                0, img_size(1); img_size(2)/2, img_size(1); img_size(2), img_size(1)];
points1 = [points1; boundary_pts];
points2 = [points2; boundary_pts];

% ---- Compute Delaunay triangulation ----
triangles = delaunay(points1(:,1), points1(:,2));

% ---- Morphing ----
alpha = 0.5;
morphed_points = (1 - alpha) * points1 + alpha * points2;
morphed_img = uint8(zeros(size(img1))); % Initialize output image

for i = 1:size(triangles, 1)
    tri1 = points1(triangles(i, :), :);
    tri2 = points2(triangles(i, :), :);
    tri_morphed = morphed_points(triangles(i, :), :);
    
    % ---- Compute affine transformation ----
    if exist('fitgeotrans', 'file') % Use fitgeotrans if available
        T1 = fitgeotrans(tri1, tri_morphed, 'affine');
        T2 = fitgeotrans(tri2, tri_morphed, 'affine');
    else % Manually construct the affine transformation matrix
        A1 = [tri1, ones(3,1)] \ [tri_morphed, ones(3,1)]; % 3x3 matrix
        A2 = [tri2, ones(3,1)] \ [tri_morphed, ones(3,1)];
        T1 = affine2d(A1'); % Convert to transformation object
        T2 = affine2d(A2');
    end

    % Get bounding box of morphed triangle
    x_min = min(tri_morphed(:,1));
    x_max = max(tri_morphed(:,1));
    y_min = min(tri_morphed(:,2));
    y_max = max(tri_morphed(:,2));

    % Ensure valid bounds
    x_min = max(1, floor(x_min));
    y_min = max(1, floor(y_min));
    x_max = min(img_size(2), ceil(x_max));
    y_max = min(img_size(1), ceil(y_max));

    % Create mask for the triangle
    mask = poly2mask(tri_morphed(:,1), tri_morphed(:,2), img_size(1), img_size(2));

    % Warp the images using imwarp (instead of deprecated imtransform)
    warp1 = imwarp(img1, T1, 'OutputView', imref2d(size(img1)));
    warp2 = imwarp(img2, T2, 'OutputView', imref2d(size(img2)));

    % Ensure both warped images are valid
    if size(warp1, 3) == 1
        warp1 = repmat(warp1, [1 1 3]); % Convert grayscale to RGB
    end
    if size(warp2, 3) == 1
        warp2 = repmat(warp2, [1 1 3]); % Convert grayscale to RGB
    end

    % Blend triangles
    blended = (1 - alpha) * double(warp1) + alpha * double(warp2);
    blended = uint8(blended);

    % Apply the mask only to the bounding region
    for ch = 1:3
        channel = morphed_img(y_min:y_max, x_min:x_max, ch);
        blend_region = blended(y_min:y_max, x_min:x_max, ch);
        channel(mask(y_min:y_max, x_min:x_max)) = blend_region(mask(y_min:y_max, x_min:x_max));
        morphed_img(y_min:y_max, x_min:x_max, ch) = channel;
    end
end

% Display and save final morphed image
figure, imshow(morphed_img), title('Final Morphed Image');
imwrite(morphed_img, 'final_morphed.png');
