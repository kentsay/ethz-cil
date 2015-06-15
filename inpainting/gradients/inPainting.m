function I_rec = inPainting(I, mask)

% Perform the actual inpainting of the image by using difussion

% INPUT
% I: (n x n) masked image
% mask: (n x n) the mask hidding image information
%
% OUTPUT
% I_rec = Reconstructed image 

%% Set parameters and construct diffusion kernel
I_rec = I;
I_rec(mask==0) = mean(mean(I_rec));
threshold = 0.0005;
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

%% Compute gradients of image patches
%  With this we know the directionality of patches in images
patch_size = 64;
[gradients, weights] = imagePatchGradients(I_rec, patch_size);

%% Compute kernels based on gradients
%  This computes kernels that are rotated according to the patch gradients
arrow = eye(patch_size);
figure;
imshow(I_rec);
hold on;
K_rotate = zeros(3, 3, size(gradients,1), size(gradients,2));
for x = 1:patch_size:size(I_rec,1)
    for y = 1:patch_size:size(I_rec,2)
        i = 1 + (x - 1) / patch_size;
        j = 1 + (y - 1) / patch_size;
        
        % Construct directional kernel for this patch
        K_patch = eye(3) * 5 + ones(3);
        K_patch(2,2) = 0;
        K_patch = imrotate(K_patch, gradients(i,j) - 45, 'nearest', 'crop');
        %K_patch = K_patch .* weights(i,j) + K .* (1 - weights(i,j));
        K_patch = K_patch ./ sum(sum(K_patch));
        K_rotate(:, :, i, j) = K_patch;
        
        % Draw arrow
        arrow_r = imrotate(arrow, gradients(i,j) - 45, 'nearest', 'crop');
        h = imagesc([y y+patch_size], [x x+patch_size], arrow_r);
        %imagesc([y y+5], [x x+5], K_patch);
        set(h, 'AlphaData', weights(i,j) * 0.6);
    end
end

%% Apply per-patch kernels
%  Apply the directional kernels to the image
t = 10;
while t > 0
    t = t - 1;
    for i = 1:floor(size(I_rec) / patch_size)
        for j = 1:floor(size(I_rec) / patch_size)
            x = 1 + (i - 1) * patch_size;
            y = 1 + (j - 1) * patch_size;   

            % Get kernel
            K_patch = K_rotate(:, :, i, j);
            region = zeros(size(I_rec));
            region(x:x+patch_size-1, y:y+patch_size-1) = 1.0;

            % Apply filter
            I_patch = imfilter(I_rec, K_patch, 'replicate');
            I_rec = (double(region==0) .* I_rec) + (double(region~=0) .* I_patch);
            I_rec = (double(mask==0) .* I_rec) + (double(mask~=0) .* I);
        end
    end
end

%figure;
%imshow(I_rec);

