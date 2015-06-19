# Dictionary learning
The dictionary learning uses a pre-learnt dictionary to compute a sparse-coding representation of an image.
To learn the dictionary, we use an online algorithm based on the work done by Julien Mairal Francis Bach Jean Ponce and Guillermo Sapiro in their paper "Online Dictionary Learning for Sparse Coding".

## Learning the dictionary
The script called "createDict.m" triggers the dictionary learning. The user has to make sure of two things:
1) Delete any occurences of "dictionary.mat" 
2) Run the script from inside the trainingset folder.

## Notes
The trainingset folder contains the pictures we used for training. This algorithm was not used as a baseline comparison because there was some overlap in the trainingset and the data-set used for the results. This caused the learned dictionary to overfit.
