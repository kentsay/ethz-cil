function I_rec = inPainting(I, mask)

% Perform the actual inpainting of the image 

% INPUT
% I: (n x n) masked image
% mask: (n x n) the mask hidding image information
%
% OUTPUT
% I_rec = Reconstructed image 


% Reconstruct image using smoothing to fill in pixels
%I_rec = prioritysmoothing(I, mask, ones(size(I)), 1, 0.8);
%priority_mask = (edge(I_rec, 'canny') + 1) .* 0.5;
%I_rec = prioritysmoothing(I, mask, priority_mask, 3, 0.8);

I_rec = diffusion_inpainting(I, mask, 50);
%I_rec = I_rec(3:514, 3:514);

%yolo = 420;


