function I_rec = inPainting(I, mask)

% Perform the actual inpainting of the image 

% INPUT
% I: (n x n) masked image
% mask: (n x n) the mask hidding image information
%
% OUTPUT
% I_rec = Reconstructed image 


% Reconstruct image using smoothing to fill in pixels
I_rec = prioritysmoothing(I, mask, 1, 0.8);
