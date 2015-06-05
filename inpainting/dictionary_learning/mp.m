function z = mp(U, x, sigma, rc_min)
       l = size(U,2);
       z = zeros(l,1);
       r=x;
       rc_max = max(abs(r'*U));
       while (norm(r) > sigma*norm(x)) && (rc_max > rc_min)
           [rc_max,d] = max(abs(r'*U));
           u_d = U(:,d);
           z(d) = z(d) + u_d'*r;
           r = r - (u_d'*r)*u_d;
       end
end