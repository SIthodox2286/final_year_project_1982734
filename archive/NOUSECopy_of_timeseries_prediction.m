%% Import data from text file
clear transition_data_imputed
import_transition_data_imputed

rng('default');
%% Data Processing - Fix Time data
date = transition_data_imputed(:,'Time');
date = table2array(date);
date1 = date(1:13527);
date1 = datetime(date1);

unprocessed = date(13528:30808);
processed = datetime(unprocessed);
processed.Format = "MM/dd/yyyy HH:mm:ss";
date2 = processed;

date3 = date(30809:end);
date3 = datetime(date3);

Time = array2table([date1;date2;date3]);
transition_data_imputed(:,'Time')=Time;
date=table2array(transition_data_imputed(:,'Time'));
date = datetime(date);

record = transition_data_imputed(:,'RECORD');
record = table2array(record);

clear unprocessed
clear processed
clear date1
clear date2
clear date3

%% Further Data Formulation
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

TT = addvars(freqencies,date, ...
    'Before',"R_Frequency");

T = size(TT,1);

%% ARIMA Test run
Mdl = arima(2,0,1);

preidx = 1:Mdl.P;
estidx = (Mdl.P + 1):T;

% Produce Estimations
EstMdl = estimate(Mdl,TT{estidx,"R_Frequency"},...
    'Y0',TT{preidx,"R_Frequency"},'Display','off');   

% extract values for plot
resid = infer(EstMdl,TT{estidx,"R_Frequency"},...
    'Y0',TT{preidx,"R_Frequency"});

yhat = TT{estidx,"R_Frequency"} - resid;

% Correlation analysis
correlation = corrcoef(TT{estidx,"R_Frequency"},yhat);
display(correlation)

% Plots
figure;
plot(datetime(TT.date(estidx)),TT{estidx,"R_Frequency"},'.'); hold on
plot(datetime(TT.date(estidx)),yhat,'.','LineWidth',2); 
hold off;
legend('Data','Estimations','Location','southwest')
title('ARIMA Estimation of the transition R frequencies')

figure;
plot(yhat,resid,'.')
ylabel('Residuals')
xlabel('Fitted values')

%% attempt of modelling the future
%% Take 10 days of data
R_frequency_10_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'R_Frequency','Sheet','Time'});
R_frequency_10_day_all = R_frequency_10_day_all(R_frequency_10_day_all.Sheet>23,:);


%% Train-test Split
dataTrain = R_frequency_10_day_all(R_frequency_10_day_all.Sheet~=34,:);
timeTrain = datetime(dataTrain{:,'Time'});
dataTrain = table2array(dataTrain(:,'R_Frequency'));
dataTest = R_frequency_10_day_all(R_frequency_10_day_all.Sheet==34,:);
timeTest = datetime(dataTest{:,'Time'});
dataTest = table2array(dataTest(:,'R_Frequency'));

%% AutoRegressive Predictions
[parameters,noise] = aryule(dataTrain,7);
predictions = filter(-parameters(2:end),1,dataTest);
figure;hold on
plot(timeTest,dataTest,'.')
plot(timeTest,predictions,'.')
xlabel('Sample time')
ylabel('Signal value')
legend('Original autoregressive signal','Signal estimate from linear predictor', ...
    'Location','southwest')
hold off
predictMse = mse(dataTest,predictions);

correlation = corrcoef(dataTest,predictions);
display(correlation(2)^2)

figure;
fh = timeTest;
plot(timeTrain,dataTrain,'.')
hold on
h1=plot(fh,dataTest,'.');
h2=plot(fh,predictions,'.');
xlim([timeTrain(1) timeTest(end)])
title('Full Timeseries')
legend([h1 h2],'Test Data','Predictions','Location','NorthWest')
hold off

%% ARIMA Predictions - Not recomanded
%% Model building
Mdl = arima(0,1,2);
EstMdl = estimate(Mdl,dataTrain);

[yF,yMSE] = forecast(EstMdl,1440,dataTrain);
upper = yF + 1.96*sqrt(yMSE);
lower = yF - 1.96*sqrt(yMSE);

%% Plots
fh = timeTest;

figure
plot(timeTrain,dataTrain,'Color',[.75,.75,.75])
hold on
h1 = plot(fh,yF,'r','LineWidth',2);
htrue = plot(fh,dataTest,'g.');
h2 = plot(fh,upper,'k--','LineWidth',1.5);
plot(fh,lower,'k--','LineWidth',1.5)
xlim([timeTrain(1) timeTest(end)])
title('Forecast and 95% Forecast Interval')
legend([h1 h2],'Forecast','95% Interval','Location','NorthWest')
hold off
