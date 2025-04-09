clc; clear;

% Read the two input images
I1 = imread('young.jpg');  % First image
I1 = imresize(I1, [224,224]);  % Resize the first image
I2 = imread('old.jpg');  % Second image
I2 = imresize(I2, [224,224]);  % Resize the second image

%% Process the first image (I1)
[imgFace1, LeftEye1, RightEye1, Mouth1, LeftEyebrow1, RightEyebrow1] = detectFacialRegions(I1);
confland = 5;  % Landmark setting to Eyes and Mouth (4 and 5)
conflandEyebrow = 2;  % Landmarks setting for Eyebrows (only 2)

% Left eye landmarks for I1
imgLEye1 = (imgFace1(LeftEye1(1,2):LeftEye1(1,2)+LeftEye1(1,4), LeftEye1(1,1):LeftEye1(1,1)+LeftEye1(1,3), :));
[landLeftEye1, leftEyeCont1] = eyesProcessing(imgLEye1, confland);

% Right eye landmarks for I1
imgREye1 = (imgFace1(RightEye1(1,2):RightEye1(1,2)+RightEye1(1,4), RightEye1(1,1):RightEye1(1,1)+RightEye1(1,3), :));
[landRightEye1, rightEyeCont1] = eyesProcessing(imgREye1, confland);

% Mouth landmarks for I1
imgLips1 = (imgFace1(Mouth1(1,2):Mouth1(1,2)+Mouth1(1,4), Mouth1(1,1):Mouth1(1,1)+Mouth1(1,3), :));
[landMouth1, MouthCont1] = mouthProcessing(imgLips1, confland);

% Left eyebrow landmarks for I1
imgLEyebrow1 = (imgFace1(LeftEyebrow1(1,2):LeftEyebrow1(1,2)+LeftEyebrow1(1,4), LeftEyebrow1(1,1):LeftEyebrow1(1,1)+LeftEyebrow1(1,3), :));
[landLEyebrow1, leftEyebrowCont1] = eyebrowsProcessing(imgLEyebrow1, conflandEyebrow);

% Right eyebrow landmarks for I1
imgREyebrow1 = (imgFace1(RightEyebrow1(1,2):RightEyebrow1(1,2)+RightEyebrow1(1,4), RightEyebrow1(1,1):RightEyebrow1(1,1)+RightEyebrow1(1,3), :));
[landREyebrow1, RightEyebrowCont1] = eyebrowsProcessing(imgREyebrow1, conflandEyebrow);

%% Process the second image (I2) (Repeat similar steps as for I1)
[imgFace2, LeftEye2, RightEye2, Mouth2, LeftEyebrow2, RightEyebrow2] = detectFacialRegions(I2);

% Left eye landmarks for I2
imgLEye2 = (imgFace2(LeftEye2(1,2):LeftEye2(1,2)+LeftEye2(1,4), LeftEye2(1,1):LeftEye2(1,1)+LeftEye2(1,3), :));
[landLeftEye2, leftEyeCont2] = eyesProcessing(imgLEye2, confland);

% Right eye landmarks for I2
imgREye2 = (imgFace2(RightEye2(1,2):RightEye2(1,2)+RightEye2(1,4), RightEye2(1,1):RightEye2(1,1)+RightEye2(1,3), :));
[landRightEye2, rightEyeCont2] = eyesProcessing(imgREye2, confland);

% Mouth landmarks for I2
imgLips2 = (imgFace2(Mouth2(1,2):Mouth2(1,2)+Mouth2(1,4), Mouth2(1,1):Mouth2(1,1)+Mouth2(1,3), :));
[landMouth2, MouthCont2] = mouthProcessing(imgLips2, confland);

% Left eyebrow landmarks for I2
imgLeftEyebrow2 = (imgFace2(LeftEyebrow2(1,2):LeftEyebrow2(1,2)+LeftEyebrow2(1,4), LeftEyebrow2(1,1):LeftEyebrow2(1,1)+LeftEyebrow2(1,3), :));
[landLEyebrow2, leftEyebrowCont2] = eyebrowsProcessing(imgLeftEyebrow2, conflandEyebrow);

% Right eyebrow landmarks for I2
imgREyebrow2 = (imgFace2(RightEyebrow2(1,2):RightEyebrow2(1,2)+RightEyebrow2(1,4), RightEyebrow2(1,1):RightEyebrow2(1,1)+RightEyebrow2(1,3), :));
[landREyebrow2, RightEyebrowCont2] = eyebrowsProcessing(imgREyebrow2, conflandEyebrow);

%% Display both images side by side with landmarks

figure;
subplot(1,2,1); imshow(imgFace1, 'InitialMagnification', 50); hold on;
title('Landmarks on First Image');
showsLandmarks(landLeftEye1, leftEyeCont1, LeftEye1, confland);
showsLandmarks(landRightEye1, rightEyeCont1, RightEye1, confland);
showsLandmarks(landMouth1, MouthCont1, Mouth1, confland);
showsLandmarks(landLEyebrow1, leftEyebrowCont1, LeftEyebrow1, conflandEyebrow);
showsLandmarks(landREyebrow1, RightEyebrowCont1, RightEyebrow1, conflandEyebrow);

subplot(1,2,2); imshow(imgFace2, 'InitialMagnification', 50); hold on;
title('Landmarks on Second Image');
showsLandmarks(landLeftEye2, leftEyeCont2, LeftEye2, confland);
showsLandmarks(landRightEye2, rightEyeCont2, RightEye2, confland);
showsLandmarks(landMouth2, MouthCont2, Mouth2, confland);
showsLandmarks(landLEyebrow2, leftEyebrowCont2, LeftEyebrow2, conflandEyebrow);
showsLandmarks(landREyebrow2, RightEyebrowCont2, RightEyebrow2, conflandEyebrow);

%% Optionally, extract and display the coordinates of the landmarks
LEyecoord1 = Landmarks(landLeftEye1, leftEyeCont1, LeftEye1, confland);
REyecoord1 = Landmarks(landRightEye1, rightEyeCont1, RightEye1, confland);
Lipscoord1 = Landmarks(landMouth1, MouthCont1, Mouth1, confland);
LEyebrowcoord1 = Landmarks(landLEyebrow1, leftEyebrowCont1, LeftEyebrow1, conflandEyebrow);
REyebrowcoord1 = Landmarks(landREyebrow1, RightEyebrowCont1, RightEyebrow1, conflandEyebrow);

LEyecoord2 = Landmarks(landLeftEye2, leftEyeCont2, LeftEye2, confland);
REyecoord2 = Landmarks(landRightEye2, rightEyeCont2, RightEye2, confland);
Lipscoord2 = Landmarks(landMouth2, MouthCont2, Mouth2, confland);
LEyebrowcoord2 = Landmarks(landLEyebrow2, leftEyebrowCont2, LeftEyebrow2, conflandEyebrow);
REyebrowcoord2 = Landmarks(landREyebrow2, RightEyebrowCont2, RightEyebrow2, conflandEyebrow);

