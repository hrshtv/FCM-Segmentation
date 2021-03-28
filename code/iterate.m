%{
Description: Runs the specified algorithm / Driver class for the algorithm
Inputs:
    img : The corrupted image
    mask: The background mask
    u   : The class memberships
    b   : The bias field
    c   : The class means
    q   : The q-parameter as specified in the slides
    w   : The neighbourhood mask
    J_init : The initial value of the loss function
    eps : Specifes when the algorithm stops the iterations
    N_max : Maximum number of iterations to run for in any case 
Outputs:
    u   : The updated class memberships
    b   : The updated bias field
    c   : The updated class means
    J   : Array that stores the loss function values for each iteration
%}

function [u, b, c, J] = iterate(img, mask, u, b, c, q, w, J_init, eps, N_max)
    
    i_fcm = 0;
    J_after = J_init;
    J = zeros(N_max, 1);
    % J(1) = J_init; % The initial J is very large (due to poor segementation by K-Means) thus it skews the graph for J vs iters a lot. Thus we don't plot this value in the graph 
    while true
        
        d = distance(img, mask, b, c, w);
        u = updateU(d, q, mask);
        b = updateB(img, mask, c, u, q, w);
        c = updateC(img, mask, b, u, q, w);
        J_before = J_after;
        J_after = objectiveFunction(img, b, c, q, u, w);
        J(i_fcm + 1) = J_after;
        
        fprintf("Before: %f | After: %f\n", round(J_before, log10(1/eps)), round(J_after, log10(1/eps)));
        if  (abs(J_before - J_after)/J_before) <= eps 
            fprintf("Stopping\n");
            break;
        end
        
        i_fcm = i_fcm + 1;
        fprintf("Iteration %d completed\n\n", i_fcm);
        if i_fcm >= N_max
            break
        end
        
    end
    
end

