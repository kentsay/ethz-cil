function [ I_rec ] = diffusion_inpainting( I, mask, T )
    %% DIFFUSION
    % A diffusion based inpainting algorithm
    I_rec = I;
    
    %% Set parameters and construct kernel
    a = 0.073235;
    b = 0.176765;
    K = [a b a; b 0 b; a b a];

    %% Fill in pixels and construct I_rec
    %  Fills in the pixel using the mean of the pixels around it
    for t = 1:T
        I_rec = imfilter(I_rec, K, 'replicate');
        I_rec = (double(mask==0) .* I_rec) + (double(mask~=0) .* I);
    end

end

