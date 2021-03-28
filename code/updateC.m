%{
Description: Computes the optimal value of the class means, within every iteration.
Inputs:
    img : The corrupted image
    mask: The background mask
    u   : The class memberships
    b   : The bias field
    q   : The q-parameter as specified in the slides
    w   : The neighbourhood mask
Outputs:
    c   : The updated class means
%}

function c = updateC(img, mask, b, u, q, w)
    
    sum_num = conv2(b, w, "same"); % \sum_{i=1}^N w_{ij}*b_i
    sum_den = conv2(b.^2, w, "same"); % \sum_{i=1}^N w_{ij}*b_i^2
    
    temp = u .^ q; % [256, 256, 3]
    num  = temp .* (img .* sum_num .* mask); % [256, 256, 3]
    num  = squeeze(sum(sum(num, 1), 2)); % Sum over first 2 dimensions, output is of shape [1, 1, 3], squeeze it
    
    den  = temp .* (sum_den .* mask); % [256, 256, 3]
    den  = squeeze(sum(sum(den, 1), 2)); % Sum over first 2 dimensions, output is of shape [1, 1, 3], squeeze it
    
    c = num ./ den;
    
end


%%% Slower, equivaluent code %%%
% K = size(u, 3);
% c = zeros(K, 1);
% for k = 1:K
%     % Compute common value only once
%     temp = u(:, :, k) .^ q;
%     % Compute numerator
%     num  = temp .* img .* sum_num .* mask; 
%     num  = sum(num(:)); % sum_{j=1}^N u_{jk}^q * y_j * \sum_{i=1}^N w_{ij}*b_i
%     % Compute Denominator
%     den  = temp .* sum_den .* mask;
%     den  = sum(den(:)); % sum_{j=1}^N u_{jk}^q * \sum_{i=1}^N w_{ij}*b_i^2
%     % Compute updated class means
%     c(k) = num / den;
% end


%%% Very slow, Equivalent Code (used for verifying the above function and understanding it) %%%
% [R, C, K] = size(u);
% f = size(w, 1);
% 
% % Iterate over all valid pixels
% c = zeros(K, 1);
% 
% for k = 1:K
%     c_num = 0;
%     c_den = 0;
%     for i = 1:R
%         for j = 1:C
%             if mask(i, j) == 1
% 
%                 % fxf windows centered at (i, j)
%                 yij = extractNeighbours(img, i, j, f);
%                 uijk = extractNeighbours(u(:, :, k), i, j, f);
% 
%                 temp = (((uijk .^ q) .* yij) .* w) .* b(i, j);
%                 c_num = c_num + sum(temp(:));
% 
%                 temp = ((uijk .^ q) .* w) .* (b(i, j)^2);
%                 c_den = c_den + sum(temp(:));
% 
%             end
%         end
%     end
%     c(k) = c_num / c_den;
% end