function [V, CONT] = mouthProcessing(imgMouth, landcont)

% applying Gaussian filter
GaussianFilter= fspecial('gaussian',[5 5],2);
Ig = imfilter(imgMouth,GaussianFilter,'same');
    
% resizing the image
resizemouth = 3;
lines = floor(length(Ig(:,1,1))*resizemouth);
cols =  floor(length(Ig(1,:,1))*resizemouth);
pic = imresize(Ig,[lines,cols],'bilinear');
% separating the image components (HSV)
hsv = rgb2hsv(pic); 
[h,s,v] = rgb2hsv(pic);
   
% Erode Hue
se = strel('disk',5);  
erodedHue = imerode(h,se);
    
% Dilate Hue
se = strel('disk',8);
dilatedErodedHue = imdilate(erodedHue,se);
% convert image to binary
bw = imbinarize(dilatedErodedHue,graythresh(dilatedErodedHue));
    
% finding and selecting blob
cc = bwconncomp(bw);
stats = regionprops(cc,'Area');
idx = find([stats.Area] == max([stats.Area]));
BW6 = ismember(labelmatrix(cc), idx);
   
cannyMouth = edge(BW6,'canny',0.4);
 
[V ,CONT] = detectLandmarks(cannyMouth, resizemouth,landcont);
end