function ageProgressionApp()
    % Create main window
    fig = uifigure('Name', 'Age Progression Morphing', 'Position', [100 100 800 600]);

    % Global variables
    global img1 img2 points1 points2 saveDir
    img1 = []; img2 = [];
    points1 = []; points2 = [];
    saveDir = '';

    % Panels
    panelYoung = uipanel(fig, 'Title', 'Young Image', 'Position', [20 320 350 260]);
    panelOld   = uipanel(fig, 'Title', 'Old Image',   'Position', [400 320 350 260]);

    % Axes
    youngAxes = uiaxes(panelYoung, 'Position', [10 10 330 230]); youngAxes.XTick = []; youngAxes.YTick = [];
    oldAxes   = uiaxes(panelOld,   'Position', [10 10 330 230]); oldAxes.XTick = []; oldAxes.YTick = [];

    % Buttons
    uibutton(fig, 'Text', 'Upload Young Image', ...
        'Position', [30 250 150 30], 'BackgroundColor', '#0072BD', 'FontColor', 'w', ...
        'ButtonPushedFcn', @(btn, event) uploadImage('young', youngAxes));

    uibutton(fig, 'Text', 'Upload Old Image', ...
        'Position', [200 250 150 30], 'BackgroundColor', '#0072BD', 'FontColor', 'w', ...
        'ButtonPushedFcn', @(btn, event) uploadImage('old', oldAxes));

    uibutton(fig, 'Text', 'Select 17 Feature Points', ...
        'Position', [30 200 320 30], 'BackgroundColor', '#EDB120', ...
        'ButtonPushedFcn', @(btn, event) selectPoints());

    uibutton(fig, 'Text', 'Generate Age Progression GIF', ...
        'Position', [30 150 320 30], 'BackgroundColor', '#77AC30', 'FontColor', 'w', ...
        'ButtonPushedFcn', @(btn, event) runMorph());

    %% Upload Image
    function uploadImage(which, ax)
        [file, path] = uigetfile({'*.png;*.jpg;*.jpeg'}, ['Select ', which, ' image']);
        if isequal(file, 0); return; end
        img = imread(fullfile(path, file));
        if size(img, 3) == 1; img = cat(3, img, img, img); end
        img = imresize(img, [500 500]);
        if strcmp(which, 'young'); img1 = img; else; img2 = img; end
        saveDir = path;
        imshow(img, 'Parent', ax); drawnow;
    end

    %% Feature Point Selection
    function selectPoints()
        if isempty(img1) || isempty(img2)
            uialert(fig, 'Upload both images first.', 'Missing Input');
            return;
        end
        points1 = getPoints(img1, 'Young');
        points2 = getPoints(img2, 'Old');
        uialert(fig, 'Points selected.', 'Done');
    end

    %% Morphing + GIF generation
    function runMorph()
        if isempty(points1) || isempty(points2)
            uialert(fig, 'Please select points first.', 'Missing Points');
            return;
        end

        boundary_pts = [0, 0; 250, 0; 500, 0; 0, 250; 500, 250; 0, 500; 250, 500; 500, 500];
        p1 = [points1; boundary_pts];
        p2 = [points2; boundary_pts];
        tri = delaunay(p1(:,1), p1(:,2));
        alphas = linspace(0, 1, 30);
        gif_filename = fullfile(saveDir, 'age_progression.gif');

        waitbarHandle = waitbar(0, 'Generating GIF...');
        for idx = 1:length(alphas)
            alpha = alphas(idx);
            p_morph = (1 - alpha) * p1 + alpha * p2;
            morphed_img = uint8(zeros(size(img1)));

            for i = 1:size(tri,1)
                tri1 = p1(tri(i,:), :);
                tri2 = p2(tri(i,:), :);
                tri_morphed = p_morph(tri(i,:), :);
                try
                    T1 = fitgeotrans(tri1, tri_morphed, 'affine');
                    T2 = fitgeotrans(tri2, tri_morphed, 'affine');
                catch
                    continue;
                end
                mask = poly2mask(tri_morphed(:,1), tri_morphed(:,2), 500, 500);
                warp1 = imwarp(img1, T1, 'OutputView', imref2d([500 500]));
                warp2 = imwarp(img2, T2, 'OutputView', imref2d([500 500]));
                blended = (1 - alpha) * double(warp1) + alpha * double(warp2);
                blended = uint8(blended);

                for ch = 1:3
                    region = morphed_img(:,:,ch);
                    temp = blended(:,:,ch);
                    region(mask) = temp(mask);
                    morphed_img(:,:,ch) = region;
                end
            end

            [A, map] = rgb2ind(morphed_img, 256);
            if idx == 1
                imwrite(A, map, gif_filename, 'gif', 'LoopCount', Inf, 'DelayTime', 0.1);
            else
                imwrite(A, map, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
            end
            waitbar(idx / length(alphas), waitbarHandle);
        end
        close(waitbarHandle);

        % Show in new figure
        uialert(fig, 'GIF saved! Opening preview...', 'Complete');
        web(gif_filename); % 

    end

    %% Point Picker
    function pts = getPoints(img, label)
        figure('Name', [label ' Image']), imshow(img), title(['Select 17 points in ', label]);
        pts = zeros(17,2);
        for i = 1:17
            [x, y] = ginput(1);
            pts(i,:) = [x, y];
            hold on; plot(x, y, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); drawnow;
        end
        close;
    end
end
