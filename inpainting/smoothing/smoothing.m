function [ I_rec ] = smoothing( I, mask, w_outer, w_inner )
% Smooths the masked images which takes into account surrounding pixel
% information of recovered pixels

% Compute matrix K with outer window size w_outer
K = zeros(size(I));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        mask_here = get_window_pixels(mask, i, j, w_outer);
        known_pixels = get_window_pixels(I, i, j, w_outer);
        K(i,j) = mean(known_pixels(mask_here~=0));
    end
end

% Compute weight values w_ij based on pixel values in I and matrix K
w = ones(size(I));
I_rec = I;
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if mask(i,j) == 0 && ~isnan(K(i,j))
            %Kwindow = get_window_pixels(K, i, j, w_inner);
            %pwindow = get_window_pixels(I, i, j, w_inner);
            %Kwindow = Kwindow(:);
            %pwindow = pwindow(:);
            %ip1 = Kwindow' * pwindow;
            %ip2 = pwindow' * pwindow;
            %w(i,j) = (ip1) / ip2;
            %I_rec(i,j) = w(i,j) * I(i,j);
            I_rec(i,j) = K(i,j);
        end
    end
end

end


function [I_window] = get_window_pixels(I, x, y, window)
% Helper function to easily get a window within the pixel region of an
% image
    I_window = I(max(1, x - window):min(size(I,1), x + window), max(1, y - window):min(size(I,1), y + window));
end
