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
% Regular diffusion with gaussion kernel
df_gau_rmd = load('diffusion_guass_randmask.mat');
df_gau_txt = load('diffusion_guass_textmask.mat');
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

% Plot mse with text mask
fig_mse_txt = figure;
y = [dct_txt.Result_Mean, ...
     svd_txt.Result_Mean, ...
     haar_txt.Result_Mean, ...
     df_dia_txt.Result_Mean, ...
     df_gau_txt.Result_Mean, ...
     gd_txt.Result_Mean];
bar(y);
set(gca,'XTickLabel',{ ...
        'DCT', ...
        'SVD', ...
        'Haar wavelet', ...
        'Diffusion diamond', ...
        'Diffusion gaussion', ...
        'Directional diffusion'});

title('Mean squared error rate');
% xlabel('Percentage of mask');
ylabel('Mean squared error (MSE)');

% Boxplot mse std with random mask
fig_mse_rmd_std = figure;
boxplot([svd_rmd.Result_Mean', ...
         dct_rmd.Result_Mean', ...
         haar_rmd.Result_Mean', ...
         gd_rmd.Result_Mean', ... 
         df_dia_rmd.Result_Mean', ...
         df_gau_rmd.Result_Mean'], ...
         {'SVD', 'DCT', 'Haar wavelet', 'Gradients','Diffusion diamond','Diffusion gaussion'});
title('Mean squared error standard deviation');
ylabel('Mean squared error(MSE)');

%% Runtime analysis
% plot for runtime
x = linspace(0.1,0.9,9);
fig_time_rmd = figure;
% plot(x, dct.Result_Mean, '--gp', x, svd.Result_Mean, '--r^', x, dictionary.Result_Mean, '--c+', x, diffusion.Result_Mean, '--bs', x, diffusion_gauss.Result_Mean, '--yo', x,gradients.Result_Mean, '--m*');
% plot(x, dct_rmd.Time_Mean,    '--gp', ...
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

% Plot runtime with text mask
fig_time_txt = figure;
% plot(x, dct.Result_Mean, '--gp', x, svd.Result_Mean, '--r^', x, dictionary.Result_Mean, '--c+', x, diffusion.Result_Mean, '--bs', x, diffusion_gauss.Result_Mean, '--yo', x,gradients.Result_Mean, '--m*');

y = [dct_txt.Time_Mean, ...
     svd_txt.Time_Mean, ...
     haar_txt.Time_Mean, ...
     df_dia_txt.Time_Mean, ...
     df_gau_txt.Time_Mean, ...
     gd_txt.Time_Mean];
bar(y);
set(gca,'XTickLabel',{ ...
        'DCT', ...
        'SVD', ...
        'Haar wavelet', ...
        'Diffusion diamond', ...
        'Diffusion gaussion', ...
        'Directional diffusion'});

title('Runtime');
% xlabel('Percentage of mask');
ylabel('Runtime(sec)');

% Boxplot runtime std with random mask
fig_time_rmd_std = figure;
boxplot([svd_rmd.Time_Mean', ...
         dct_rmd.Time_Mean', ...         
         haar_rmd.Time_Mean', ...
         gd_rmd.Time_Mean', ... 
         df_dia_rmd.Time_Mean', ...
         df_gau_rmd.Time_Mean'], ...
         {'SVD', 'DCT', 'Gradients', 'Haar wavelet','Diffusion diamond','Diffusion gaussion'});
title('Runtime standard deviation');
ylabel('Runtime(sec)');