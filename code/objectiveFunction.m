%{
Description: Evaluates the loss function for the current estimates
Inputs:
    img : The corrupted image
    b   : The bias field
    c   : The class means
    q   : The q-parameter as specified in the slides
    u   : The class memberships
    w   : The neighbourhood mask
Outputs:
    J   : The loss function for the given estimates
%}

function J = objectiveFunction(img, b, c, q, u, w)
    
    K = size(c, 1);
    
    temp = u.^q;
    sum_term_1 = sum(temp, 3);
    temp = (img.^2) .* sum_term_1;
    term_1  = conv2(temp, w, "same");
    
    sum_term_2 = zeros(size(img)); % \sum_{k=1}^K u_{jk}^q * c_k^2
    sum_term_3 = zeros(size(img)); % \sum_{k=1}^K u_{jk}^q * c_k
    
    for k = 1:K
        temp = (u(:,:,k).^q) .* c(k);
        sum_term_3 = sum_term_3 + temp;
        sum_term_2 = sum_term_2 + (temp .* c(k));
    end
    
    % Convolve with w
    term_2  = (b.^2) .* conv2(sum_term_2, w, "same"); 
    temp = img .* sum_term_3; % y_j * \sum_{k=1}^K u_{jk}^q * c_k
    term_3  = (2*b) .* conv2(temp, w, "same");
    
    temp = term_1 + term_2 - term_3;
    J = sum(temp(:));
    
end