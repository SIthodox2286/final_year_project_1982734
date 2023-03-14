%% Import data from text file
clear baseline_data_unprocessed
clear transition_data_unprocessed
import_baseline_data_script
import_transition_data_script
%%
baseline_r_frequencies = baseline_data_unprocessed.R_Frequency;
baseline_y_frequencies = baseline_data_unprocessed.Y_Frequency;
baseline_b_frequencies = baseline_data_unprocessed.B_Frequency;

transition_r_frequencies = transition_data_unprocessed.R_Frequency;
transition_y_frequencies = transition_data_unprocessed.Y_Frequency;
transition_b_frequencies = transition_data_unprocessed.B_Frequency;

transition_r_frequencies(find(transition_r_frequencies==0))=nan;
transition_y_frequencies(find(transition_y_frequencies==0))=nan;
transition_b_frequencies(find(transition_b_frequencies==0))=nan;

time_baseline = datetime(baseline_data_unprocessed.Time);
time_transition = datetime(transition_data_unprocessed.Time);

figure;
subplot(3,1,1);
plot(time_baseline,baseline_r_frequencies,'.')
legend('Utility Frequency at R');
subplot(3,1,2);
plot(time_baseline,baseline_y_frequencies,'.')
legend('Utility Frequency at Y');
subplot(3,1,3);
plot(time_baseline,baseline_b_frequencies,'.')
legend('Utility Frequency at B');

figure;
subplot(3,1,1);
plot(time_transition,transition_r_frequencies,'.')
legend('Utility Frequency at R');
subplot(3,1,2);
plot(time_transition,transition_y_frequencies,'.')
legend('Utility Frequency at Y');
subplot(3,1,3);
plot(time_transition,transition_b_frequencies,'.')
legend('Utility Frequency at B');

%% Data preparation for knn imputer

% name of the data columns
baseline_name = baseline_data_unprocessed.Properties.VariableNames;
transition_name = transition_data_unprocessed.Properties.VariableNames;

% Remove string of time data and the record, which are two variables free
% from imputation.
baseline_data = table2array(baseline_data_unprocessed(:,...
    baseline_name(3:end)));
transition_data = table2array(transition_data_unprocessed(:,...
    transition_name(4:end)));

%% Imputation - Knn imputer
dist1 = 'seuclidean';
dist2 = 'mahalanobis';
baseline_data_k80 = knnimpute(baseline_data,5,'Distance',dist1);
baseline_data_k161 = knnimpute(baseline_data,5,'Distance',dist2);
transition_data = knnimpute(transition_data,5,'Distance',dist2);

%% plot the imputed data along with the original
date = table2array(baseline_data_unprocessed(:,'Time'));
R_Frequency_old = table2array(baseline_data_unprocessed(:,'R_Frequency'));
R_Frequency_new_k80 = baseline_data_k80(:,6);
R_Frequency_new_k160 = baseline_data_k80(:,6);



figure;
subplot(3,1,1);
plot(date,R_Frequency_old,'r.');
subtitle('Unimputed R Frequency Overtime');

subplot(3,1,2);
plot(date,R_Frequency_new_k80,'r.');
subtitle('Imputed R Frequency Overtime with k-value = 80');

subplot(3,1,3);
plot(date,R_Frequency_new_k160,'r.');
subtitle('Imputed R Frequency Overtime with k-value = 161');
%%
R_Frequency_new_k80 = transition_data(:,6);
save R_Frequency_new_k80

%% Ouput data imputed - Baseline
baseline_data_table = array2table(baseline_data,...
    'VariableNames',baseline_name(3:end));

date_table = baseline_data_unprocessed(:,'Time');
record_table = baseline_data_unprocessed(:,'RECORD');

% merge time and record back
baseline_data_table = addvars(baseline_data_table,record_table, ...
    'Before',"R_Real_Power_Avg");
baseline_data_table.record_table = table2array( ...
    baseline_data_table.record_table);

baseline_data_table = addvars(baseline_data_table,date_table, ...
    'Before',"record_table");
baseline_data_table.date_table = table2array( ...
    baseline_data_table.date_table);

baseline_data_table = renamevars(baseline_data_table, ...
    ["date_table","record_table"], ...
                 ["Time","RECORD"]);

warning('off','MATLAB:xlswrite:AddSheet'); 
writetable(baseline_data_table,['DataProcessed' ...
    '\baseline_data_imputed_knn.xlsx'],'Sheet',1);


