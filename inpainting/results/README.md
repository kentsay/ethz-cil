# Plotting

Matlab scripts for plotting inpainting experiment results. We mainly focus on plotting two numbers: Mean squred error and runtime in second. The script generate six figures listed as follow:

1. Line plot: Mean squared error with random mask under log scale
2. Bar chart: Mean squared error with text mask
3. Box plot: Mean squared error standard deviation with random mask
4. Line plot: Runtime with random mask under log scale
5. Bar chart: Runtime with text mask
6. Box plot: Runtime standard deviation with random mask

The script is divided into three parts: load data from file, plots for mean squred error, plots for runtime. If you want to reproduce our plotting, just simple execute the plots.m script. You can also modify the file name if you want to plot your own data.