%% Import data from text file
clear transition_data_imputed
import_transition_data_imputed

rng('default');
%% Obtain Time
date = transition_data_imputed(:,'Time');
Time = table2array(date); % 

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

%% attempt of modelling the future
%% Take 10 days of data
start = 14;
R_frequency_20_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'R_Frequency','Sheet','Time'});
R_frequency_20_day_all = R_frequency_20_day_all(R_frequency_20_day_all.Sheet>=start,:);


%% Train-test Split
day=30;
dataTrain = R_frequency_20_day_all(R_frequency_20_day_all.Sheet<day,:);
timeTrain = datetime(dataTrain{:,'Time'});
dataTrain = table2array(dataTrain(:,'R_Frequency'));
dataTest = R_frequency_20_day_all(R_frequency_20_day_all.Sheet>=day,:);
timeTest = datetime(dataTest{:,'Time'});
dataTest = table2array(dataTest(:,'R_Frequency'));
predictedDays = 34-day;
length = 34-start;
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
text = sprintf('Test Data Vs. Predictions - %d days',predictedDays);
title(text)
hold off
predictMse = mse(dataTest,predictions);

correlation = corrcoef(dataTest,predictions);
display(correlation(2)^2)

figure;
fh = timeTest;
plot(timeTrain,dataTrain,'.')
hold on
h1=plot(fh,dataTest,'ko','LineWidth',1);
h2=plot(fh,predictions,'r.','LineWidth',0.1);
xlim([timeTrain(1) timeTest(end)])
text = sprintf('Full Timeseries - %d days',length);
title(text)
legend([h1 h2],'Test Data','Predictions','Location','NorthWest')
hold off
%%
