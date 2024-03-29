file_list = dir(); 
k = 1;

Errors = []; % mean squared errors for each image would be stored here

X = [];

for i = 3:length(dir) % running through the folder
    
    file_name = file_list(i).name; % get current filename
    

        
    % Read image, convert to double precision and map to [0,1] interval
    I = imread(file_name); 
    if size(I,3)==3
        I = rgb2gray(I);
    end
    I_c = my_im2col(I,16);
    I_c = double(I_c) / 255; 
    X = [X I_c];
end
U = buildDictionary(X);
save('dictionary.mat','U');