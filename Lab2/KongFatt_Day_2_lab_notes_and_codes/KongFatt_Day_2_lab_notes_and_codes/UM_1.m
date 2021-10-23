% Usher-McClelland (LCA) model - linear input-output version
% Note the fast dynamics along the phase space diagonal before deciding
% (clue to 1-D approximation of DDM)
% Note also that I have balanced the leak k and inhibition b so that they
% are the same; and that both have high values - these 2 conditions are
% necessary to approximate to DDM

close all; clear all;

% Model parameters 
S1=4; % Stimulus input amplitude to y1
S2=4; % Stimulus input amplitude to y2
b=7; % Mutual inhibitory coupling strength between the y's
k=7; % Rate of decay of the y's
z=1; % Decision threshold
c=0.07; % Size of the noise

% Collecting the decision/reaction times
DTc=[]; % Correct responses
DTe=[]; % Error responses

% Initializing the y's
y1(1)=0;
y2(1)=0;

%Define time for the "for" loop
Trial_total=1000 ; % Total number of trial; you should try varying this
T_Total=2500; % Total time
dt=0.05; % Time step

% Starting the trial "for" loop
for i= 1:Trial_total
    
% Starting the time "for" loop
    for t=1:T_Total/dt
        
        y1(t+1)=y1(t)+dt*(-k*y1(t)-b*y2(t)+S1)+ c*sqrt(dt)*randn;
        y2(t+1)=y2(t)+dt*(-k*y2(t)-b*y1(t)+S1)+ c*sqrt(dt)*randn;
        
        % Condition for making the correct response  (since S1>S2)
        if y1(t)>=z
            DTc=[DTc t]; % Collecting the correct reaction time
            break % Stop the time "for" loop
        end;
        if y2(t)>=z % Condition for making the error response  (since S2<S1)
            DTe=[DTe t]; % Collecting the error reaction time
            break % Stop the time "for" loop
        end;
    end;

end;

% Plot in phase (y1,y2) space
plot(y1,y2); title('Sample trajectory of network dynamics in phase space'); 
hold on; 
plot([0 1.2],[0 1.2],'k--');
xlabel('y_1'); ylabel('y_2'); 
hold on;

% Check whether total number of correct and error trials adds up to
% Trial_total i.e. consistent
disp('Total number of trials is')
if (size(DTc,2)+size(DTe,2))==Trial_total
    disp('consistent')
else disp('not consistent (some decisions were not made within the time constraint)')
end;

% Calculate the accuracy (Divide the number of correct trials with the
% total number of trials
disp('Accuracy')
size(DTc,2)/(size(DTc,2)+size(DTe,2)) % Total number of trials
% Note: Can also be size(DTc,2)/Trial_total

% Display reaction/decision time distributions (good only for large number
% of trials e.g. Trial_total=10000)
figure; hist(dt.*DTc,30); title('Correct DT distribution');
figure; hist(dt.*DTe,30); title('Error DT distribution')
Mean_correct_DT=dt.*mean(DTc)
Mean_error_DT=dt.*mean(DTe)
