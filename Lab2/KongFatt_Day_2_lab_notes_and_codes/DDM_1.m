% A basic drift-diffusion model (DDM) to fit behavioural/psychophysical data

close all; clear all;

z1=1; % Upper decision threshold (choice 1)
z2=-1; % Lower decision threshol (choice 2)
sigma=0.2; % Size of the noise
A=0.03; % Drift rate

DTc=[]; % Correct decision time
DTe=[]; % Error decision time

x(1)=0; % Starting point of decision variable x

dt=0.1; % Time step

for trials=1:10000 % Trial number
    for t=1:2000/dt % Time
        x(t+1)=x(t) + dt*A + sqrt(dt)*sigma*randn ; % Update x
        if x(t)>=z1 % Condition for x crossing the upper decision threshold
            DTc=[DTc t]; % Record the correct decision time (if A>0)
            break;
        end;
        if x(t)<=z2 % Condition for x crossing the lower decision threshold
            DTe=[DTe t]; % Record the error decision time (if A>0)
            break; 
        end;
    end;

        
end;

figure; plot([dt:dt:dt*t],x(1:t)); axis tight; hold on; 
title('Sample time course of decision variable X'); box off;
plot([dt:dt:dt*t],z1.*ones(1,length(x(1:t))),'k--'); hold on;
plot([dt:dt:dt*t],z2.*ones(1,length(x(1:t))),'k--'); 
plot([dt:dt:dt*t],zeros(1,length(x(1:t))),'k-'); 
ylim([-1.1 1.1]);
hold off;

% Histogram (i.e. frequency) plot for correct trials
figure; hist(dt.*DTc,50); title('Correct DT distribution'); 
% Histogram (i.e. frequency) plot for error trials
figure; hist(dt.*DTe,50); title('Error DT distribution');

size(DTc,2)+size(DTe,2) % Total number of trials
size(DTc,2) % Total number of correct trials
Accuracy=size(DTc,2)/(size(DTc,2)+size(DTe,2)) % Fraction of correct trials
Mean_correct_DT=dt.*mean(DTc)
Mean_error_DT=dt.*mean(DTe)
