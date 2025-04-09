# 4TN4 Project 2: Face Morphing Algorithm for Intermediate Age Progression  
**Authors:** Shathurshika Chandrakumar & Hazel Al Afif  

This project implements a MATLAB-based face morphing tool to simulate intermediate age progression between two facial images — transitioning from a young face to an older version of the same individual.

---

## 🔧 How to Use

### 1. Automatic Feature Detection (Optional)

To test the automatic facial feature detection:
(test images are in ./automatic_feature_detection_algor/test_images. To change the test images tested, go to test.m and change path to two input images in lines 4 & 6)

Run in MATLAB: 
> cd automatic_feature_detection_algor\
> Test

### 2. Face Morphing for Age Progression GUI

To open GUI, run in MATLAB: 
> cd morphing_algor\
> face_morphing_GUI

Upload young and old images from ./morphing_algor/age_progression_tests/ or ./morphing_algor/normal_tests/ in GUI by selecting "Upload Young Image" and "Upload Old Image" buttons
![image](https://github.com/user-attachments/assets/555c1b12-58f1-4243-8581-ad63379a1575)

Click "Select Feature Points" button to manually select landmarks
In pop-up window, use cursor to select landmark points as seen below for both images. 
![image](https://github.com/user-attachments/assets/c279dae9-87e1-4aee-a2e5-5107ca452923)
NOTE: Select the landmarks in the same order and postion for both images, otherwise morphing will be incorrect

Use the "Age Progression" slider to change alpha from 0 to 1 and show the age progression of the individual. Alpha closer to 0 will give younger looking image, and alpha closer to 1 will give older looking image. 
![image](https://github.com/user-attachments/assets/97953a49-c89e-410d-918e-f448cc84dc00)




