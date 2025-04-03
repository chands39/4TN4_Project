function sliderMorphApp()
    % Create UI figure
    fig = uifigure('Name', 'Age Morphing Slider', 'Position', [100 100 1000 600]);

    % Global variables
    global img1 img2 points1 points2 morphedAxes img_size alpha tri p1 p2
    img1 = []; img2 = [];
    points1 = []; points2 = [];
    img_size = [500 500];
    alpha = 0.5;

    % Status labels
    youngStatus = uilabel(fig, 'Text', 'Young image: Not loaded', ...
        'Position', [30 490 300 20], 'FontColor', 'red');

    oldStatus = uilabel(fig, 'Text', 'Old image: Not loaded', ...
        'Position', [200 490 300 20], 'FontColor', 'red');

    % Upload buttons
    uibutton(fig, 'Text', 'Upload Young Image', ...
        'Position', [30 520 150 30], ...
        'BackgroundColor', '#0072BD', 'FontColor', 'w', ...
        'ButtonPushedFcn', @(btn, event) uploadImage('young'));

    uibutton(fig, 'Text', 'Upload Old Image', ...
        'Position', [200 520 150 30], ...
        'BackgroundColor', '#0072BD', 'FontColor', 'w', ...
        'ButtonPushedFcn', @(btn, event) uploadImage('old'));

    % Select points
    uibutton(fig, 'Text', 'Select Feature Points', ...
        'Position', [30 450 320 30], ...
        'BackgroundColor', '#EDB120', ...
        'ButtonPushedFcn', @(btn, event) selectPoints());

    % Slider
    uilabel(fig, 'Text', 'Age Progression', 'Position', [30 400 120 20]);
    slider = uislider(fig, ...
        'Position', [30 380 300 3], ...
        'Limits', [0 1], ...
        'Value', alpha, ...
        'MajorTicks', [0 0.5 1], ...
        'ValueChangedFcn', @(sld, event) updateMorph(sld.Value), ...
        'ValueChangingFcn', @(sld, event) updateMorph(event.Value));

    % Display axes
    morphedAxes = uiaxes(fig, 'Position', [380 50 580 500]);
    morphedAxes.XTick = []; morphedAxes.YTick = [];

    % --- Upload Image Function ---
    function uploadImage(which)
        [file, path] = uigetfile({'*.jpg;*.jpeg;*.png'}, ['Select ', which, ' image']);
        if isequal(file, 0); return; end
        img = imread(fullfile(path, file));
        if size(img,3) == 1; img = repmat(img, 1, 1, 3); end
        img = imresize(img, img_size);
        if strcmp(which, 'young')
            img1 = img;
            youngStatus.Text = 'Young image: Loaded ✔';
            youngStatus.FontColor = 'green';
        else
            img2 = img;
            oldStatus.Text = 'Old image: Loaded ✔';
            oldStatus.FontColor = 'green';
        end
    end

    % --- Select Points Function ---
    function selectPoints()
        if isempty(img1) || isempty(img2)
            uialert(fig, 'Upload both images first.', 'Missing Input');
            return;
        end

        figure, imshow(img1), title('Select 17 points in Young image');
        for i = 1:17
            [x, y] = ginput(1);
            points1(i,:) = [x, y];
            hold on; plot(x, y, 'ro'); drawnow;
        end
        close;

        figure, imshow(img2), title('Select 17 points in Old image');
        for i = 1:17
            [x, y] = ginput(1);
            points2(i,:) = [x, y];
            hold on; plot(x, y, 'go'); drawnow;
        end
        close;

        boundary_pts = [0, 0; 250, 0; 500, 0; 0, 250; 500, 250; 0, 500; 250, 500; 500, 500];
        p1 = [points1; boundary_pts];
        p2 = [points2; boundary_pts];
        tri = delaunay(p1(:,1), p1(:,2));

        updateMorph(alpha);
    end

    % --- Morphing Function ---
    function updateMorph(a)
        alpha = a;
        if isempty(tri); return; end

        morphed_points = (1 - alpha) * p1 + alpha * p2;
        morphed_img = uint8(zeros([img_size 3]));

        for i = 1:size(tri,1)
            tri1 = p1(tri(i,:), :);
            tri2 = p2(tri(i,:), :);
            tri_morphed = morphed_points(tri(i,:), :);

            try
                T1 = fitgeotrans(tri1, tri_morphed, 'affine');
                T2 = fitgeotrans(tri2, tri_morphed, 'affine');
            catch
                continue;
            end

            mask = poly2mask(tri_morphed(:,1), tri_morphed(:,2), img_size(1), img_size(2));
            warp1 = imwarp(img1, T1, 'OutputView', imref2d(img_size));
            warp2 = imwarp(img2, T2, 'OutputView', imref2d(img_size));
            blended = (1 - alpha) * double(warp1) + alpha * double(warp2);
            blended = uint8(blended);

            for ch = 1:3
                region = morphed_img(:,:,ch);
                temp = blended(:,:,ch);
                region(mask) = temp(mask);
                morphed_img(:,:,ch) = region;
            end
        end

        imshow(morphed_img, 'Parent', morphedAxes);
        drawnow;
    end
end
