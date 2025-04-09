% Load and preprocess image
img = imread('./maggie_smith/old.png');  % Replace with your image
img = imresize(img, [500 500]);
img = rgb2gray(img);

% Display image and select points
figure;
imshow(img); hold on;
title('Facial Landmark Triangulation');

% Manually select 17 keypoints
num_points = 17;
userPoints = zeros(num_points, 2);
for i = 1:num_points
    [x, y] = ginput(1);
    userPoints(i, :) = [x, y];
    plot(x, y, 'go', 'MarkerFaceColor', 'g');  % Red points
end

% Add boundary points
boundary_pts = [0, 0; 250, 0; 500, 0;
                0, 250; 500, 250;
                0, 500; 250, 500; 500, 500];
allPoints = [userPoints; boundary_pts];

% Compute and plot Delaunay triangulation
tri = delaunay(allPoints(:,1), allPoints(:,2));
triplot(tri, allPoints(:,1), allPoints(:,2), 'g');  % Green triangles

% Optional: Label point indices
for i = 1:size(allPoints,1)
    text(allPoints(i,1)+5, allPoints(i,2), num2str(i), 'Color', 'yellow');
end

