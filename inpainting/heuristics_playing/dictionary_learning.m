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
d = size(X,1);
n = size(X,2);
l = 256;
sigma = 0.1;
rc_min  = 0.02;
iter_num = 15;
init_mode = 'rand';


%% Initialization of Dictionary


if strcmp(init_mode, 'rand')
    v = randn(l,d);
    v = bsxfun(@rdivide,v,sqrt(sum(v.^2,2)));
    % Initialize D with random unit length atoms
    U = v';
elseif strcmp(init_mode, 'samples')
    r = randi([1 n],1,l);
    U = X(:,r);
    U(U==0) = eps;
    nU = sqrt(sum(abs(U).^2,1));
    for i=1:l
        U(:,i) = U(:,i)/nU(i);
    end
    % Draw uniform samples from data matrix
else
    error('Invalid value for parameter init_mode.')
end



Z = zeros(l,n);
U_new = zeros(size(U));

for i=1:iter_num
    disp(['iteration: ' num2str(i)]);
    
    Z = mp(U, X, sigma, rc_min);   
    
    U = updateDict(X,U,Z);
    
end

end

function U = updateDict(X,U,Z)
    L = size(U,2);
    for l=1:L
        U(:,l) = 0;
        z = Z(l,:);
        N = z ~=0;
        R = X(:,N) - U*Z(:,N);
        g = z(N)';
        h = R*g/norm(R*g);
        g = R'*h;
        U(:,l) = h;
        Z(l,N) = g';
    end
end

function Z = mp(U, X, sigma, rc_min)
       l = size(U,2);
       n = size(X,2);
       Z = zeros(l,n);
       for nn=1:n
           x = X(:,nn);
           z = zeros(l,1);
           r=x;
           rc_max = max(abs(r'*U));
           while (norm(r) > sigma*norm(x)) && (rc_max > rc_min)
               [rc_max,d] = max(abs(r'*U));
               u_d = U(:,d);
               z(d) = z(d) + u_d'*r;
               r = r - (u_d'*r)*u_d;
           end
           Z(:,nn) = z;
       end
       
end
