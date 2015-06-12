function X = my_im2col(I, patch)

% Provides the functionality of im2col function of the image processing
% toolbox.
%
% INPUT
% I: image
% patch: The size of the square patches extracted
% 
% OUTPUT
% X: (d x n) observations matrix. Obviously d=patch*patch and n is the 
%            number of patches extracted

% You can write a for-loop to extract the patches one by one and then 
% transform each patch to an 1D signal sequentially
% creating matrix X
[nrows,ncols] = size(I);
nrow_patch = nrows/patch;
ncols_patch = ncols/patch;
d = patch*patch;
l = nrow_patch*ncols_patch;
X = zeros(d,l);

counter = 1;
for i = 1:nrow_patch
    for j = 1:ncols_patch
        t1 = I( [patch*(i-1)+1:i*patch], [(j-1)*patch+1:j*patch]);
        t2 = t1(:);
        X(:,counter) = t2;
        counter = counter + 1;
    end
end

% TO BE FILLED