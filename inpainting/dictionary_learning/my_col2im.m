function I_rec = my_col2im(X, patch, im_size)

% Provides the functionality of col2im function of the image processing
% toolbox.
%
% INPUT
% X: (d x n) observations matrix. Obviously d=patch*patch and n is the 
%            number of patches extracted
% patch: The size of the square patches extracted
% im_size: Size of the original image 
%
% OUTPUT
% I_rec: image
I_rec = zeros(im_size, im_size);
for i = 1:im_size/patch
   for j = 1:im_size/patch
       mypatch = X(:, ((i-1)*im_size/patch) + j);
       x = reshape(mypatch, patch, patch);
       I_rec( 1+(i-1)*patch:i*patch, 1+(j-1)*patch:j*patch ) = x;
   end
end

% It will only work for orthogonal matrices and exact patches coverage
