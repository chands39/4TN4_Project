function [V,CONT] = eyebrowsProcessing(imgEyebrow, landcont)


%image into grayscale and equalize histogram
EyebrowGray = rgb2gray(imgEyebrow);
EyebrowHist= histeq (EyebrowGray);
EyebrowLim = stretchlim(EyebrowHist);
EyebrowAdjust = imadjust(EyebrowHist,EyebrowLim,[]);
    
% increasing the size of the original image
resizeyebrow  = 8;
EyebrowLin = floor(length(EyebrowHist(:,1,1))*resizeyebrow);
EyebrowCol =  floor(length(EyebrowHist(1,:,1))*resizeyebrow);
picEyebrow= imresize(EyebrowAdjust,[EyebrowLin,EyebrowCol],'bilinear');
    
% binarized image
EyebrowBW1 = imbinarize(picEyebrow,0.46);
    
% binarized image inverting
EyebrowBW2 = imcomplement(EyebrowBW1);
    
% dilated image
seEyebrow = strel('line',10,0);
EyebrowI2 = imdilate(EyebrowBW2 ,seEyebrow);
    
% preenchendo buracos
fillHoles = imfill(EyebrowI2, 'holes');
       
% selecting the area of interest using blob
ccEyebrow = bwconncomp(fillHoles);
statsEyebrow = regionprops(ccEyebrow,'Area');
EyebrowIdx = find([statsEyebrow.Area] == max([statsEyebrow.Area]));
EyebrowBW3 = ismember(labelmatrix(ccEyebrow), EyebrowIdx);
% applying canny
cannyEyebrow = edge(EyebrowBW3,'canny');
    
[V, CONT] = detectLandmarks(cannyEyebrow,resizeyebrow,landcont);
end
