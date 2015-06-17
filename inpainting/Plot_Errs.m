%% Script to create plots including different algorithms. The user defines all the subfolders needed for the plot. This script is based on the EvaluateInpainting.m provided in the course.


dirs = {'baseline'};


for curr_dir_number = 1:length(dirs)
    curr_dir = dirs{curr_dir_number};
    file_list = dir('data'); 

    Errors = []; % mean squared errors for each image would be stored here
    Times = [];
    n_it = 9;
    miss_interval = linspace(0.1,0.9,n_it);
    Result_Mean = zeros(1,n_it);
    Result_Std = zeros(1,n_it);
    Time_Mean = zeros(1,n_it);
    Time_Std = zeros(1,n_it);
    for j=1:n_it
        k = 1;
        mask = random_mask(512,miss_interval(j));
        for i = 3:length(file_list) % running through the folder
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


            
            I_mask = I;
            I_mask(~mask) = 0;
            %figure;
            %imshow(I_mask); 
            % Call the main inPainting function
            cd(curr_dir);
            I_rec = inPainting(I_mask, mask);
            cd('../')
            %figure;
            %imshow(I_rec);
            % Measure approximation error
            Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));
            Times(k) = toc;
            k = k+1;
        end
        err = mean(Errors);
        std_err = std(Errors);
        Result_Mean(j) = err;
        Result_Std(j) = std_err;
        Time_Mean(j) = mean(Times);
        Time_Std(j) = std(Times);
    end
    name = strcat(curr_dir,'.mat');
    save(name,'Result_Mean','Result_Std','Time_Mean','Time_Std','miss_interval');
end


