function plotPolicy(M,pol)
% This function visually depicts the policy pol for the MDP M.

init;

% Create plot window
f = figure(1);
clf(f);

% Set window name
set(f, 'MenuBar', 'none');
set(f, 'Name', 'Policy');

% Grid box
Box = plot([0.5 4.5 4.5 0.5 0.5], [0.5 0.5 4.5 4.5 0.5], 'k');
set(Box, 'LineWidth', 3);

% Clear axis
a = get(Box, 'Parent');                 % Get axis handle
set(a, 'Visible', 'off');               % Clear axis
set(a, 'PlotBoxAspectRatio',[1 1 1]);   % Set square axis

hold on;

% Grid
Grid = plot([1.5 1.5 2.5 2.5 3.5 3.5 4.5 4.5 0.5 0.5 4.5 4.5 0.5 0.5 1.5], ...
            [0.5 4.5 4.5 0.5 0.5 4.5 4.5 3.5 3.5 2.5 2.5 1.5 1.5 0.5 0.5], 'k');

ACTMAT = {'North','South','East','West','NoOp'};

ACTVEC = [ 0  1;
           0 -1;
           1  0;
          -1  0;
           0  0 ];

[Y, X] = ind2sub([4 4], 1:16);
U = 0.5 * ACTVEC(pol, 1)';
V = 0.5 * ACTVEC(pol, 2)';

quiver(X, 5 - Y, U, V);
