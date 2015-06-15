% Measure approximation error and compression ratio for several images.
%
% NOTE Images must be have .png ending and reside in the same folder.

file_list = dir(); 
k = 1;

Errors = []; % mean squared errors for each image would be stored here
Times = [];
it = 9;
l = linspace(0.1,0.9,it);
Result_Learned = zeros(1,it);
Time_Learned = zeros(1,it);
for j=1:it
for i = 3:length(dir) % running through the folder
    tic;
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
    %mask = imread(mask_name);
    

    mask = random_mask(512,l(j));
    I_mask = I;
    I_mask(~mask) = 0;
    %figure;
    %imshow(I_mask); 
    % Call the main inPainting function
    I_rec = inPainting(I_mask, mask);
    %figure;
    %imshow(I_rec);
    % Measure approximation error
    Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));
    Times(k) = toc;
    k = k+1;
    
end
err = mean(Errors);
Result_Learned(j) = err;
Time_Learned(j) = mean(Times);
end

plot(l,Result_Learned,'*');


disp(['Average quadratic error: ' num2str(Result_Learned(1))])
