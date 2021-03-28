%{
Description: Computes the distances as specified in the slides
Inputs:
    img : The corrupted image
    mask: The background mask
    b   : The bias field
    c   : The class means
    w   : The neighbourhood mask
Outputs:
    d   : The distances 
%}

function d = distance(img, mask, b, c, w)
    
    [R, C] = size(img);
    K = size(c, 1);
    
    d = zeros(R, C, K);
    temp_1 = conv2(b, w, "same");
    temp_2 = conv2(b.^2, w, "same");
    for k = 1:K
        term_1 = (img.^2) .* sum(w(:));
        term_2 = (-2) .* img .* c(k) .* temp_1;
        term_3 = (c(k)^2) .* temp_2;
        d(:, :, k) = term_1 + term_2 + term_3;
    end
    d = d .* mask;
    
end


%%% Much Slower, Equivalent Code (used for verifying the above function and understanding it) %%%
% [R, C] = size(img);
% f = size(w, 1); % The gaussina filter's dimension
% 
% d = zeros(R, C, K); % Stores d_ijk for each valid pixel and class
% % Iterate over all valid pixels
% for k = 1:K
%     for i = 1:R
%         for j = 1:C
%             if mask(i, j) == 1
% 
%                 yij = img(i, j);
% 
%                 % fxf window centered at (i, j)
%                 bij = extractNeighbours(b, i, j, f);
% 
%                 temp = w .* (((c(k) .* bij) - yij) .^ 2);
% 
%                 d(i, j, k) = sum(temp(:));
% 
%             end
%         end
%     end
% end