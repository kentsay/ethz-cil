function U = dictionary_update( U,A,B,sigma )
[d,l] = size(U);
U_old = zeros(size(U));
while norm(U_old - U,'fro') < sigma
    for j = 1:l
        u_j = 1/A(j,j)*(B(:,j) - U*A(:,j)) + U(:,j);
        U(:,j) = u_j/max(norm(u_j),1);
    end
end
end

