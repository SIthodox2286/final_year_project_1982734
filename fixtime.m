%% Import data from text file
clear transition_data_imputed
import_transition_data_imputed

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

record = transition_data_imputed(:,'RECORD');
record = table2array(record);

clear unprocessed
clear processed
clear date1
clear date2
clear date3

%%
transition_data_imputed.Time = Time;
transition_data_imputed.Time = table2array(transition_data_imputed.Time);
warning('off','MATLAB:xlswrite:AddSheet'); 
writetable(transition_data_imputed,['DataProcessed' ...
    '\Transition_data_imputed_rf.xlsx'],'Sheet',1);