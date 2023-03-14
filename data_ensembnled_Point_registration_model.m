clear


% set datetime record fromattransition_gapped
datetime.setDefaultFormats('default','dd/MM/yyyy HH:mm:ss')
% set random for repeatablity
rng('default')

import_transition_data_gapped
import_baseline_data_gapped

import_transition_data_imputed
import_baseline_data_imputed
%% Obtain Time
date = transition_gapped(:,'Time');
Time = table2array(date); % 
%% Install app to path
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\KCReg'))
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\CPD'))

%% Further Data Formulation
% Obtain Time
date = transition_gapped(:,'Time');
sheet = transition_gapped(:,'Sheet');
Time = table2array(date); % 

R_Frequency = transition_gapped(:,'R_Frequency');
Y_Frequency = transition_gapped(:,'Y_Frequency');
B_frequency = transition_gapped(:,'B_Frequency');

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
%% Find Displacement From R's perspective
timepoints = [];
for n = 3:33
    sheet = transition_gapped(transition_gapped.Sheet==n,:);
    begineTime = find(transition_gapped.RECORD == sheet.RECORD(1));
    timepoints(n-2)=begineTime;
end
timepoints = timepoints';

% pick a day

beginTime = timepoints(2);
endTime = timepoints(2)+1200-1;

R_frequencies_all = transition_gapped.R_Frequency;
Y_frequencies_all = transition_gapped.Y_Frequency;
B_frequencies_all = transition_gapped.B_Frequency;

windowFrequencies = R_frequencies_all(beginTime:endTime);
timespan1 = Time(beginTime:endTime);

sizeTime = size(windowFrequencies);

differences = zeros(sizeTime(1)+1,1);
values = ceil(-sizeTime(1)/2):ceil(sizeTime(1)/2);
values = values';
for d = ceil(-sizeTime(1)/2):ceil(sizeTime(1)/2)
    absoluteDiff = abs(sum(windowFrequencies-Y_frequencies_all((beginTime+d):(endTime+d))));
    percentageDiff = absoluteDiff/sum(windowFrequencies);
    differences(d+abs(ceil(-sizeTime(1)/2))+1) = percentageDiff;
end

differences_RY = [differences,values];
mismatch_RY = values(min(find(differences==min(differences))));

list = (beginTime:endTime)';
windowFrequencies = [list,windowFrequencies];
targetFrequencies = Y_frequencies_all(beginTime+mismatch_RY:endTime+mismatch_RY);
list = (beginTime+mismatch_RY:endTime+mismatch_RY)';
targetFrequencies = [list,targetFrequencies];
timespan2=Time(beginTime+mismatch_RY:endTime+mismatch_RY);

%% BEAST analysis
[Day5DataY,Day5AllY] = getFreq(transition_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);
timestep = 60;
reproduceinfo = [60,16,16];
allthedayY = Day5AllY((1:end),:);
daydataexpY = Day5AllY.Y_Frequency(1:end);

realmodelY = beast(Day5AllY.Y_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

[Day5DataR,Day5AllR] = getFreq(transition_gapped,'R_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataR = Day5DataR(:,2);
allthedayR = Day5AllR((1:end),:);
daydataexpR = Day5AllR.R_Frequency(1:end);

realmodelR = beast(Day5AllR.R_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

[Day5DataB,Day5AllB] = getFreq(transition_gapped,'B_Frequency',567+(3+1-2)*1440,567+(8+1-2)*1440-1);
Day5DataB = Day5DataB(:,2);
allthedayB = Day5AllB((1:end),:);
daydataexpB = Day5AllB.B_Frequency(1:end);

realmodelB = beast(Day5AllB.B_Frequency(1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

fh = Day5AllY.Time(1:end);
fh = datetime(fh);

%% cpd info 
[cpReal1_R,cpReal2_R] = takeCP(realmodelR,0); cpReal_R = [cpReal1_R(:,1);cpReal2_R(:,1)]; cpReal_R = sort(unique(cpReal_R)); cpTimeReal_R = fh(cpReal_R); cpDataReal_R = daydataexpR(cpReal_R);
[cpRealR,cpTimeRealR,cpDataRealR] = mergeCP(timestep,realmodelR,allthedayR,Day5AllR.R_Frequency(:),0,1);

[cpReal1_Y,cpReal2_Y] = takeCP(realmodelY,0); 
cpReal_Y = [cpReal1_Y(:,1);cpReal2_Y(:,1)]; 
cpReal_Y = sort(unique(cpReal_Y)); 
cpTimeReal_Y = fh(cpReal_Y); 
cpDataReal_Y = daydataexpY(cpReal_Y);
[cpRealY,cpTimeRealY,cpDataRealY] = mergeCP(timestep,realmodelY,allthedayY,Day5AllY.Y_Frequency(:),0,1);

[cpReal1_B,cpReal2_B] = takeCP(realmodelB,0); cpReal_B = [cpReal1_B(:,1);cpReal2_B(:,1)]; cpReal_B = sort(unique(cpReal_B)); cpTimeReal_B = fh(cpReal_B); cpDataReal_B = daydataexpB(cpReal_B);
[cpRealB,cpTimeRealB,cpDataRealB] = mergeCP(timestep,realmodelB,allthedayB,Day5AllB.B_Frequency(:),0,1);

CPSeriesR = [cpRealR',cpDataRealR];
CPSeriesY = [cpRealY',cpDataRealY];
CPSeriesB = [cpRealB',cpDataRealB];

%% Point registration - KC
%Xparam = KCReg(CPSeriesR,CPSeriesY,2,0,'projective');
%transformed = TransformPoint(Xparam,CPSeriesR); % the registered model
%figure;  DisplayPoints(transformed, CPSeriesY);   title('KC registration result');

%% - CPD
opt.method='affine'; % use affine registration
opt.viz=1;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(CPSeriesY,CPSeriesR,opt);

figure,cpd_plot_iter(CPSeriesY, CPSeriesR); title('Before');
figure,cpd_plot_iter(CPSeriesY, Transform_affine.Y);  title('After registering Y to X');
transformed = Transform_affine.Y;

%% Error
ALLY = Transform_affine.Y;
EstimatedB = [Transform_affine.Y(1:4,1);Transform_affine.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
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

%%
y = CPSeriesB(:,1);
yhat = EstimatedB;
VarY = var(y);
MSE = mean((y - yhat).^2)   % Mean Squared Error
RSqure = 1-(MSE/VarY)
RMSE = sqrt(mean((y - yhat).^2))  % Root Mean Squared Error

%% - CPD - entire seires - Different Method
[R_1440_min,Day5AllR] = getFreq(transition_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

[Y_1440_min,Day5DataY] = getFreq(transition_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

[B_1440_min,Day5AllB] = getFreq(transition_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);

%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.05;   % use 0.1 noise weight
opt.corresp=0;      % compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
    opt.fgt=0; % not using FGT because no need, and the function is bugged;
% registering 2nd to 1st
Transform_affine=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_Rigid.Y);  title('After registering Y to X');


Transform_rigid_RY_transition_gapped = Transform_Rigid;
Transform_affine_RY_transition_gapped = Transform_affine;
Transform_nonRigid_RY_transition_gapped = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RY_B_transition_gapped.mat","Transform_rigid_RY_transition_gapped", ...
    "Transform_affine_RY_transition_gapped","Transform_nonRigid_RY_transition_gapped")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),normalize(B_1440_min(:,2)));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

gapped_err_Rig = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig = gapped_err_Rig/mean(B_1440_min(:,2));

gapped_err_Aff = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff = gapped_err_Aff/mean(B_1440_min(:,2));

gapped_err_Non = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non = gapped_err_Non/mean(B_1440_min(:,2));
%
gapped_CpD_RY_B_rig = measurementallRigid(3)-measurementallRigid(4);
gapped_CpD_RY_B_aff = measurementallAffine(3)-measurementallAffine(4);
gapped_CpD_RY_B_non = measurementallNonRigid(3)-measurementallNonRigid(4);
measurement_taken = [gapped_CpD_RY_B_rig,gapped_CpD_RY_B_aff,gapped_CpD_RY_B_non,0,0,0;1,1,1,0,0,0];

measurement_mspe = [gapped_err_Rig,gapped_err_Aff,gapped_err_Non,0,0,0;1,1,1,0,0,0];


measurement_taken_in_gapped = [gapped_CpD_RY_B_rig,gapped_CpD_RY_B_aff,gapped_CpD_RY_B_non,0,0,0;1,1,1,0,0,0];
measurement_mspe_in_gapped = [gapped_err_Rig,gapped_err_Aff,gapped_err_Non,0,0,0;1,1,1,0,0,0];
%%
%% - CPD - entire seires - Different Method - Baseline Gapped
%[R_1440_min,Day5AllR] = getFreq(baseline_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

%[Y_1440_min,Day5DataY] = getFreq(baseline_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

%[B_1440_min,Day5AllB] = getFreq(baseline_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);
time = baseline_gapped.Time(637+(3+1-2)*1440:637+(4+1-2)*1440-1);
time = datetime(time);
R_1440_min = baseline_gapped.R_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
R_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',R_1440_min];

Y_1440_min = baseline_gapped.Y_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
Y_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',Y_1440_min];

B_1440_min = baseline_gapped.B_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
B_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',B_1440_min];
%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.corresp=0;      %compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RY_baseline_gapped = Transform_Rigid;
Transform_affine_RY_baseline_gapped = Transform_affine;
Transform_nonRigid_RY_baseline_gapped = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RY_baseline_gapped.mat","Transform_rigid_RY_baseline_gapped", ...
    "Transform_affine_RY_baseline_gapped","Transform_nonRigid_RY_baseline_gapped")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),normalize(B_1440_min(:,2)));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

gapped_err_Rig = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig = gapped_err_Rig/mean(B_1440_min(:,2));

gapped_err_Aff = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff = gapped_err_Aff/mean(B_1440_min(:,2));

gapped_err_Non = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non = gapped_err_Non/mean(B_1440_min(:,2));
%
gapped_CpD_RY_B_rig_basel = measurementallRigid(3)-measurementallRigid(4);
gapped_CpD_RY_B_aff_basel = measurementallAffine(3)-measurementallAffine(4);
gapped_CpD_RY_B_non_basel = measurementallNonRigid(3)-measurementallNonRigid(4);

measurement_taken_in_gapped(1,4) = gapped_CpD_RY_B_rig_basel;
measurement_taken_in_gapped(1,5) = gapped_CpD_RY_B_aff_basel;
measurement_taken_in_gapped(1,6) = gapped_CpD_RY_B_non_basel;

measurement_taken_in_gapped(2,1) = 11;
measurement_taken_in_gapped(2,2) = 12;
measurement_taken_in_gapped(2,3) = 13;

measurement_taken_in_gapped(2,4) = 21;
measurement_taken_in_gapped(2,5) = 22;
measurement_taken_in_gapped(2,6) = 23;

save('PR_Model_Building_Result_in_Gapped_corrcoeff.mat','measurement_taken_in_gapped')

gapped_err_Rig_basel = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig_basel = gapped_err_Rig_basel/mean(B_1440_min(:,2));

gapped_err_Aff_basel = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff_basel = gapped_err_Aff_basel/mean(B_1440_min(:,2));

gapped_err_Non_basel = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non_basel = gapped_err_Non_basel/mean(B_1440_min(:,2));

measurement_mspe_in_gapped(1,4) = gapped_err_Rig_basel;
measurement_mspe_in_gapped(1,5) = gapped_err_Aff_basel;
measurement_mspe_in_gapped(1,6) = gapped_err_Non_basel;

measurement_mspe_in_gapped(2,1) = 11;
measurement_mspe_in_gapped(2,2) = 12;
measurement_mspe_in_gapped(2,3) = 13;

measurement_mspe_in_gapped(2,4) = 21;
measurement_mspe_in_gapped(2,5) = 22;
measurement_mspe_in_gapped(2,6) = 23;

save('PR_Model_Building_Result_in_Gapped_mspe.mat','measurement_mspe_in_gapped')
%%
%%
%%
%%
%%
%% - CPD - entire seires - Different Method - Using RB to Give Y
[R_1440_min,Day5AllR] = getFreq(transition_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

[Y_1440_min,Day5DataY] = getFreq(transition_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

[B_1440_min,Day5AllB] = getFreq(transition_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);

%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
    opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RB_transitiongapped = Transform_Rigid;
Transform_affine_RB_transition_gapped = Transform_affine;
Transform_nonRigid_RB_transition_gapped = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RB_transition_gapped.mat","Transform_rigid_RB_transitiongapped", ...
    "Transform_affine_RB_transition_gapped","Transform_nonRigid_RB_transition_gapped")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),Y_1440_min(:,2));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),Y_1440_min(:,2));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),Y_1440_min(:,2));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

gapped_err_Rig_RBY = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig_RBY = gapped_err_Rig_RBY/mean(Y_1440_min(:,2));

gapped_err_Aff_RBY = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff_RBY = gapped_err_Aff_RBY/mean(Y_1440_min(:,2));

gapped_err_Non_RBY = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non_RBY = gapped_err_Non_RBY/mean(Y_1440_min(:,2));
%
gapped_CpD_RB_Y_rig = measurementallRigid(3)-measurementallRigid(4);
gapped_CpD_RB_Y_aff = measurementallAffine(3)-measurementallAffine(4);
gapped_CpD_RB_Y_non = measurementallNonRigid(3)-measurementallNonRigid(4);

measurement_taken_in_gapped_RBY = [gapped_CpD_RB_Y_rig,gapped_CpD_RB_Y_aff,gapped_CpD_RB_Y_non,0,0,0;1,1,1,0,0,0];
measurement_mspe_in_gapped_RBY = [gapped_err_Rig_RBY,gapped_err_Aff_RBY,gapped_err_Non_RBY,0,0,0;1,1,1,0,0,0];
%%
%% - CPD - entire seires - Different Method - Baseline Gapped
%[R_1440_min,Day5AllR] = getFreq(baseline_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

%[Y_1440_min,Day5DataY] = getFreq(baseline_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

%[B_1440_min,Day5AllB] = getFreq(baseline_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);
time = baseline_gapped.Time(637+(3+1-2)*1440:637+(4+1-2)*1440-1);
time = datetime(time);
R_1440_min = baseline_gapped.R_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
R_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',R_1440_min];

Y_1440_min = baseline_gapped.Y_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
Y_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',Y_1440_min];

B_1440_min = baseline_gapped.B_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
B_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',B_1440_min];
%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-10;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RB_baseline_gapped = Transform_Rigid;
Transform_affine_RB_baseline_gapped = Transform_affine;
Transform_nonRigid_RB_baseline_gapped = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RB_baseline_gapped.mat","Transform_rigid_RB_baseline_gapped", ...
    "Transform_affine_RB_baseline_gapped","Transform_nonRigid_RB_baseline_gapped")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),Y_1440_min(:,2));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),Y_1440_min(:,2));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),Y_1440_min(:,2));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

gapped_err_Rig = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig = gapped_err_Rig/mean(Y_1440_min(:,2));

gapped_err_Aff = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff = gapped_err_Aff/mean(Y_1440_min(:,2));

gapped_err_Non = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non = gapped_err_Non/mean(Y_1440_min(:,2));
%
gapped_CpD_RY_B_rig_basel_RBY = measurementallRigid(3)-measurementallRigid(4);
gapped_CpD_RY_B_aff_basel_RBY = measurementallAffine(3)-measurementallAffine(4);
gapped_CpD_RY_B_non_basel_RBY = measurementallNonRigid(3)-measurementallNonRigid(4);

measurement_taken_in_gapped_RBY(1,4) = gapped_CpD_RY_B_rig_basel_RBY;
measurement_taken_in_gapped_RBY(1,5) = gapped_CpD_RY_B_aff_basel_RBY;
measurement_taken_in_gapped_RBY(1,6) = gapped_CpD_RY_B_non_basel_RBY;

measurement_taken_in_gapped_RBY(2,1) = 11;
measurement_taken_in_gapped_RBY(2,2) = 12;
measurement_taken_in_gapped_RBY(2,3) = 13;

measurement_taken_in_gapped_RBY(2,4) = 21;
measurement_taken_in_gapped_RBY(2,5) = 22;
measurement_taken_in_gapped_RBY(2,6) = 23;

save('PR_Model_Building_RBY_Result_in_Gapped_corrcoeff.mat','measurement_taken_in_gapped_RBY')

gapped_err_Rig_basel = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
gapped_err_Rig_basel = gapped_err_Rig_basel/mean(B_1440_min(:,2));

gapped_err_Aff_basel = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
gapped_err_Aff_basel = gapped_err_Aff_basel/mean(B_1440_min(:,2));

gapped_err_Non_basel = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
gapped_err_Non_basel = gapped_err_Non_basel/mean(B_1440_min(:,2));

measurement_mspe_in_gapped_RBY(1,4) = gapped_err_Rig_basel;
measurement_mspe_in_gapped_RBY(1,5) = gapped_err_Aff_basel;
measurement_mspe_in_gapped_RBY(1,6) = gapped_err_Non_basel;

measurement_mspe_in_gapped_RBY(2,1) = 11;
measurement_mspe_in_gapped_RBY(2,2) = 12;
measurement_mspe_in_gapped_RBY(2,3) = 13;

measurement_mspe_in_gapped_RBY(2,4) = 21;
measurement_mspe_in_gapped_RBY(2,5) = 22;
measurement_mspe_in_gapped_RBY(2,6) = 23;

save('PR_Model_Building_Result_RBY_in_Gapped_mspe.mat','measurement_mspe_in_gapped_RBY')
%%
%%
%%
%%
% RBY failed to register baseline frequencies with non-Rigid method of CP
% Drift. See data.
%
%
%
%
%%
%% - CPD - entire seires - Different Method - RF Imputed
[R_1440_min,Day5AllR] = getFreq(transition_data_imputed,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

[Y_1440_min,Day5DataY] = getFreq(transition_data_imputed,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

[B_1440_min,Day5AllB] = getFreq(transition_data_imputed,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);

%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-10;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RY_B_transition_imputed = Transform_Rigid;
Transform_affine_RY_B_transition_imputed = Transform_affine;
Transform_nonRigid_RY_B_transition_imputed = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RY_B_transition_imputed.mat","Transform_rigid_RY_B_transition_imputed", ...
    "Transform_affine_RY_B_transition_imputed","Transform_nonRigid_RY_B_transition_imputed")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),normalize(B_1440_min(:,2)));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),B_1440_min(:,2));
measurementallNonRigid(4) = M(1,2);

%% 
figure; hold on;

plot(1:length(R_1440_min(:,2)),B_1440_min(:,2),'.');
plot(1:length(R_1440_min(:,2)),Transform_nonRigid.Y(:,2),'.');

hold off;
legend('Real B-Frequency on Day 3','Estimation via CP Drift with 100 iteration in Non-Rigid mode')
xlabel('Data Points');
ylabel('Frequency');
%

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),B_1440_min(:,2));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

imputed_CpD_RY_B_rig = measurementallRigid(3)-measurementallRigid(4);
imputed_CpD_RY_B_aff = measurementallAffine(3)-measurementallAffine(4);
imputed_CpD_RY_B_non = measurementallNonRigid(3)-measurementallNonRigid(4);
measurement_taken(1,4) = imputed_CpD_RY_B_rig;
measurement_taken(1,5) = imputed_CpD_RY_B_aff;
measurement_taken(1,6) = imputed_CpD_RY_B_non;

measurement_taken(2,1) = 11;
measurement_taken(2,2) = 12;
measurement_taken(2,3) = 13;

measurement_taken(2,4) = 21;
measurement_taken(2,5) = 22;
measurement_taken(2,6) = 23;

save('PR_Model_Building_Tuning_Correlation_Masurements.mat','measurement_taken')

imputed_err_Rig = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig = imputed_err_Rig/mean(B_1440_min(:,2));

imputed_err_Aff = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff = imputed_err_Aff/mean(B_1440_min(:,2));

imputed_err_Non = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non = imputed_err_Non/mean(B_1440_min(:,2));

measurement_mspe(1,4) = imputed_err_Rig;
measurement_mspe(1,5) = imputed_err_Aff;
measurement_mspe(1,6) = imputed_err_Non;

measurement_mspe(2,1) = 11;
measurement_mspe(2,2) = 12;
measurement_mspe(2,3) = 13;

measurement_mspe(2,4) = 21;
measurement_mspe(2,5) = 22;
measurement_mspe(2,6) = 23;

save('PR_Model_Building_Tuning_MSPE.mat','measurement_mspe')

%% - CPD - entire seires - Different Method - Baseline Gapped
%[R_1440_min,Day5AllR] = getFreq(baseline_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

%[Y_1440_min,Day5DataY] = getFreq(baseline_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

%[B_1440_min,Day5AllB] = getFreq(baseline_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);
time = baseline_data_imputed.Time(637+(3+1-2)*1440:637+(4+1-2)*1440-1);
time = datetime(time);
R_1440_min = baseline_data_imputed.R_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
R_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',R_1440_min];

Y_1440_min = baseline_data_imputed.Y_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
Y_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',Y_1440_min];

B_1440_min = baseline_data_imputed.B_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
B_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',B_1440_min];
%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.corresp=0;      %compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(Y_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(Y_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(Y_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RB = Transform_Rigid;
Transform_affine_RB = Transform_affine;
Transform_nonRigid_RB = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RY_B_baseline_imputed.mat","Transform_rigid_RY_B_baseline_imputed", ...
    "Transform_affine_RY_B_baseline_imputed","Transform_nonRigid_RY_B_baseline_imputed")

%% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),normalize(B_1440_min(:,2)));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),B_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),normalize(B_1440_min(:,2)));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

imputed_err_Rig = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig = imputed_err_Rig/mean(B_1440_min(:,2));

imputed_err_Aff = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff = imputed_err_Aff/mean(B_1440_min(:,2));

imputed_err_Non = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non = imputed_err_Non/mean(B_1440_min(:,2));
%
imputed_CpD_RY_B_rig_basel = measurementallRigid(3)-measurementallRigid(4);
imputed_CpD_RY_B_aff_basel = measurementallAffine(3)-measurementallAffine(4);
imputed_CpD_RY_B_non_basel = measurementallNonRigid(3)-measurementallNonRigid(4);
measurement_taken_in_imputed_baseline = [1,1,1]';

measurement_taken_in_imputed_baseline(1) = imputed_CpD_RY_B_rig_basel;
measurement_taken_in_imputed_baseline(2) = imputed_CpD_RY_B_aff_basel;
measurement_taken_in_imputed_baseline(3) = imputed_CpD_RY_B_non_basel;

save('PR_Model_Building_Result_in_Imputed_corrcoeff_baseline.mat','measurement_taken_in_imputed_baseline')

imputed_err_Rig_basel = immse(B_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig_basel = imputed_err_Rig_basel/mean(B_1440_min(:,2));

imputed_err_Aff_basel = immse(B_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff_basel = imputed_err_Aff_basel/mean(B_1440_min(:,2));

imputed_err_Non_basel = immse(B_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non_basel = imputed_err_Non_basel/mean(B_1440_min(:,2));

measurement_mspe_in_Imputed_baseline = [1,1,1]';

measurement_mspe_in_Imputed_baseline(1) = imputed_err_Rig_basel;
measurement_mspe_in_Imputed_baseline(2) = imputed_err_Aff_basel;
measurement_mspe_in_Imputed_baseline(3) = imputed_err_Non_basel;

save('PR_Model_Building_Result_in_Imputed_mspe_baseline.mat','measurement_mspe_in_Imputed_baseline')
%%
%%
%%
%% - CPD - entire seires - Different Method - Baseline Imputed
%[R_1440_min,Day5AllR] = getFreq(baseline_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

%[Y_1440_min,Day5DataY] = getFreq(baseline_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

%[B_1440_min,Day5AllB] = getFreq(baseline_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);
time = baseline_data_imputed.Time(637+(3+1-2)*1440:637+(4+1-2)*1440-1);
time = datetime(time);
R_1440_min = baseline_data_imputed.R_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
R_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',R_1440_min];

Y_1440_min = baseline_data_imputed.Y_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
Y_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',Y_1440_min];

B_1440_min = baseline_data_imputed.B_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
B_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',B_1440_min];
%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.corresp=0;      %compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RB_baseline_imputed = Transform_Rigid;
Transform_affine_RB_baseline_imputed = Transform_affine;
Transform_nonRigid_RB_baseline_imputed = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RB_Y_baseline_imputed.mat","Transform_rigid_RB_baseline_imputed", ...
    "Transform_affine_RB_baseline_imputed","Transform_nonRigid_RB_baseline_imputed")

% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),Y_1440_min(:,2));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')
%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),Y_1440_min(:,2));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),Y_1440_min(:,2));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

imputed_err_Rig = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig = imputed_err_Rig/mean(Y_1440_min(:,2));

imputed_err_Aff = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff = imputed_err_Aff/mean(Y_1440_min(:,2));

imputed_err_Non = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non = imputed_err_Non/mean(Y_1440_min(:,2));
%
imputed_CpD_RY_B_rig_basel = measurementallRigid(3)-measurementallRigid(4);
imputed_CpD_RY_B_aff_basel = measurementallAffine(3)-measurementallAffine(4);
imputed_CpD_RY_B_non_basel = measurementallNonRigid(3)-measurementallNonRigid(4);

measurement_taken_in_imputed_baseline_RBY = [1,1,1]';

measurement_taken_in_imputed_baseline_RBY(1) = imputed_CpD_RY_B_rig_basel;
measurement_taken_in_imputed_baseline_RBY(2) = imputed_CpD_RY_B_aff_basel;
measurement_taken_in_imputed_baseline_RBY(3) = imputed_CpD_RY_B_non_basel;

save('PR_Model_Building_Result_in_Imputed_corrcoeff_RBY_baseline.mat','measurement_taken_in_imputed_baseline_RBY')

imputed_err_Rig_basel = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig_basel = imputed_err_Rig_basel/mean(Y_1440_min(:,2));

imputed_err_Aff_basel = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff_basel = imputed_err_Aff_basel/mean(Y_1440_min(:,2));

imputed_err_Non_basel = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non_basel = imputed_err_Non_basel/mean(Y_1440_min(:,2));

measurement_mspe_in_Imputed_baseline_RBY = [1,1,1]';

measurement_mspe_in_Imputed_baseline_RBY(1) = imputed_err_Rig_basel;
measurement_mspe_in_Imputed_baseline_RBY(2) = imputed_err_Aff_basel;
measurement_mspe_in_Imputed_baseline_RBY(3) = imputed_err_Non_basel;

save('PR_Model_Building_Result_in_Imputed_mspe_RBY_baseline.mat','measurement_mspe_in_Imputed_baseline_RBY')
%%
%%
%%
%% - CPD - entire seires - Different Method - Baseline Gapped
%[R_1440_min,Day5AllR] = getFreq(baseline_gapped,'R_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%R_1440_min = R_1440_min(:,2);

%[Y_1440_min,Day5DataY] = getFreq(baseline_gapped,'Y_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%Y_1440_min = Y_1440_min(:,2);

%[B_1440_min,Day5AllB] = getFreq(baseline_gapped,'B_Frequency',567+(3+1-2)*1440,567+(4+1-2)*1440-1);
%B_1440_min = B_1440_min(:,2);
time = baseline_data_imputed.Time(637+(3+1-2)*1440:637+(4+1-2)*1440-1);
time = datetime(time);
R_1440_min = transition_data_imputed.R_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
R_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',R_1440_min];

Y_1440_min = transition_data_imputed.Y_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
Y_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',Y_1440_min];

B_1440_min = transition_data_imputed.B_Frequency(631+(3+1-2)*1440:631+(4+1-2)*1440-1);
B_1440_min = [(631+(3+1-2)*1440:631+(4+1-2)*1440-1)',B_1440_min];
%
opt.method='affine'; % use affine registration
opt.viz=0;          % show every iteration
opt.outliers=0.1;   % use 0.5 noise weight

opt.corresp=0;      %compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

opt.max_it=1000;     % max number of iterations
opt.tol=1e-8;       % tolerance
opt.fgt=0; % Use Case 1         
                    % options: [0,1,2] % Fast Gauss transform (FGT)
                    %  if > 0, then use FGT. case 1: FGT with fixing sigma after it gets too small (faster, but the result can be rough)
                    %  case 2: FGT, followed by truncated Gaussian approximation (can be quite slow after switching to the truncated kernels, but more accurate than case 1)

% registering 2nd to 1st
Transform_affine=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_affine.Y);  title('After registering Y to X');


opt.method='nonrigid'; % use affine registration

% registering 2nd to 1st
Transform_nonRigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_nonRigid.Y);  title('After registering Y to X');

opt.method='rigid'; % use affine registration

% registering 2nd to 1st
Transform_Rigid=cpd_register(B_1440_min,R_1440_min,opt);

figure,cpd_plot_iter(B_1440_min, R_1440_min); title('Before');
figure,cpd_plot_iter(B_1440_min, Transform_Rigid.Y);  title('After registering Y to X');

Transform_rigid_RB_imputed_transition = Transform_Rigid;
Transform_affine_RB_imputed_transition = Transform_affine;
Transform_nonRigid_RB_imputed_transition = Transform_nonRigid;
save("dataIncluded\PRmodel\Models_RB_Y_imputed_transition.mat","Transform_rigid_RB_imputed_transition", ...
    "Transform_affine_RB_imputed_transition","Transform_nonRigid_RB_imputed_transition")

% Error - Using this
%%%%%%%%%%%%%% Affine
ALLY = Transform_affine.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallAffine(3) = M(1,2);
M = corrcoef(Transform_affine.Y(:,2),Y_1440_min(:,2));
measurementallAffine(4) = M(1,2);

results = [measurementallAffine(3),measurementallAffine(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallAffine(3)-measurementallAffine(3),measurementallAffine(3)-measurementallAffine(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% NonRigid
ALLY = Transform_nonRigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallNonRigid(3) = M(1,2);
M = corrcoef(Transform_nonRigid.Y(:,2),Y_1440_min(:,2));
measurementallNonRigid(4) = M(1,2);

results = [measurementallNonRigid(3),measurementallNonRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallNonRigid(3)-measurementallNonRigid(3),measurementallNonRigid(3)-measurementallNonRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

%%%%%%%%%%%%%% Rigid
ALLY = Transform_Rigid.Y;
%EstimatedB = [Transform.Y(1:4,1);Transform.Y(6:end,1)];
%CPSeriesB=[CPSeriesB(1:3,1);CPSeriesB(5:8,1);CPSeriesB(10:14,1)];
format long
M = corrcoef(R_1440_min(:,2),Y_1440_min(:,2));
measurementallRigid(3) = M(1,2);
M = corrcoef(Transform_Rigid.Y(:,2),Y_1440_min(:,2));
measurementallRigid(4) = M(1,2);

results = [measurementallRigid(3),measurementallRigid(4)];
figure;
name = {'Original R to B';'Coherent Point Registration Estimated B'};
bar([measurementallRigid(3)-measurementallRigid(3),measurementallRigid(3)-measurementallRigid(4)])
set(gca,'xticklabel',name)
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center'); 
title('Differences Between Correlation before and after the Registration')

imputed_err_Rig = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig = imputed_err_Rig/mean(Y_1440_min(:,2));

imputed_err_Aff = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff = imputed_err_Aff/mean(Y_1440_min(:,2));

imputed_err_Non = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non = imputed_err_Non/mean(Y_1440_min(:,2));
%
imputed_CpD_RY_B_rig_basel = measurementallRigid(3)-measurementallRigid(4);
imputed_CpD_RY_B_aff_basel = measurementallAffine(3)-measurementallAffine(4);
imputed_CpD_RY_B_non_basel = measurementallNonRigid(3)-measurementallNonRigid(4);

measurement_taken_in_imputed_transition_RBY = [1,1,1]';

measurement_taken_in_imputed_transition_RBY(1) = imputed_CpD_RY_B_rig_basel;
measurement_taken_in_imputed_transition_RBY(2) = imputed_CpD_RY_B_aff_basel;
measurement_taken_in_imputed_transition_RBY(3) = imputed_CpD_RY_B_non_basel;

save('PR_Model_Building_Result_in_Imputed_corrcoeff_RBY_transition.mat','measurement_taken_in_imputed_transition_RBY')

imputed_err_Rig_basel = immse(Y_1440_min(:,2),Transform_Rigid.Y(:,2));
imputed_err_Rig_basel = imputed_err_Rig_basel/mean(Y_1440_min(:,2));

imputed_err_Aff_basel = immse(Y_1440_min(:,2),Transform_affine.Y(:,2));
imputed_err_Aff_basel = imputed_err_Aff_basel/mean(Y_1440_min(:,2));

imputed_err_Non_basel = immse(Y_1440_min(:,2),Transform_nonRigid.Y(:,2));
imputed_err_Non_basel = imputed_err_Non_basel/mean(Y_1440_min(:,2));

measurement_mspe_in_Imputed_transition_RBY = [1,1,1]';

measurement_mspe_in_Imputed_transition_RBY(1) = imputed_err_Rig_basel;
measurement_mspe_in_Imputed_transition_RBY(2) = imputed_err_Aff_basel;
measurement_mspe_in_Imputed_transition_RBY(3) = imputed_err_Non_basel;

save('PR_Model_Building_Result_in_Imputed_mspe_RBY_transition.mat','measurement_mspe_in_Imputed_transition_RBY')
