%% Import transition dataset
clear transition_data_unprocessed
import_transition_data_script
rng('default')
%% Get sheet count
sheets = transition_data_unprocessed(:,'Sheet');
sheets = table2array(sheets);
sheets = unique(sheets);
imputed_data = transition_data_unprocessed;

%% Loop for imputation
for i = 1:sheets(end)
    data = transition_data_unprocessed(transition_data_unprocessed.Sheet == i,:);
    sprintf('Imputating Sheet %d',i)
    imputation = rf_imputation_frequency_database(data);
    imputed_data(transition_data_unprocessed.Sheet == i,:)=imputation(:,:);
end

imputed_data.Time = sortrows(transition_data_unprocessed(:,'Time'));
%%

%% Plot

R_Frequency_imputed = imputed_data(:,'R_Frequency');
R_Frequency_imputed = table2array(R_Frequency_imputed);
Time = transition_data_unprocessed(:,'Time');
date = table2array(Time);
sequence = 1:size(R_Frequency_imputed);

R_Frequency_old = table2array(transition_data_unprocessed(:,'R_Frequency'));

figure;

subplot(2,1,1);
plot(date,R_Frequency_old,'r.');
subtitle('Unimputed R Frequency Overtime (in Dates)');

subplot(2,1,2);
plot(date,R_Frequency_imputed,'b.');
subtitle('Imputed R Frequency Overtime with RF(5 learning cycles) (in Dates)');

title('Plot of datapoints in Real time')

figure;

subplot(2,1,1);
plot(sequence,R_Frequency_old,'g.');
subtitle('Unimputed R Frequency Overtime (Sequence)');

subplot(2,1,2);
plot(sequence,R_Frequency_imputed,'m.');
subtitle('Imputed R Frequency Overtime with RF(5 learning cycles) (Sequence)');


%% write transition content to file in a folder
Transitiondata_imputed = imputed_data;
transition_filepath =...
    ['D:\Users\ediso\Desktop\Technical Projects' ...
    '\MatlabProcessing\DataProcessed\Transition_data_imputed_rf.xlsx'];
writetable(Transitiondata_imputed,transition_filepath,'Sheet',1);

