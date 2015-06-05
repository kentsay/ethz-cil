function [ I_rec ] = prioritysmoothing( I, mask, window_size, alpha )
%% PRIORITYSMOOTHING
% A smoothing algorithm based on a priority inpainting
% Inpainting happens on a smooth basis (mean of pixels around it),
% starting with pixels that we are sure about (i.e. those that have a lot
% of known pixels around it (edges) and whose surrounding pixels are
% mostly the same color (max(pixels) - min(pixels) is small)

%% Order pixels we want to inpaint by priority
%  The priority is determined by the amount of known pixels around it and
%  the difference of the highest and smallest pixel value around it.
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

%% Sort pixels to fill in by highest priority first
%  This makes it possible to start with pixels that have a a lot of known
%  pixels around them.
[~, order] = sort(priority(:,3), 'descend');
priority = priority(order,:);

%% Fill in pixels and construct I_rec
%  Fills in the pixel using the mean of the pixels around it
inpainted = mask~=0;
I_rec = I;
for it = 1:count
    test = priority(it,:);
    i = test(1);
    j = test(2);
    image_window = get_window_pixels(I_rec, i, j, window_size);
    new_value = mean(image_window(get_window_pixels(inpainted, i, j, window_size)~=0));
    if isnan(new_value) || size(new_value, 1)==0
        new_value = mean(mean(image_window));
    end
    I_rec(i,j) = new_value;
    mask(i,j) = 1;
end

%% Helper function to get a window of pixels
function [I_window] = get_window_pixels(I, x, y, window)
    I_window = I(max(1, x - window):min(size(I,1), x + window), max(1, y - window):min(size(I,1), y + window));
end

end

