The learning dictionary is dependent on a dictionary which is previously learned.
We use an online algorithm based on the work done by Julien Mairal Francis Bach Jean Ponce and Guillermo Sapiro
in their paper "Online Dictionary Learning for Sparse Coding".

Thee is a script called "createDict.m" which triggers the dictionary learning. The user has to make sure of two things:
1) Delete any occurences of "dictionary.mat" 
2) Run the script from inside the trainingset folder.

The trainingset folder contains the pictures used for the training. The reason this algorithm was not used is 
that there was some overlap in the trainingset and the data-set used for the resutls. This created an overfitting effecct which 
biased the results.
