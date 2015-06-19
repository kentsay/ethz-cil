% Plot results for analysis

%% Load data input
% Baseline(DCT)
dct_rmd = load('baseline_randmask.mat');
dct_txt = load('baseline_textmask.mat');
% Baseline(Haar)
haar_rmd = load('baseline_haar_randmask.mat');
haar_txt = load('baseline_haar_textmask.mat');
% Regular diffusion with diamond kernel
df_dia_rmd = load('diffusion_randmask.mat');
df_dia_txt = load('diffusion_textmask.mat');
% Directional diffusion 32x32
gd_rmd = load('diffusion_directional_fast32_randmask.mat');
gd_txt = load('diffusion_directional_fast32_textmask.mat');
% Directional diffusion 16x16
gd_rmd_16 = load('diffusion_directional_fast16_randmask.mat');
gd_txt_16 = load('diffusion_directional_fast16_textmask.mat');
% SVD
svd_rmd = load('SVD_randmask.mat');
svd_txt = load('SVD_textmask.mat');

%% Mean square error analysis

% Plot mse with random mask
x = linspace(0.1,0.9,9);
fig_mse_rmd = figure;

semilogy(x, dct_rmd.Result_Mean,'--gp', ...
     x, svd_rmd.Result_Mean,    '--r^', ...
     x, haar_rmd.Result_Mean,   '--c+', ...
     x, df_dia_rmd.Result_Mean, '--bs', ...     
     x, gd_rmd_16.Result_Mean,     '--m*');
legend('DCT', ...
       'SVD', ...
       'Haar wavelet', ...
       'Diffusion diamond', ...
       'Directional diffusion 16x16');
title('Mean squared error rate');
xlabel('Percentage of missing pixels');
ylabel('Mean squared error (MSE)');


%% Runtime analysis
% plot for runtime
x = linspace(0.1,0.9,9);
fig_time_rmd = figure;

semilogy(x, dct_rmd.Time_Mean,    '--gp', ...
     x, svd_rmd.Time_Mean,    '--r^', ...
     x, haar_rmd.Time_Mean,   '--c+', ...
     x, df_dia_rmd.Time_Mean, '--bs', ...
     x, gd_rmd_16.Time_Mean,     '--m*');
legend('DCT', ...
       'SVD', ...
       'Haar wavelet' , ...
       'Diffusion diamond', ...
       'Directional diffusion 16x16');
title('Runtime');
xlabel('Percentage of missing pixels');
ylabel('Runtime (sec)');