clear
import_baseline_data_imputed
import_transition_data_imputed
rng('default');

%% Install app to path
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\KCReg'))
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\CPD'))

%% Further Data Formulation
% Obtain Time
date = transition_data_imputed(:,'Time');
sheet = transition_data_imputed(:,'Sheet');
Time = table2array(date); % 

R_Frequency = transition_data_imputed(:,'R_Frequency');
Y_Frequency = transition_data_imputed(:,'Y_Frequency');
B_frequency = transition_data_imputed(:,'B_Frequency');

freqencies = B_frequency;

freqencies = addvars(freqencies,Y_Frequency, ...
    'Before',"B_Frequency");
freqencies.Y_Frequency = table2array( ...
    freqencies.Y_Frequency);

freqencies = addvars(freqencies,R_Frequency, ...
    'Before',"Y_Frequency");
freqencies.R_Frequency = table2array( ...
    freqencies.R_Frequency);

freqencies = [sheet date freqencies];

T = size(freqencies,1);
clear R_Frequency Y_Frequency B_frequency
%% Set up data for evaluation T = join(Tleft,Tright)
sheetnum = 3;
endOfday1 = 567;
R_frequencies = freqencies(freqencies.Sheet==sheetnum,{'R_Frequency','Sheet','Time'});
R_frequencies = [(1:size(R_frequencies))'+(sheetnum-2)*1440+endOfday1,R_frequencies.R_Frequency];

Y_frequencies = freqencies(freqencies.Sheet==sheetnum,{'Y_Frequency','Sheet','Time'});
Y_frequencies = [(1:size(Y_frequencies))'+(sheetnum-2)*1440+endOfday1,Y_frequencies.Y_Frequency];

B_frequencies = freqencies(freqencies.Sheet==sheetnum,{'B_Frequency','Sheet','Time'});
B_frequencies = [(1:size(B_frequencies))'+(sheetnum-2)*1440+endOfday1,B_frequencies.B_Frequency];

%
figure;
subplot(3,1,1);
plot(R_frequencies(:,1),R_frequencies(:,2));

subplot(3,1,2);
plot(R_frequencies(:,1),R_frequencies(:,2));

subplot(3,1,3);
plot(R_frequencies(:,1),R_frequencies(:,2));
%% cpd CHANGE POINT PREDICTION TEST

[Day5DataY,Day5AllY] = getFreq(transition_data_imputed,'Y_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);
timestep = 60;
reproduceinfo = [60,16,16];
allthedayY = Day5AllY((1:end),:);
daydataexpY = Day5AllY.Y_Frequency(1:end);

realmodelY = beast(Day5AllY.Y_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

[Day5DataR,Day5AllR] = getFreq(transition_data_imputed,'R_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataR = Day5DataR(:,2);
allthedayR = Day5AllR((1:end),:);
daydataexpR = Day5AllR.R_Frequency(1:end);

realmodelR = beast(Day5AllR.R_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

[Day5DataB,Day5AllB] = getFreq(transition_data_imputed,'B_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataB = Day5DataB(:,2);
allthedayB = Day5AllB((1:end),:);
daydataexpB = Day5AllB.B_Frequency(1:end);

realmodelB = beast(Day5AllB.B_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

fh = Day5AllY.Time(1:end);
fh = datetime(fh);

%% cpd info 
[cpReal1_R,cpReal2_R] = takeCP(realmodelR); cpReal_R = [cpReal1_R(:,1);cpReal2_R(:,1)]; cpReal_R = sort(unique(cpReal_R)); cpTimeReal_R = fh(cpReal_R); cpDataReal_R = daydataexpR(cpReal_R);
[cpRealR,cpTimeRealR,cpDataRealR] = mergeCP(timestep,realmodelR,allthedayR,Day5AllR.R_Frequency(:),0,1);

[cpReal1_Y,cpReal2_Y] = takeCP(realmodelY); 
cpReal_Y = [cpReal1_Y(:,1);cpReal2_Y(:,1)]; 
cpReal_Y = sort(unique(cpReal_Y)); 
cpTimeReal_Y = fh(cpReal_Y); 
cpDataReal_Y = daydataexpY(cpReal_Y);
[cpRealY,cpTimeRealY,cpDataRealY] = mergeCP(timestep,realmodelY,allthedayY,Day5AllY.Y_Frequency(:),0,1);

[cpReal1_B,cpReal2_B] = takeCP(realmodelB); cpReal_B = [cpReal1_B(:,1);cpReal2_B(:,1)]; cpReal_B = sort(unique(cpReal_B)); cpTimeReal_B = fh(cpReal_B); cpDataReal_B = daydataexpB(cpReal_B);
[cpRealB,cpTimeRealB,cpDataRealB] = mergeCP(timestep,realmodelB,allthedayB,Day5AllB.B_Frequency(:),0,1);

CPSeriesR = [cpRealR',cpDataRealR];
CPSeriesY = [cpRealY',cpDataRealY];
CPSeriesB = [cpRealB',cpDataRealB];

%% Point registration
Xparam = KCReg(CPSeriesR,CPSeriesY,2,0,'projective');
transformed = TransformPoint(Xparam,CPSeriesR); % the registered model
figure;  DisplayPoints(transformed, CPSeriesY);   title('KC registration result');

%%
opt.method='affine'; % use affine registration
opt.viz=1;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=100;     % max number of iterations
opt.tol=1e-10;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform=cpd_register(CPSeriesY,CPSeriesR,opt);

figure,cpd_plot_iter(CPSeriesY, CPSeriesR); title('Before');
figure,cpd_plot_iter(CPSeriesY, Transform.Y);  title('After registering Y to X');
transformed = Transform.Y;

%% Error
ALLY = Transform.Y;
EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];

format long
testMeasure = [CPSeriesR(1:3,1);CPSeriesR(5:end,1)];
M = corrcoef(testMeasure,CPSeriesB(:,1));
measurement(3) = M(1,2);
M = corrcoef(EstimatedB,CPSeriesB(:,1));
measurement(4) = M(1,2);

results = [measurement(3),measurement(4)];

figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurement(3),measurement(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

save testMeasure
save EstimatedB
save CPSeriesB
save CPSeriesR
save CPSeriesY

%%
y = CPSeriesB(:,1);
yhat = EstimatedB;
VarY = var(y);
MSE = mean((y - yhat).^2)   % Mean Squared Error
RSqure = 1-(MSE/VarY)
RMSE = sqrt(mean((y - yhat).^2))  % Root Mean Squared Error

%% Normalization
R = R_frequencies((find(R_frequencies(:,1)==2008):find(R_frequencies(:,1)==3447)),:);
[R,muR,sigmaR] = mynormalize(R);
Y = Y_frequencies((find(R_frequencies(:,1)==2008):find(R_frequencies(:,1)==3447)),:);
[Y,muY,sigmaY] = mynormalize(Y);
B = B_frequencies((find(R_frequencies(:,1)==2008):find(R_frequencies(:,1)==3447)),:);
[B,muB,sigmaB] = mynormalize(B);

%%  KC Model
Xparam = KCReg(R,Y,1,0,'projective');
transformed = TransformPoint(Xparam,R); % the registered model
figure;  DisplayPoints(transformed, Y);   title('KC registration result');
%%
Rde = mydenormalize(R,muR,sigmaR);
Bde = mydenormalize(B,muB,sigmaB);
transformedde = mydenormalize(transformed,muR,sigmaR);

% Cross Correlation
measurement = [1,1,1,1];
M = corrcoef(Rde(:,2),Bde(:,2));
measurement(1) = M(1,2);
M = corrcoef(transformedde(:,2),Bde(:,2));
measurement(2) = M(1,2);
figure;
bar([measurement(1)-measurement(1),measurement(1)-measurement(2)])
%% 
immse(transformedde(:,2),Bde(:,2))
immse(Rde(:,2),Bde(:,2))
%% CPD model

opt.method='affine'; % use affine registration
opt.viz=1;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=100;     % max number of iterations
opt.tol=1e-10;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform=cpd_register(Y,R,opt);

figure,cpd_plot_iter(Y, R); title('Before');
figure,cpd_plot_iter(Y, Transform.Y);  title('After registering Y to X');
transformed = Transform.Y;
%%
R = mydenormalize(R,muR,sigmaR);
Y = mydenormalize(Y,muY,sigmaY);
B = mydenormalize(B,muB,sigmaB);

Transform.Y = mydenormalize(Transform.Y,muR,sigmaR); % using R as the estimator

%% Cross Correlation
format long

M = corrcoef(R(:,2),B(:,2));
measurement(3) = M(1,2);
M = corrcoef(Transform.Y(:,2),B(:,2));
measurement(4) = M(1,2);

results = [measurement(1)-measurement(2),measurement(1)-measurement(4)];

figure;
name = {'KC Registration';'Coherent Point Registration'};
bar([measurement(1)-measurement(2),measurement(1)-measurement(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Curve Registration Estimation')

%% DTW - dynamic time warping
R_frequencies = getFreq(transition_data_imputed,'R_Frequency',2007,(2007+1*1440)-1);
Y_frequencies = getFreq(transition_data_imputed,'Y_Frequency',2007,(2007+1*1440)-1);
B_frequencies = getFreq(transition_data_imputed,'B_Frequency',2007,(2007+1*1440)-1);

R = mynormalize(R_frequencies);
Y = mynormalize(Y_frequencies);
B = mynormalize(B_frequencies);

[dist,iR,iB] = dtw(R_frequencies(:,2),B_frequencies(:,2));
a1 = R_frequencies(:,2);
a2 = B_frequencies(:,2);

a1w = a1(iR);
a2w = a2(iB);

t = 1:length(a1w);
duration = t(end);



%%
figure;
subplot(4,1,1)
plot(t(1:size(a1)),a1)
title('a_1, Before')
xlim([1 t(end)])

subplot(4,1,2)
plot(t,a1w)
title('a_1, Warped')

subplot(4,1,3)
plot(t(1:size(a1)),a2)
title('a_2, Before')
xlim([1 t(end)])

subplot(4,1,4)
plot(t,a2w)
title('a_2, Warped')
xlabel('Time (seconds)')

%%
figure;
subplot(4,1,1)
plot(t(1:size(a1)),a1)
title('a_1, Before')
xlim([1 t(end)])

subplot(4,1,2)
plot(t(1:size(a1)),a2)
title('a_2, Before')
xlim([1 t(end)])

subplot(4,1,3)
plot(t,a1w)
title('a_1, Warped')

subplot(4,1,4)
plot(t,a2w)
title('a_2, Warped')
xlabel('Time (seconds)')

