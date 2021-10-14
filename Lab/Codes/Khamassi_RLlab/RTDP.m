function [Q,pol] = RTDP(M)
% This function computes the optimal Q-function and the corresponding policy
% for the MDP M using Real-Time DP

init;

% Initialize the Q-function
Q = ???;

% Initialize the transition model and the number of visits for each state-action pair
hatP = ???;
N    = ???;

% Draw an initial state
x = ???

% Run learning cycle
nbIter = ???;
for iter = 1:nbIter
    
    % Draw a random action and get the next state and reward
    u = ???;
    [y, r] = ???;
    
    % Update transition matrix (stochastic)
    hatP(x,u,:) = ???;
    
    % Update Q
    Q(x, u) = ???;
    
    % Update the number of visits for the current state-action pair
    N(x, u) = ???;
    
    % The next state becomes the current state
    x = y;
end
% Compute a policy based on the estimate of the optimal Q-functionpol = ???;
