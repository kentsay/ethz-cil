function I_rec = inPainting(I, mask)

% Perform the actual inpainting of the image by using difussion

% INPUT
% I: (n x n) masked image
% mask: (n x n) the mask hidding image information
%
% OUTPUT
% I_rec = Reconstructed image 

I_rec = I;
I_rec(mask==0) = mean(mean(I_rec));

%% Set parameters and construct diffusion kernel
threshold = 0.001;
iterations = 90;
K = fspecial('gauss');

%% Iteratively diffuse pixels
%  Keep diffusing pixels until the frobenius norm between the previous and
%  the current image falls below a threshold
[I_old, I_rec] = diffuse(I_rec, mask, I, K);
while norm(abs(I_rec - I_old), 'fro') > threshold && iterations >= 0
    iterations = iterations - 1;
    [I_old, I_rec] = diffuse(I_rec, mask, I, K);
end


