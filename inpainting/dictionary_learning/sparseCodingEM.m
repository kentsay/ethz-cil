function Z = sparseCodingEM( U, X, M, sigma, rc_min )
l = size(U,2);
n = size(X,2);

Z = zeros(l,n);
X_hat = zeros(size(X));
for i= 1:n
    x = X(:,i);
    i
    z = zeros(size(Z(:,i)));
    z_t = zeros(size(z));
    dm = diag(M(:,i)~=0);
    while norm(z-z_t,'fro') < sigma
        z_t = z;
        %e-step
        x = dm * x;
        x = x + (eye(size(dm)) - dm) * U*z_t;
        x(x<0)=0;

        %mstep
        z_t = sparseCoding(U, x, M, sigma, rc_min);
    end
    Z(:,i) = z_t;
end
end

