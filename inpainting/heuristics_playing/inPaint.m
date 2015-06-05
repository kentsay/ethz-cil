function I_rec = inPaint( I,mask,neib,sigma,rc_min )

% Get patches of size neib x neib from the image and the mask and
% convert each patch to 1D signal
X = my_im2col(I, neib);  
M = my_im2col(mask, neib);  
[n,m] = size(I);
% Construct your dictionary
% If you load your own dictionary U calculated offline you don't have to 
% add anything here
U = buildDictionary(X);  % TO BE FILLED 
    
% Do the sparse coding with modified Matching Pursuit
Z = sparseCoding(U, X, M, sigma, rc_min);
 

% You need to do the image reconstruction using the known image information
% and for the missing pixels use the reconstruction from the sparse coding.
% The mask will help you to distinguish between these two parts.
[m,nmask] = size(M);
X_hat = zeros(size(M));
figure;
imshow(X);
for it = 1:nmask
    dm = diag(M(:,it)~=0);
    x_hat = dm * X(:,it);
    x_hat = x_hat + (eye(size(dm)) - dm) * U*Z(:,it);
    X_hat(:,it) = x_hat;
end
X_hat(X_hat<0)=0;
I_rec = my_col2im(X_hat,neib,n);
end

