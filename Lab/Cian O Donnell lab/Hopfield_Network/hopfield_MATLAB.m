%% Load Training Data
D=readtable('train_images.csv');
D=table2array(D);
D1=reshape(D(1,:),[28 28]);
D2=reshape(D(2,:),[28 28]);
D3=reshape(D(3,:),[28 28]);
figure(1);
subplot(2,2,1);
imshow(D1.');
subplot(2,2,2);
imshow(D2.');
subplot(2,2,3);
imshow(D3.');
%% Create neurons understanding correlations
W=((repmat(D(1,:)',1,784).*repmat(D(1,:),784,1))+(repmat(D(2,:)',1,784).*repmat(D(2,:),784,1))+(repmat(D(3,:)',1,784).*repmat(D(3,:),784,1)))./3;
for i=1:784
    W(i,i)=0;
end
figure(2);
imshow(W);
%% Load Testing Data
T=readtable('test_images.csv');
T=table2array(T);
T1=reshape(T(1,:),[28 28]);
T2=reshape(T(2,:),[28 28]);

%% Test 1: State update
N_iter=[1000,5000,10000];

figure(3);
subplot(1,length(N_iter)+1,1);
imshow(T1.');
pause(3);

for i=1:length(N_iter)
    T1_updt=T(1,:);
    for iter=1:N_iter(i)
        T1_updt=updatestate(W,T1_updt);
    end
    T1_updt=reshape(T1_updt,[28 28]);
    figure(3);
    subplot(1,length(N_iter)+1,i+1);
    imshow(T1_updt.');
    pause(2);
end

%% Test 2: State update
N_iter=[1000,5000,10000];

figure(4);
subplot(1,length(N_iter)+1,1);
imshow(T2);
pause(3);

for i=1:length(N_iter)
    T2_updt=T(2,:);
    for iter=1:N_iter(i)
        T2_updt=updatestate(W,T2_updt);
    end
    T2_updt=reshape(T2_updt,[28 28]);
    figure(4);
    subplot(1,length(N_iter)+1,i+1);
    imshow(T2_updt.');
    pause(2);
end

%% function to update state asynchronously
function X=updatestate(W,x)
Index=randsample([1:784],1);
Input=W(Index,:)*x';
if Input>=0
   x(Index)=1; 
else
   x(Index)=-1;
end
X=x;
end
