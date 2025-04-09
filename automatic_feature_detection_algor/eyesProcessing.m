function [V, CONT] = eyesProcessing(imgEye, landcont)

% adjust the contrast of the image
lims = stretchlim(imgEye);
adjust = imadjust(imgEye,lims,[]);
% increase the size of the original image
resizeeyes = 9;
EyeLine = floor(length(adjust(:,1,1))*resizeeyes);
EyeCol =  floor(length(adjust(1,:,1))*resizeeyes);
% original image adjusted
picEyeImg = imresize(imgEye,[EyeLine,EyeCol],'bilinear');
% eliminating the skin region
cform = makecform('srgb2lab');
J = applycform(picEyeImg,cform);
L=graythresh(J(:,:,2));
eyeBW=imbinarize(J(:,:,2),L);
M=graythresh(J(:,:,3));
eyeBW2=imbinarize(J(:,:,3),M);
O=eyeBW.*eyeBW2;
P=bwlabel(O,8);
BB=regionprops(P,'Boundingbox');
BB1=struct2cell(BB);
BB2=cell2mat(BB1);
[s1 s2]=size(BB2);
mx=0;
for kRight=3:4:s2-1
    p=BB2(1,kRight)*BB2(1,kRight+1);
    if p>mx && (BB2(1,kRight)/BB2(1,kRight+1))<1.8
        mx=p;
    end
end
% selecting the area of interest using blob
eyecomplement = imcomplement(eyeBW2);
ccEye = bwconncomp(eyecomplement);
statsEye = regionprops(ccEye,'Area');
EyeIdx = find([statsEye.Area] == max([statsEye.Area]));
EyeEst = ismember(labelmatrix(ccEye), EyeIdx);
% dilated image
seEye = strel('line',10,0);
EyeI2 = imdilate(EyeEst,seEye);
% filling holes
BWdfilleye = imfill(EyeI2, 'holes');
cannyEye = edge(BWdfilleye,'canny',0.4);
[V, CONT] = detectLandmarks(cannyEye,resizeeyes,landcont);
end