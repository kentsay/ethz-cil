function [theta] = computeDirectionality(P)
    %% Computes the directionality of image patch P
    %  Uses the heuristic described in the paper
    
    % Perform circular shift and remove replication border
    Ph = circshift(P.data, [0, 1]);
    Pv = circshift(P.data, [1, 0]);
    Pd = circshift(P.data, [1, 1]);
    Ph = Ph(P.border(1)+1:P.border(1)+P.blockSize(1), P.border(2)+1:P.border(2)+P.blockSize(2));
    Pv = Pv(P.border(1)+1:P.border(1)+P.blockSize(1), P.border(2)+1:P.border(2)+P.blockSize(2));
    Pd = Pd(P.border(1)+1:P.border(1)+P.blockSize(1), P.border(2)+1:P.border(2)+P.blockSize(2));
    Poriginal = P.data(P.border(1)+1:P.border(1)+P.blockSize(1), P.border(2)+1:P.border(2)+P.blockSize(2));
    
    % Use formulas from the heuristics to compute theta
    h = sum(sum(abs(Poriginal - Ph)));
    v = sum(sum(abs(Poriginal - Pv)));
    d = sum(sum(abs(Poriginal - Pd)));
    d = d / (1 + v + h);
    theta = 90 * (h + 1) / (h + v + 1);
    if d > 0.6
        theta = 90*d + theta;
    else
        theta = 90 - theta;
    end
    theta = theta - 90;
end