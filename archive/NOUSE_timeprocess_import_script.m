%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\DataProcessed\Transition_data_imputed_rf.xlsx
%    Worksheet: Sheet1
%
% Auto-generated by MATLAB on 14-Oct-2022 18:53:23

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "B2:B48946";

% Specify column names and types
opts.VariableNames = "Time";
opts.VariableTypes = "string";

% Specify variable properties
opts = setvaropts(opts, "Time", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Time", "EmptyFieldRule", "auto");

% Import the data
Time = readmatrix("D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\DataProcessed\Transition_data_imputed_rf.xlsx", opts, "UseExcel", false);


%% Clear temporary variables
clear opts