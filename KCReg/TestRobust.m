clear;
figure(1); clf;
%loading up the data
scene = load('scene.txt');

%transform the scene point and build the model data point set.
t = [0,0,pi/6];
model = TransformPoint(t,scene);

% add noise to both the scene and model point sets.
M = scene + .1 * randn(size(model));

% the point sets not corrupted by outliers yet.
S0 = scene + .1 * randn(size(model));
M0 = TransformPoint(t,M);

len = length(M); %length of the inlier points
outlier_ratio = .2;
olen = round(outlier_ratio*len); %length of the outlier points

%bandwith for the kernels
bandwidth = 5;
%threshold for outlier detection in ICP
th = 5;
%display the intermediate registration results.
display_it = 1;

%add outlier points to the model point set
out_liers = rand(olen,2);
out_liers(:,1) = out_liers(:,1)*65 -50;
out_liers(:,2) = out_liers(:,2)*60 -15;
M = [M0;out_liers];

%add outlier points to the scene point set
out_liers = rand(olen,2);
out_liers(:,1) = out_liers(:,1)*65 -50;
out_liers(:,2) = out_liers(:,2)*60 -15;
S = [S0;out_liers];

% register using KC registration
paramKC = KCReg(M,S,bandwidth,display_it);
tMKC = TransformPoint(paramKC,M); % the registered model

%register using ICP registration   
tMICP = ICP(M,S,th,display_it);

%display the outputs
figure(1); clf; 
subplot(1,2,1);  DisplayPoints(tMKC, scene);   title('KC registration result');
subplot(1,2,2);  DisplayPoints(tMICP, scene);  title('ICP registration result');
