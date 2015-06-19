function I_rec = inPainting(I, mask)

% Perform the actual inpainting of the image by using directional diffusion

% INPUT
% I: (n x n) masked image
% mask: (n x n) the mask hidding image information
%
% OUTPUT
% I_rec = Reconstructed image 

%% Set parameters and construct diffusion kernel
I_rec = I;
I_rec(mask==0) = mean(mean(I_rec));
threshold = 0.00001;
K = 1/4 * [0 1 0;
           1 0 1;
           0 1 0];

%% Iteratively diffuse pixels
%  Keep diffusing pixels until the frobenius norm between the previous and
%  the current image falls below a threshold
[I_old, I_rec] = diffuse(I_rec, mask, I, K);
while norm(abs(I_rec - I_old), 'fro') > threshold
    [I_old, I_rec] = diffuse(I_rec, mask, I, K);
end

%% Compute directionality of all image patches
patch_size = 32;
patch_directionality = blockproc(I_rec, [patch_size patch_size], ...
    @(P) computeDirectionality(P), ...
    'BorderSize', [1 1], ...
    'PadMethod', 'replicate', ...
    'TrimBorder', false);

%% Compute per-patch kernels based on directionality
K_diag = eye(3) * 8 + ones(3);
K_diag(2,2) = 0;
K_diag = K_diag / sum(sum(K_diag));
kernels = zeros(size(patch_directionality, 1), size(patch_directionality, 2), 3, 3);
for i = 1:size(I_rec, 1)/patch_size
    for j = 1:size(I_rec, 2)/patch_size
        K_rotated = imrotate(K_diag, patch_directionality(j, i) + 45, 'bicubic', 'crop');
        K_rotated = K_rotated / sum(sum(K_rotated));
        kernels(i, j, :, :) = K_rotated;
    end
end

%% Apply per-patch kernels
%  Apply the directional kernels to the image
t = 15;
while t > 0
    t = t - 1;
    I_rec = blockproc(I_rec, [patch_size patch_size], ...
        @(P) localDiffuse(P, kernels, patch_size), ...
        'BorderSize', [1 1], ...
        'PadMethod', 'replicate');
    I_rec = (double(mask==0) .* I_rec) + (double(mask~=0) .* I);
end

