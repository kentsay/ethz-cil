function [ I_rec ] = prioritysmoothing( I, mask, priority_mask, window_size, alpha )
    %% PRIORITYSMOOTHING
    % A smoothing algorithm based on a priority inpainting
    % Inpainting happens on a smooth basis (mean of pixels around it),
    % starting with pixels that we are sure about (i.e. those that have a lot
    % of known pixels around it (edges) and whose surrounding pixels are
    % mostly the same color (max(pixels) - min(pixels) is small)
    I_rec = I;

    %% Order pixels we want to inpaint by priority
    %  The priority is determined by the amount of known pixels around it and
    %  the difference of the highest and smallest pixel value around it.
    %  This makes it possible to start with pixels that have a a lot of known
    %  pixels around them.
    beta = 1 - alpha;
    priority = zeros(size(I,1)^2, 3);
    count = 0;
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if mask(i,j)==0
                image_window = get_window_pixels(I, i, j, window_size);
                mask_window = get_window_pixels(mask, i, j, window_size);
                known_surrounding_pixels = sum(sum(mask_window~=0)) / (window_size*2+1)^2;
                certainty_surrounding_pixels = max(image_window(mask_window~=0)) - min(image_window(mask_window~=0));
                if isnan(certainty_surrounding_pixels)
                    certainty_surrounding_pixels = 0;
                end
                if size(certainty_surrounding_pixels, 1)==0
                    certainty_surrounding_pixels = 0;
                end
                p = (known_surrounding_pixels * alpha + certainty_surrounding_pixels * beta) / 2;
                count = count + 1;
                priority(count, :) = [i j p];
            end
        end
    end
    [~, order] = sort(priority(:,3), 'descend');
    priority = priority(order,:);

    %% Fill in pixels and construct I_rec
    %  Fills in the pixel using the mean of the pixels around it
    K = fspecial('gaussian', window_size * 2 + 1);
    inpainted = mask~=0;
    for it = 1:count
        test = priority(it,:);
        i = test(1);
        j = test(2);

        % Compute windows around the pixel we want to inpaint
        image_window = get_window_pixels(I_rec, i, j, window_size);
        priority_window = get_window_pixels(priority_mask, i, j, window_size);
        inpaint_window = get_window_pixels(inpainted, i, j, window_size);
        gaussian_window = get_constrained_kernel_window(K, i, j, size(I_rec,1), size(I_rec,2), window_size);
        
        % Compute weighted mean using the windows
        new_value = get_weighted_mean(image_window, priority_window .* inpaint_window .* gaussian_window);

        % Fall back, in case the weighted mean was ill defined
        if isnan(new_value) || size(new_value, 1)==0
            new_value = mean(mean(image_window .* priority_window));
        end

        I_rec(i,j) = new_value;
        inpainted(i,j) = 1;
    end

    %% Helper function to compute weighted mean
    function [val] = get_weighted_mean(original, weight_mask)
        val = sum(original(:) .* weight_mask(:)) / sum(weight_mask(:));
    end

    %% Helper function for getting a constrained kernel window
    function [window] = get_constrained_kernel_window(kernel, x, y, max_x, max_y, window_size)
        x_min = max(1, window_size + 2 - x);
        y_min = max(1, window_size + 2 - y);
        x_max = min(window_size * 2 + 1, max_x - x + window_size + 1);
        y_max = min(window_size * 2 + 1, max_y - y + window_size + 1);
        window = kernel( x_min:x_max, y_min:y_max );
    end

    %% Helper function to get a window of pixels
    function [I_window] = get_window_pixels(I, x, y, window)
        I_window = I(max(1, x - window):min(size(I,1), x + window), max(1, y - window):min(size(I,1), y + window));
    end

end

