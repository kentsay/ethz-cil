# Inpainting

We totally implemented 7 inpainting algorithms. Note that `dicitonary_learning` was not used in our baseline. Each sub-folder contains an `inPaining.m` function which implements the actual in-painting.

## Data and mask
The data folder contains 17 pictures used for the validation and the generation of the results used in our paper. The mask folder contains all the masks used.

## Results
The results folder contains all the results for each algorithm in a `.mat` file. Each algorithm has two files associated to it. One for the randomly generated masks and one for the text mask. In this folder you will also  find a script plots.m which generates the plots used in the paper.

To generate the results run the `experiments.m` script. The user can declare which algorithms he wants to run and which masks he wants to use. The two options are `mask/rand_masks` and `mask/text_mask`.

