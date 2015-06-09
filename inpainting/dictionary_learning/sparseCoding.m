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
    mu = MM*U;
    nmu = sqrt(sum(abs(mu).^2,1));
    while (norm(r) > sigma*norm(x)) && (rc_max > rc_min)
        
        % TO BE FILLED 
        
        % Select atom with maximum absolute correlation to the residual
        % Update the maximum absolute correlation
        
       
        [rc_max,d] = max(abs(r'*mu)./nmu);
        %rc_max = max([rc_max;val])
        % Update coefficient vector z and residual z
        fact = (mu(:,d)'*r)/nmu(:,d);
        z(d) = z(d) + fact;
        r = r - fact*mu(:,d);
        % For the inpainting modification make sure that you only consider
        % the known observations defined by the mask M
    end
    
    % Add the calculated coefficient vector z to the overall matrix Z
    Z(:,nn) = z;
end
