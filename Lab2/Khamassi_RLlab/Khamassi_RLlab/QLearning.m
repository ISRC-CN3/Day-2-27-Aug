function [Q,pol] = QLearning(M, tau)
% This function computes the optimal state-value function and the corresponding
% policy using Q-Learning with a soft-max policy of temperature tau.

init;

% Initialize the state-action value function
Q = ???;

% Run learning cycle
nbIter = ???; % Number of iterations
alpha  = ???; % Learning rate
for iter = 1:nbIter
    % Draw a state
    x = ???;
    % Draw an action using a soft-max policy
    u = ???;
    % Perform a step of the MDP
    [y,r] = MDPStep(M, x, u);
    % Update the state-action value function with Q-Learning
    Q(x,u) = ???;
end

% Compute the corresponding policy
pol = ???;

