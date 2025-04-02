function  [imgFace, LeftEye, RightEye, Mouth, LeftEyebrow,  RightEyebrow] = detectFacialRegions(I)

%To detect Face
 FDetect = vision.CascadeObjectDetector;
 Face = step(FDetect,I);
 imgFace = (I(Face(1,2):Face(1,2)+Face(1,4),Face(1,1):Face(1,1)+Face(1,3),:));
 %To detect Left Eye
 DetectEye = vision.CascadeObjectDetector('LeftEye');
 Eye=step(DetectEye,imgFace);
 LeftEye  = Eye(1,:);
 
 %To detect Right Eye
 DetectEye = vision.CascadeObjectDetector('RightEye');
 Eye=step(DetectEye,imgFace);
 RightEye = Eye(2,:);
 
 %To detect Mouth
 DetectMouth = vision.CascadeObjectDetector('/Users/haze/Desktop/Skool/Image_Processing/DSmorphing+tests/IntTest/haarcascade_smile.xml');
 findMouth=step(DetectMouth,imgFace);
 orderMouth= sortrows(findMouth,2);
 posMouth = size(findMouth,1);
 Mouth = orderMouth(posMouth,:);
%To detect Left Eyebrow
 LeftEyebrow   = LeftEye;
 LeftEyebrow(4) = (LeftEyebrow(4)/2)-4;
 LeftEyebrow(3) = LeftEyebrow(3);
 LeftEyebrow(4) = uint8(LeftEyebrow(4));
 LeftEyebrow(3) = uint8(LeftEyebrow(3));
%To detect Right Eyebrow
 RightEyebrow  = RightEye;
 RightEyebrow(4) =  (RightEyebrow(4)/2);
 RightEyebrow(3) = RightEyebrow(3);
 RightEyebrow(4) = uint8(RightEyebrow(4));
 RightEyebrow(3) = uint8(RightEyebrow(3));
end
