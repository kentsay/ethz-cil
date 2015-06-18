%% This script generates a batch of randomly generated masks

%parameters
n_it = 9;
interval_low = 0.1;
interval_high = 0.9;

miss_interval = linspace(interval_low,interval_high,n_it);

for j=1:n_it
    mask = random_mask(512,miss_interval(j));
    imwrite(mask,['rand_mask', num2str(j) ,'.png'])
end