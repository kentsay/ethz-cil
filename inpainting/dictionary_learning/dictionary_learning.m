function [U,Z] = dictionary_learning(X)
% Implements dictionary learning algorithm, using matching pursuit as the
% sparse coding stage.
%
% INPUTS
% X: (d x n) data matrix (samples as columns)
%
% OUTPUTS
% U: (d x l) dictionary
% Z: sparse coding of X in dictionary U
%
% PARAMETERS
% l: codebook size of dictionary
% init_mode: initialization of dictionary, either 'rand' or 'samples'
% iter_num: number of update iterations
% sigma: desired maximal residual norm

%% Parameters
[d,n] = size(X);
l = 256;
sigma = 0.01;
rc_min = 0.01;
iter_num = 50;
init_mode = 'samples';


%% Initialization of Dictionary


if strcmp(init_mode, 'rand')
    v = randn(l,d);
    v = bsxfun(@rdivide,v,sqrt(sum(v.^2,2)));
    U = v';
    % Initialize D with random unit length atoms
    
elseif strcmp(init_mode, 'samples')
    r = randi([1 n],1,l);
    v = X(:,r);
    v = bsxfun(@rdivide,v',sqrt(sum(v'.^2,2)));
    U = v';
    norm(U(:,1))
    % Draw uniform samples from data matrix
else
    error('Invalid value for parameter init_mode.')
end



Z = zeros(l,n);
A = zeros(l,l);
B = zeros(d,l);

for i=1:iter_num
    disp(['iteration: ' num2str(i)]);
    x_t = X(:,randi([1 n]));
    z_t = mp(U, x_t, sigma, rc_min);
    A = A + 0.5*(z_t*z_t');
    B = B + x_t*z_t';
    
    U = dictionary_update(U,A,B,sigma);

end


