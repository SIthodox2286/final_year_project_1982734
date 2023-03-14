%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\DataProcessed\Baseline_data_gapped.csv
%
% Auto-generated by MATLAB on 31/01/2023 14:20:28

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 52);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Time", "RECORD", "R_Real_Power_Avg", "R_RP", "R_Real_Power_kW", "R_Power_VI_PF_kW", "R_Power_VI_kW", "R_Frequency", "R_Voltage_Avg", "R_Voltage", "R_Amperage_Avg", "R_Amperage", "R_Power_Factor", "Y_Power_Avg", "Y_RP", "Y_Real_Power_kW", "Y_Power_VI_PF_kW", "Y_Power_VI_kW", "Y_Frequency", "Y_Voltage_Avg", "Y_Voltage", "Y_Amperage_Avg", "Y_Amperage", "Y_Power_Factor", "B_Real_Power_Avg", "B_RP", "B_Real_Power_kW", "B_Power_VI_PF_kW", "B_Power_VI_kW", "B_Frequency", "B_Voltage_Avg", "B_Voltage", "B_Amperage_Avg", "B_Amperage", "B_Power_Factor", "gen_cur_R_Avg", "Gen_Cur_R", "gen_cur_y_Avg", "Gen_Cur_Y", "gen_cur_B_Avg", "Gen_Cur_B", "BattV_Avg", "R_Gen_VIPF_kW", "R_Gen_VI_kW", "Y_Gen_VIPF_kW", "Y_Gen_VI_kW", "B_Gen_VIPF_kW", "B_Gen_VI_kW", "Load_VIPF_kW", "Load_VI_kW", "Total_Gen_VIPF_kW", "Total_Gen_VI_kW"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Time", "InputFormat", "dd/MM/yyyy HH:mm");

% Import the data
baseline_gapped = readtable("D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\DataProcessed\Baseline_data_gapped.csv", opts);


%% Clear temporary variables
clear opts