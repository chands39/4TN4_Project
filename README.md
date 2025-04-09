4TN4 Project 2: Face  Morphing Algorithm for Intermediate Age Progression
By: Shathurshika Chandrakumar & Hazel Al Afif 

To run automatic feature detection:
> run ./automatic_feature_detection_algor/test.m
> change image path in test.m to choose which test images

To run morphing algorithm GUI:
> run ./morphing_algor/face_morphing_GUI.m
> upload young and old images from test folders in same directory using GUI buttons
> ![image](https://github.com/user-attachments/assets/119131e7-3872-43c7-a224-c32d3bbc5329)
> after uploading both images, press "Select Feature Points" button
> in window pop up, select facial landmark points as follows (face countours, inner and outer eye points, noise, mouth)
  > ![image](https://github.com/user-attachments/assets/51ff175a-db06-485f-9770-1de2d1e25b07)
  > NOTE: make sure to select the points on both images in same order, otherwise morphing will be incorrect
> use Age Progression slider to change alpha value to change the age of the image (alpha at 0 being youngest, and alpha at 1 being oldest age progression)
