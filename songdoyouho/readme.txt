flow of my code
1. optical flow
2. motion decomposition
3. k-means for sparse trajectories
4. extract feature
5. train and encode fisher vector and darwin vector
6. SVM

overall code is KAImain.m

change your toobox path in KAImain.m first, toolboxes are include in the rar file

compile the exe file from iscameramotion_no_homo_1.cpp in improved_trajectory_release folder for extract features
(I use opencv 2.4.9)

'draw' folder must include in matlab path for calculating accuracy and confusion matrix

dogcentric and jpl dataset are included with my label, the label is different from the original file 

A_B.avi -> A = label, B = action number 

------------------------------------------------------------------------------------------------

TVL1_XXX.m for usual coding, if you want to test a part of my process step by step, i suggest you use these codes 

others for testing algorithm like k-means in paper Section 4.7 (testkmean.m) 
or forward and backward error in Section 4.6 (allforeandback.m)

draw trajectory code and detail command also provide with title draw_XXX.m

if you have problem, find kai (songdoyouho@gmail.com)

