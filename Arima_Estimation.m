%% Import data from text file
clear
rng default

% set datetime record fromat
datetime.setDefaultFormats('default','dd/MM/yyyy HH:mm:ss')
% set random for repeatablity
rng('default')

import_transition_data_imputed
import_baseline_data_imputed

%% Obtain Time
date = transition_data_imputed(:,'Time');
Time = table2array(date); % 

%% BEAST analysis
% Extract 1-day's worth of data and its original analysis result
[beastmodel_R,Day1AllR,Day1DataR] = beast_date(transition_data_imputed,'R_Frequency',[3 3],60);
[beastmodel_Y,Day1AllY,Day1DataY] = beast_date(transition_data_imputed,'Y_Frequency',[3 3],60);
[beastmodel_B,Day1AllB,Day1DataB] = beast_date(transition_data_imputed,'B_Frequency',[3 3],60);

models = [beastmodel_R,beastmodel_Y,beastmodel_B];
data = [Day1DataR,Day1DataY,Day1DataB];

%% Combine changepoints
timestep = 60;
[cpR,cpTimeR,cpDataR] = mergeCP(timestep,beastmodel_R,Day1AllR,Day1DataR);
[cpY,cpTimeY,cpDataY] = mergeCP(timestep,beastmodel_Y,Day1AllY,Day1DataY);
[cpB,cpTimeB,cpDataB] = mergeCP(timestep,beastmodel_B,Day1AllB,Day1DataB);
%% plot to check
figure; 
subplot(3,1,1); hold on;
plot(datetime(table2array(Day1AllR(:,'Time'))),Day1DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(cpTimeR,'k-','HandleVisibility','off');
plot(cpTimeR,cpDataR,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,2); hold on;
plot(datetime(table2array(Day1AllY(:,'Time'))),Day1DataY,'.',"Color","black",'DisplayName','Y-freq Ovetime');
xline(cpTimeY,'k-','HandleVisibility','off');
plot(cpTimeY,cpDataY,'ko','DisplayName','Y - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,3); hold on;
plot(datetime(table2array(Day1AllB(:,'Time'))),Day1DataB,'.',"Color","blue",'DisplayName','B-freq Ovetime');
xline(cpTimeB,'k-','HandleVisibility','off');
plot(cpTimeB,cpDataB,'ko','DisplayName','B - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

%% ARIMA Estimation R
%
[beastmodel_R5,Day5AllR,Day5DataR] = beast_date(transition_data_imputed,'R_Frequency',[5 7],1440/2);

%%
Mdl = arima('Seasonality',1440);
y=Day5DataR(1:end-1440);
l = size(Day5DataR(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataR(1:end-1440));
[yF,yMSE] = forecast(EstMdl,l(1),y);

upper = yF + sqrt(yMSE);
lower = yF - sqrt(yMSE);
fh = Day5AllR.Time(end-1440+1:end);
fh = datetime(fh);

figure
plot(datetime(Day5AllR.Time),Day5DataR,'.','Color',[.75,.75,.75])
hold on
h1 = plot(fh,yF,'r*','LineWidth',2);
h2 = plot(fh,upper,'k.','LineWidth',1.5);
plot(fh,lower,'k.','LineWidth',1.5)
xlim([datetime(Day5AllR.Time(1)) fh(end)])
title('Forecast and 95% Forecast Interval')
legend([h1 h2],'Forecast','95% Interval','Location','NorthWest')
hold off

%% Find the real change point of the observed date R
timestep = 30;
[realmodel,alltheday,daydataexp,reproduceinfo] = beast_date(transition_data_imputed,'R_Frequency',[7 7],60);

%[cpReal1,cpReal2] = takeCP(realmodel); cpReal = [cpReal1(:,1);cpReal2(:,1)]; cpReal = unique(cpReal); cpTimeReal = fh(cpReal); cpDataReal = daydataexp(cpReal);
[cpReal,cpTimeReal,cpDataReal] = mergeCP(timestep,realmodel,alltheday,daydataexp,0,0);

% model build for the predicted data
predmodel = beast(yF,'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);
%
%[cpPred1,cpPred2] = takeCP(predmodel); cpPred = [cpPred1(:,1);cpPred2(:,1)]; cpPred = unique(cpPred); cpTimePred = fh(cpPred); cpDataPred = daydataexp(cpPred);
[cpPred,cpTimePred,cpDataPred] = mergeCP(timestep,predmodel,fh,yF,1,1);
%
figure; 
subplot(2,1,1); hold on;
plot(datetime(table2array(alltheday(:,'Time'))),daydataexp,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(cpTimeReal,'k-','HandleVisibility','off');
plot(cpTimeReal,cpDataReal,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

subplot(2,1,2); hold on;
plot(fh,yF,'.',"Color","blue",'DisplayName','R-freq Ovetime');
xline(cpTimePred,'k-','HandleVisibility','off');
plot(cpTimePred,cpDataPred,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

%% ARIMA Estimation Y
%
[Day5DataY,Day5AllY] = getFreq(transition_data_imputed,'Y_Frequency',567+(5+1-2)*1440-1,567+(7+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

%% Estimation
Mdl = arima('Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
[yF,yMSE] = forecast(EstMdl,l(1),y);

upper = yF + sqrt(yMSE);
lower = yF - sqrt(yMSE);
fh = Day5AllY.Time(end-1440+1:end);
fh = datetime(fh);

%% CPD operation to reduce the error
%empty = [(1:size(Day5DataY(end-1440+1:end)))',(1:size(Day5DataY(end-1440+1:end)))'];
%data = empty;
%estimations = empty;

%data(:,2) = Day5DataY(1:1440);
%estimations(:,2) = yF;

%[data,muD,sigmaD] = mynormalize(data);
%[estimations,muE,sigmaE] = mynormalize(estimations);

%opt.method='affine'; % use affine registration
%opt.viz=1;          % show every iteration
%opt.outliers=0.1;   % use 0.5 noise weight

%opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
%opt.scale=1;        % estimate global scaling too (default)
%opt.rot=1;          % estimate strictly rotational matrix (default)
%opt.corresp=1;      % do not compute the correspondence vector at the end of registration (default). Can be quite slow for large data sets.

%opt.max_it=100;     % max number of iterations
%opt.tol=1e-10;       % tolerance
%opt.fgt=0; %% Fast Gauss transform (FGT) of this CPD algorithm is bugged

% registering 2nd to 1st
%processed=cpd_register(data,estimations,opt);
%yF = mydenormalize(processed.Y,muD,sigmaD);
%yF = yF(:,2);

%%
figure
plot(datetime(Day5AllY.Time),Day5DataY,'.','Color',[.75,.75,.75])
hold on
h1 = plot(fh,yF,'r*','LineWidth',2);
h2 = plot(fh,upper,'k.','LineWidth',1.5);
plot(fh,lower,'k.','LineWidth',1.5)
xlim([datetime(Day5AllY.Time(1)) fh(end)])
title('Forecast and 95% Forecast Interval')
legend([h1 h2],'Forecast','95% Interval','Location','NorthWest')
hold off

%% Find the real change point of the observed date Y
timestep = 30;
[realmodel,alltheday,daydataexp,reproduceinfo] = beast_date(transition_data_imputed,'Y_Frequency',[7 7],60);

%[cpReal1,cpReal2] = takeCP(realmodel); cpReal = [cpReal1(:,1);cpReal2(:,1)]; cpReal = unique(cpReal); cpTimeReal = fh(cpReal); cpDataReal = daydataexp(cpReal);
[cpReal,cpTimeReal,cpDataReal] = mergeCP(timestep,realmodel,alltheday,daydataexp,0,0);

% model build for the predicted data
predmodel = beast(yF,'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);
%
%[cpPred1,cpPred2] = takeCP(predmodel); cpPred = [cpPred1(:,1);cpPred2(:,1)]; cpPred = unique(cpPred); cpTimePred = fh(cpPred); cpDataPred = daydataexp(cpPred);
[cpPred,cpTimePred,cpDataPred] = mergeCP(timestep,predmodel,fh,yF,1,0);
%
figure; 
subplot(2,1,1); hold on;
plot(datetime(table2array(alltheday(:,'Time'))),daydataexp,'.',"Color","red",'DisplayName','Y-freq Ovetime');
xline(cpTimeReal,'k-','HandleVisibility','off');
plot(cpTimeReal,cpDataReal,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

subplot(2,1,2); hold on;
plot(fh,yF,'.',"Color","blue",'DisplayName','R-freq Ovetime');
xline(cpTimePred,'k-','HandleVisibility','off');
plot(cpTimePred,cpDataPred,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

%% ARIMA Estimation Y
%
[Day5DataY,Day5AllY] = getFreq(transition_data_imputed,'Y_Frequency',567+(2+1-2)*1440-1,567+(7+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

%% Estimation
Mdl = arima('Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
[yF,yMSE] = forecast(EstMdl,l(1),y);

upper = yF + sqrt(yMSE);
lower = yF - sqrt(yMSE);
fh = Day5AllY.Time(end-1440+1:end);
fh = datetime(fh);

%%
figure
plot(datetime(Day5AllY.Time),Day5DataY,'.','Color',[.75,.75,.75])
hold on
h1 = plot(fh,yF,'r*','LineWidth',2);
h2 = plot(fh,upper,'k.','LineWidth',1.5);
plot(fh,lower,'k.','LineWidth',1.5)
xlim([datetime(Day5AllY.Time(1)) fh(end)])
title('Forecast and 95% Forecast Interval')
legend([h1 h2],'Forecast','95% Interval','Location','NorthWest')
hold off

%% Find the real change point of the observed date Y
timestep = 30;
reproduceinfo = [60,4,4];
%[realmodel,alltheday,daydataexp,reproduceinfo]

realmodel = beast(Day5AllY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

%[cpReal1,cpReal2] = takeCP(realmodel); cpReal = [cpReal1(:,1);cpReal2(:,1)]; cpReal = unique(cpReal); cpTimeReal = fh(cpReal); cpDataReal = daydataexp(cpReal);
%[cpReal,cpTimeReal,cpDataReal] = mergeCP(timestep,realmodel,alltheday,daydataexp,0,0);

% model build for the predicted data
predmodel = beast(yF,'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.mreproduceinfoinmax',[0,(3)]);
%
%[cpPred1,cpPred2] = takeCP(predmodel); cpPred = [cpPred1(:,1);cpPred2(:,1)]; cpPred = unique(cpPred); cpTimePred = fh(cpPred); cpDataPred = daydataexp(cpPred);
%[cpPred,cpTimePred,cpDataPred] = mergeCP(timestep,predmodel,fh,yF,1,0);
%
figure; 
subplot(2,1,1); hold on;
plot(datetime(table2array(alltheday(:,'Time'))),daydataexp,'.',"Color","red",'DisplayName','Y-freq Ovetime');
xline(cpTimeReal,'k-','HandleVisibility','off');
plot(cpTimeReal,cpDataReal,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

subplot(2,1,2); hold on;
plot(fh,yF,'.',"Color","blue",'DisplayName','R-freq Ovetime');
xline(cpTimePred,'k-','HandleVisibility','off');
plot(cpTimePred,cpDataPred,'ko','DisplayName','R - CP Merged 3 Hour interval'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off
