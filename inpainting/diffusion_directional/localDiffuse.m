function [res] = localDiffuse(P, kernels, patch_size)
    %% LOCAL DIFFUSE
    %  Diffuses pixels using a filter locally with given local kernel
    K = zeros(3, 3);
    K(:,:) = kernels(1+(P.location(2)-1)/patch_size, 1+(P.location(1)-1)/patch_size, :, :);
    
    res = imfilter(P.data, K);
end