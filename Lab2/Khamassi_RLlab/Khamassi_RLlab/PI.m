function [Q, pol] = PI(M)
% This function applies Policy Iteration to compute the optimal Q-function
% for the MDP M
% It returns this optimal Q-function and the corresponding (optimal) policy

init;

% Initialize the policy with action N for all states
pol = ???;

% Policy iteration loop
quit = 0;
iter = 0;
while (~quit)
    iter = iter + 1
    
    % Evalute the current policy
    V = ???;

    % Perform PI update
    Q = ???;
    pol = ???;

    % Stopping condition in terms of corresponding policies
    if ???
        quit = 1;
    end
end

