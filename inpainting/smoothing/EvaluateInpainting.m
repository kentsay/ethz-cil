% Measure approximation error and compression ratio for several images.
%
% NOTE Images must be have .png ending and reside in the same folder.

file_list = dir(); 
k = 1;

Errors = []; % mean squared errors for each image would be stored here

figure('units','normalized','outerposition',[0 0 1 1]);
count = 0;
for i = 3:length(dir) % running through the folder
    
    file_name = file_list(i).name; % get current filename
    
    % Only keep the images in the loop
    if (length(file_name) < 5)
        continue;
    elseif ( max(file_name(end-4:end) ~= '2.png'))
        continue;
    end
    mask_name = [file_name(1:end-4) '_mask.png'];
        
    % Read image, convert to double precision and map to [0,1] interval
    I = imread(file_name); 
    I = double(I) / 255; 
    
    % Read the respective binary mask
    % EVALUATION IS DONE WITH A FIXED MASK
    mask = imread(mask_name);
    
    I_mask = I;
    I_mask(~mask) = 0;
          
    % Call the main inPainting function
    I_rec = inPainting(I_mask, mask);
    RGB = double(cat(3, I_rec, I_rec, I_rec));
    
    count = count+1;
    subaxis(2,3,count, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0.09);
    imagesc((I - I_rec).^2);
    axis tight
    axis off
    subaxis(2,3,count+3, 'Spacing', 0, 'Padding', 0, 'Margin', 0.02);
    imshow(RGB,'Border','tight');
    
    % Measure approximation error
    Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));
    
    k = k+1;
end

Result(1) = mean(Errors);
suptitle(['Average quadratic error: ' num2str(Result(1))])

disp(['Average quadratic error: ' num2str(Result(1))])
