%% Import data from text file
clear baseline_data_unprocessed
clear transition_data_unprocessed
import_baseline_data_script
import_transition_data_script

%% RF imputation of Baseline data
%% RF imputation preparation - Baseline
dataToImpute = baseline_data_unprocessed(:, ...
    setdiff(baseline_data_unprocessed.Properties.VariableNames,...
    {'Time','RECORD'},'stable'));
rfImputedData = baseline_data_unprocessed;

baseline_name = baseline_data_unprocessed.Properties.VariableNames;

tmp = templateTree('Surrogate','on','Reproducible',true);

%% RF imputation of R_frequency

missing_R_frequency = ismissing(dataToImpute.R_Frequency);

% Fit ensemble of regression learners
rf_Rfrequency = fitrensemble(dataToImpute,'R_Frequency','Method','Bag',...
    'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
    baseline_name( ...
    find(~contains(baseline_name,{'Time','RECORD','R_Frequency'}))));
rfImputedData.R_Frequency(missing_R_frequency) = predict(rf_Rfrequency,...
    dataToImpute(missing_R_frequency,:));

%% RF imputation of Y_frequency
missing_Y_frequency = ismissing(dataToImpute.Y_Frequency);
% Fit ensemble of classification learners
rf_Yfrequency = fitcensemble(dataToImpute,'Y_Frequency','Method','Bag',...
    'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
    baseline_name(find(~contains( ...
    baseline_name,{'Time','RECORD','R_Frequency','Y_Frequency'}))));
rfImputedData.Y_Frequency(missing_Y_frequency) = predict(rf_Yfrequency,...
    dataToImpute(missing_Y_frequency,:));

%% RF imputation of B_frequency
missing_B_frequency = ismissing(dataToImpute.B_Frequency);
% Fit ensemble of classification learners
rf_Bfrequency = fitcensemble(dataToImpute,'B_Frequency','Method','Bag',...
    'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
    baseline_name(find(~contains( ...
    baseline_name,{'Time','RECORD','R_Frequency','Y_Frequency', ...
    'B_Frequency'}))));
rfImputedData.B_Frequency(missing_B_frequency) = predict(rf_Bfrequency,...
    dataToImpute(missing_B_frequency,:));

%% write baseline content to file in a folder
Baselinedata_imputed = rfImputedData;
baseline_filepath =...
    ['D:\Users\ediso\Desktop\Technical Projects' ...
    '\MatlabProcessing\DataProcessed\Baseline_data_imputed_rf.xlsx'];
writetable(Baselinedata_imputed,baseline_filepath,'Sheet',1);

%% Plot results
R_Frequency_imputed = rfImputedData(:,'R_Frequency');
R_Frequency_imputed = table2array(R_Frequency_imputed);
Time = baseline_data_unprocessed(:,'Time');
date = table2array(Time);

R_Frequency_old = table2array(baseline_data_unprocessed(:,'R_Frequency'));

figure;
subplot(2,1,1);
plot(date,R_Frequency_old,'r.');
subtitle('Unimputed R Frequency Overtime');

subplot(2,1,2);
plot(date,R_Frequency_imputed,'b.');
subtitle('Imputed R Frequency Overtime with RF(5 learning cycles)');

