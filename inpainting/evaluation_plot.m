% Evaluation plot

% data input
base = load('baseline.mat');
dct = load('dictionary_learning.mat');
diffusion = load('diffusion.mat');
gradients = load('gradients.mat');
svd = load('SVD.mat');

%box plot for time execution std
fig_timestd = figure;
boxplot([dct.Time_Mean',base.Time_Mean',gradients.Time_Mean',svd.Time_Mean',diffusion.Time_Mean'],{'Learned Dictionary','DCT', 'Gradients','SVD','Diffusion'});

title('Runtime standard deviation');
ylabel('Runtime');

% plot for mse
fig_mse = figure;
x = linspace(0.1,0.9,9);
plot(x, base.Result_Mean, '--gp', x, svd.Result_Mean, '--r^', x, dct.Result_Mean, '--c+', x, diffusion.Result_Mean, '--bs', x,gradients.Result_Mean, '--m*');

legend('DCT','SVD','Learned Dictionary','Diffusion','Gradients');
title('Mean squared error rate');
xlabel('Mask percentage');
ylabel('Mean squared error');



