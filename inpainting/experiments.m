%% Script to run all the experiments
%  The user defines all the subfolders on which they want to run the
%  experiments. This script is based on the EvaluateInpainting.m provided
%  in the course.

dirs = {'diffusion_directional'};
rand_mask_dir = {'rand_masks'};
text_mask_dir = {'text_mask'};

for curr_dir_number = 1:length(dirs)
    disp(curr_dir_number);
    curr_dir = dirs{curr_dir_number};
    file_list = dir('data'); 
    
    % Get all the indices of the mask pictures in the respecitve folder
    mask_file_list = dir('mask/text_mask');
    n_it = [];
    for i=1:length(mask_file_list)
        mask_name = mask_file_list(i).name;
        if (length(mask_name) < 5)
                continue;
        elseif strcmp(mask_name(end-3:end),'.png')
              n_it(end+1) = i;
        end
    end
    
    Errors = []; % mean squared errors for each image would be stored here
    Times = []; % average execution time is stored here
    
    Result_Mean = zeros(size(n_it));
    Result_Std = zeros(size(n_it));
    Time_Mean = zeros(size(n_it));
    Time_Std = zeros(size(n_it));
    
    [n, m] = size(n_it);
    for j=1:m
        k = 1;
        disp(['iteration: ' num2str(j)]);
        mask_name = mask_file_list(n_it(j)).name;
        mask = imread(mask_name);
        
        for i = 3:length(file_list) % running through the folder
            disp(['Pic: ' num2str(i)]);
            tic;
            file_name = file_list(i).name; % get current filename

            % Only keep the images in the loop
            if (length(file_name) < 5)
                continue;
            elseif ( max(file_name(end-4:end) ~= '2.png'))
                continue;
            end

            % Read image, convert to double precision and map to [0,1] interval
            I = imread(file_name); 
            I = double(I) / 255; 
            I_mask = I;
            I_mask(~mask) = 0;
            
            % Call the main inPainting function
            cd(curr_dir);
            I_rec = inPainting(I_mask, mask);
            cd('../')
            
            % Measure approximation error
            Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));
            Times(k) = toc;
            k = k+1;
        end
        Result_Mean(j) = mean(Errors);
        Result_Std(j) = std(Errors);
        Time_Mean(j) = mean(Times);
        Time_Std(j) = std(Times);
    end
    name = strcat(curr_dir,'.mat');
    save(name,'Result_Mean','Result_Std','Time_Mean','Time_Std');
end


