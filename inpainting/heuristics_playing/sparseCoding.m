function Z = sparseCoding(U, X, M, sigma, rc_min)
% 
% Perform sparse coding using a modified matching pursuit tailored to the 
% inpainting problem with residual stopping criterion.
%
% INPUT
% U: (d x l) unit norm atoms
% X: (d x n) observations
% M: (d x n) mask denoting which observations are unknown
% sigma: residual error stopping criterion, normalized by signal norm
% rc_min: minimal residual correlation before stopping
%
% OUTPUT
% Z: MP coding
%

l = size(U,2);
n = size(X,2);

Z = zeros(l,n);
% Loop over all observations in the columns of X
for nn = 1:n
    x = X(:,nn);
    m = M(:,nn);
    m = m~=0;
    MM = diag(m);
    z = zeros(l,1);
    r = MM*x;
    % Initialize the residual with the observation x
    % For the modification with masking make sure that you only take into
    % account the known observations defined by the mask M
    % Initialize z to zero
   
    % TO BE FILLED
    rc_max = max(abs(r'*U));
    n_it = 0;
    while (norm(r) > sigma*norm(x)) && (rc_max > rc_min)
        
        % TO BE FILLED 
        
        % Select atom with maximum absolute correlation to the residual
        % Update the maximum absolute correlation
        [rc_max,d] = max(abs(r'*U));
        %rc_max = max([rc_max;val])
        % Update coefficient vector z and residual z
        u_d = U(:,d);
        z(d) = z(d) + u_d'*r;
        r = r - (u_d'*r)*u_d;
        % For the inpainting modification make sure that you only consider
        % the known observations defined by the mask M
        r = MM*r;
        n_it = n_it + 1;
    end
    its(nn) = n_it;
    
    % Add the calculated coefficient vector z to the overall matrix Z
    Z(:,nn) = z;
end
median(its)
max(its)