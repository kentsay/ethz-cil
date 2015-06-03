function [ I_rec ] = prioritysmoothing( I, mask, window_size, alpha )
%priority_smoothing A smoothing algorithm based on a priority inpainting
%   Inpainting happens on a smooth basis (mean of pixels around it),
%   starting with pixels that we are sure about (i.e. those that have a lot
%   of known pixels around it (edges) and whose surrounding pixels are
%   mostly the same color (max(pixels) - min(pixels) is small)

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

I_rec = I;
for it = 1:count
    test = priority(it,:);
    i = test(1);
    j = test(2);
    p = test(3);
    image_window = get_window_pixels(I, i, j, window_size);
    new_value = mean(image_window(get_window_pixels(mask, i, j, window_size)~=0));
    if isnan(new_value)
        new_value = mean(mean(image_window));
    end
    if size(new_value, 1)==0
        new_value = mean(mean(image_window));
    end
    I_rec(i,j) = new_value;
end

function [I_window] = get_window_pixels(I, x, y, window)
% Helper function to easily get a window within the pixel region of an
% image
    I_window = I(max(1, x - window):min(size(I,1), x + window), max(1, y - window):min(size(I,1), y + window));
end

end

