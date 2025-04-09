function  [imgFace, LeftEye, RightEye, Mouth, LeftEyebrow,  RightEyebrow] = detectFacialRegions(I)

%To detect Face
 FDetect = vision.CascadeObjectDetector;
 Face = step(FDetect,I);
 imgFace = (I(Face(1,2):Face(1,2)+Face(1,4),Face(1,1):Face(1,1)+Face(1,3),:));
 imggray = rgb2gray(imgFace);
 imshow(imggray)
 imghist = adapthisteq(imggray);
 imshow(imghist)
 %To detect Left Eye

 DetectEye = vision.CascadeObjectDetector('LeftEye', 'MergeThreshold', 12);
 Eye=step(DetectEye,imgFace);
 %Eye = sortrows(Eye,1);
 LeftEye  = Eye(1,:);
 
 %To detect Right Eye
 DetectEye = vision.CascadeObjectDetector('RightEye', 'MergeThreshold', 12);
 Eye=step(DetectEye,imgFace);
 RightEye = Eye(2,:);
 
 %To detect Mouth
 DetectMouth = vision.CascadeObjectDetector('./haarcascade_smile.xml', 'MergeThreshold', 12);
 findMouth=step(DetectMouth,imgFace);
 orderMouth= sortrows(findMouth,2);
 posMouth = size(findMouth,1);
 Mouth = orderMouth(posMouth,:);
%To detect Left Eyebrow
 LeftEyebrow   = LeftEye;
 %LeftEyebrow(4) = (LeftEyebrow(4)/2)-4;
 %LeftEyebrow(3) = LeftEyebrow(3);
 LeyebrowOffset = round(LeftEye(4) * 0.5); % Adjust as needed

 LeftEyebrow(2) = max(LeftEye(2) - LeyebrowOffset, 1); 

 LeftEyebrow(3) = round(LeftEye(3) * 0.95);  % Reduce width slightly
 LeftEyebrow(4) = round(LeftEye(4) * 0.5);
 LeftEyebrow(4) = uint8(LeftEyebrow(4));
 LeftEyebrow(3) = uint8(LeftEyebrow(3));
%To detect Right Eyebrow
 RightEyebrow  = RightEye;
 ReyebrowOffset = round(LeftEye(4) * 0.5); % Adjust as needed
 RightEyebrow(2) = max(RightEye(2) - ReyebrowOffset, 1);
 RightEyebrow(3) = round(RightEye(3) * 0.95);
 RightEyebrow(4) = round(RightEye(4) * 0.5);
 RightEyebrow(4) = uint8(RightEyebrow(4));
 RightEyebrow(3) = uint8(RightEyebrow(3));
 bboxes = FDetect(I);
 IFaces = insertObjectAnnotation(I,'rectangle',bboxes,'Face');   
figure
imshow(IFaces)
eyeboxes = DetectEye(I);
IEyes = insertObjectAnnotation(I,'rectangle',eyeboxes,'Eyes');   
figure
imshow(IEyes)
mouthbox = DetectMouth(I);
Imouth = insertObjectAnnotation(I,'rectangle',mouthbox,'Mouth');   
figure
imshow(Imouth)


end
