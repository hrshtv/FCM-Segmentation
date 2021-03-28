%{
Description: Computes the optimal value of the bias field, within every iteration.
Inputs:
    img : The corrupted image
    mask: The background mask
    u   : The class memberships
    c   : The class means
    q   : The q-parameter as specified in the slides
    w   : The neighbourhood mask
Outputs:
    b   : The updated bias field
%}

function b = updateB(img, mask, c, u, q, w)
    
    K = size(c, 1);

    sum_num = zeros(size(img)); % \sum_{k=1}^K u_{jk}^q * c_k
    sum_den = zeros(size(img)); % \sum_{k=1}^K u_{jk}^q * c_k^2

    for k = 1:K
        temp = (u(:,:,k).^q) .* c(k);
        sum_num = sum_num + temp;
        sum_den = sum_den + (temp .* c(k));
    end
    
    % Convolve with w
    temp = img .* sum_num; % y_j * \sum_{k=1}^K u_{jk}^q * c_k
    num  = conv2(temp, w, "same");
    den  = conv2(sum_den, w, "same"); % 
    
    b = num ./ den;
    b(isnan(b)) = 0; % Set NaN to 0 that arise due to 0/0 in the background
    b = b .* mask;
    
end

%%% Much Slower, Equivalent Code (used for verifying the above function and understanding it) %%%
%     % Very slow
%     [R, C, K] = size(u);
%     f = size(w, 1);
%     
%     % Iterate over all valid pixels
%     b = zeros(R, C);
%     for i = 1:R
%         for j = 1:C
%             if mask(i, j) == 1
%                 
%                 % fxf window centered at (i, j)
%                 yij = extractNeighbours(img, i, j, f);
%                 
%                 tij = zeros(f);
%                 tij_sq = zeros(f);
%                 for k = 1:K
%                     % fxf window centered at (i, j)
%                     uijk = extractNeighbours(u(:, :, k), i, j, f);
%                     tij = tij + (uijk .^ q) .* c(k);
%                     tij_sq = tij_sq + (uijk .^ q) .* (c(k)^2);
%                 end
%                 
%                 temp = (w .* yij) .* tij;
%                 b_num = sum(temp(:)); % Sum over all values in the fxf window
%                 temp = w .* tij_sq;
%                 b_den = sum(temp(:));
%                 
%                 b(i, j) = b_num/b_den;
%                 
%             end
%         end
%     end