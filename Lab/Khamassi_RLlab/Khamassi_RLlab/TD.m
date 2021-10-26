function V = TD(M, pol)
% This function computes the value function associated with policy pol for 
% the MDP M using TD(0).

init;

% Initialize the state value function
V = ???;

% Run learning cycle
nbIter = ???; % Number of iterations
alpha  = ???; % Learning rate
for iter = 1:nbIter
    % Draw a state
    x = ???;
    % Perform a step of the MDP
    [y,r] = MDPStep(M, x, pol(x));
    % Update the value function with TD(0)
    V(x) = ???;
end

