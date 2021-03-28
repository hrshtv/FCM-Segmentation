%{
Description: Computes the bias-removed image
Inputs:
    u : The class memberships
    c : The class means
Outputs:
    A : The bias-removed image
%}

function A = computeA(u, c)
    [R, C, K] = size(u);
    A = zeros(R, C);
    for k = 1:K
        A = A + u(:, :, k) .* c(k);
    end 
end

