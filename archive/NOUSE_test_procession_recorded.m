%% Import data from text file
clear baseline_data_unprocessed
clear transition_data_unprocessed
import_baseline_data_script
import_transition_data_script

%% Data Processing - Simple plot
date = baseline_data_unprocessed(:,'Time');
date = table2array(date);

record = baseline_data_unprocessed(:,'RECORD');
record = table2array(record);

% R_frequency
R1_frequency = baseline_data_unprocessed(:,'R_Frequency');

R1_frequency = table2array(R1_frequency);
R3_frequency = R1_frequency;
R3_frequency(isnan(R3_frequency))=0;
test1_matrix = R1_frequency(~isnan(R1_frequency));
date_1 = date(~isnan(R1_frequency));

% Real Frequency Plot
figure;
plot(date_1,test1_matrix,'b-'); 
title('Unimputed Real Frequency Overtime');

% R_voltage_avg
Y_Frequency = baseline_data_unprocessed(:,'Y_Frequency');

Y_Frequency = table2array(Y_Frequency);
date_2 = date(~isnan(Y_Frequency));
plot_Y_frequency = Y_Frequency(~isnan(Y_Frequency));

% plot with nan
figure;
subplot(2,1,1);
plot(date,Y_Frequency,'r.');
title('Unimputed Y Frequency Overtime');

% plot without nan
subplot(2,1,2);
plot(date_2,plot_Y_frequency,'b.');
title('Unimputed Y Frequency Overtime without NaN');


%% Data Imputation - Application of Imputer 1 - KNN Imputer
baseline_name = baseline_data_unprocessed.Properties.VariableNames;
baseline_data = table2array(baseline_data_unprocessed(:,...
    baseline_name(3:end)));
baseline_data = knnimpute(baseline_data);

transition_name = transition_data_unprocessed.Properties.VariableNames;
transition_data = table2array(transition_data_unprocessed(:,...
    transition_name(4:end)));
transition_data = knnimpute(transition_data);

R2_frequency = baseline_data(:,6);
mins = 1:size(R2_frequency);
test2_matrix = R2_frequency;
mins = mins';
mins = mins(~isnan(test2_matrix));
test2_matrix = test2_matrix(~isnan(test2_matrix));

% Real Frequency Plot
figure;
plot(mins,test2_matrix,'r-'); hold off;
title('Imputed Real Frequency Overtime');
 
%% Ouput data imputed
baseline_data_table = array2table(baseline_data,...
    'VariableNames',baseline_name(3:end));

date_table = baseline_data_unprocessed(:,'Time');
record_table = baseline_data_unprocessed(:,'RECORD');

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

%% Data Imputation - Application of Imputer 3 ?

%% Test Change-Poing Analysis on the Real Data Only
figure
findchangepts(test1_matrix,'Statistic','std', ...
    'MaxNumChanges',20);
title('Standard Deviation Based Change-point Search')
legend('Data','local mean','Change Point')

figure
findchangepts(test1_matrix,'Statistic','mean','MinThreshold',min(test1_matrix))
title('Mean Based Change-point Search')
legend('Data','local mean','Change Point')

figure
findchangepts(test1_matrix,'Statistic','linear',...
    'MaxNumChanges',20);
title('Linear Based Change-point Search')
legend('Data','local mean','Change Point')

%% Test Change-Poing Analysis on the Imputed Data (Linear Trend)

[points1,error1]=findchangepts(R2_frequency,'Statistic','linear' ...
    ,'MinThreshold',max(R2_frequency)-min(R2_frequency));
points1 = [1;points1];
length_th = 1:size(R2_frequency);
changePoingts_th = R2_frequency(points1);
length_p1 = length_th(points1);
vertical_line_1 = length_p1(2:end);

figure; hold on;
plot(length_th,R2_frequency,'b.');
plot(length_p1(2:end),changePoingts_th(2:end),'ro');
plot(length_p1,changePoingts_th,'r');
xline(vertical_line_1,'-',"Color","#77AC30");


hold off;
title('Linear Trend Based Change-point Search With MinThreshold')

%% Test Change-Poing Analysis on the Imputed Data (Mean)

[points_mean,error_mean]=findchangepts(R2_frequency,'Statistic','mean' ...
    ,'MinThreshold',max(R2_frequency)-min(R2_frequency));
points_mean = [1;points_mean];
length_m = 1:size(R2_frequency);
changePoingts_mean = R2_frequency(points_mean);

length_p2 = length_m(points_mean);
vertical_line_2 = length_p2(2:end);

figure; hold on;
plot(length_m,R2_frequency,'b-');
plot(length_p2(2:end),changePoingts_mean(2:end),'ro');
plot(length_p2,changePoingts_mean,'r');
xline(vertical_line_2,'-',"Color","#77AC30");


hold off;
title('Mean Based Change-point Search With MinThreshold')

%% Test usage of Control Charts
plot = controlchart(R2_frequency,'chart','i');

%% Beyansian Change-point test
o = beast(R2_frequency(1:end), 'season','none'); plotbeast(o)
