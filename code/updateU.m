%{
Description: Computes the optimal value of the class memberships, within every iteration.
Inputs:
    mask: The background mask
    d   : The distances
    q   : The q-parameter as specified in the slides
Outputs:
    u   : The updated class memberships
%}

function u = updateU(d, q, mask)

    num = (1 ./ d) .^ (q - 1); % [256, 256, 3]
    den = sum(num, 3); % [256, 256, 3]
    u = num ./ den; % [256, 256, 3] Uses broadcasting
    u(isnan(u)) = 0; % Set NaN to 0 that arise due to 0/0 in the background
    u = u .* mask; % [256, 256, 3] Uses broadcasting
    
end

%%% Slower, longer code (used for verification and understanding) %%%
% [R, C, K] = size(d);  
% u = zeros(R, C, K);
% for i = 1:R
%     for j = 1:C
%         if mask(i, j) == 1
% 
%             temp = zeros(K, 1);
%             for k = 1:K
%                 temp(k) = (1 / d(i, j, k))^(q - 1);
%             end
% 
%             temp = temp ./ sum(temp(:));
%             u(i, j, :) = temp;
% 
%         end
%     end
% end