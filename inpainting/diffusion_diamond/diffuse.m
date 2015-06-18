function [I_old, I] = diffuse(I, mask, I_original, K)
    %% DIFFUSE
    %  Diffuses pixels using a filter
    I_old = I;
    I = imfilter(I, K, 'replicate');
    I = (double(mask==0) .* I) + (double(mask~=0) .* I_original);
end