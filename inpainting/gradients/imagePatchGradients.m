function [ gradients, weights ] = imagePatchGradients( I, patch_size )
    
    horizontal = abs(I - circshift(I, [0, 1]));
    vertical   = abs(I - circshift(I, [1, 0]));
    diagonal   = abs(I - circshift(I, [1, 1]));
    
    gradients = zeros(size(I) / patch_size);
    weights = zeros(size(I) / patch_size);
    
    % Iterate over all patches of given patch_size
    for i = 1:size(I) / patch_size
        for j = 1:size(I) / patch_size
            x = 1 + (i - 1) * patch_size;
            y = 1 + (j - 1) * patch_size;
            
            % Compute directionality
            h = sum(sum(horizontal(x:x+patch_size-1, y:y+patch_size-1)));
            v = sum(sum(vertical(x:x+patch_size-1, y:y+patch_size-1)));
            d = sum(sum(diagonal(x:x+patch_size-1, y:y+patch_size-1)));
            d = d / (1 + v + h);
            direction = 90 * (h + 1) / (h + v + 1);
            if d > 0.6
                direction = direction + (d * 90);
            else
                direction = 90 - direction;
            end
            
            % Store in gradients
            gradients(i, j) = direction;
            weights(i, j) = v + h;
            
        end
    end
    
    weights = weights / max(max(weights));

end

