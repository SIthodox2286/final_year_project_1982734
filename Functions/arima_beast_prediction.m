function [timeSpan,beastResults_pred,beastResults_test] = arima_beast_prediction(dataset,day1end,timepoints_of_continous_sequece_of_points,Frequency_name,beastparameters)
%% Intro
% This function gives a model to predict future abrupt change in the
% Nepal's rural hydro-power minigrids frequency data. Which are given for
% three locations R, Y and B in timeseries format.

% To use, you should first impute the R, Y and B data set. Then gives the
% above variables as how they are named.

% One should notice the "Day1end" variable can only be the end timepoint for 
% the day 1 in the frequency timeseries. For example, in Basline Period
% of the dataset, the first day end at time point 567, with only 567
% readings collected for the day. Thus, day1end = 567 if any of the
% baseline R, Y and B frequency timeseries are given.

%% Data Preparation
    if Frequency_name(1) == 'R'
        display(day1end+(timepoints_of_continous_sequece_of_points(1)+1-2)*1440)
        timeseries = dataset.R_Frequency(day1end+(timepoints_of_continous_sequece_of_points(1)+1-2)*1440:day1end+(timepoints_of_continous_sequece_of_points(2)+1+1-2)*1440-1);
    elseif Frequency_name(1) == 'Y'
        timeseries = dataset.Y_Frequency(day1end+(timepoints_of_continous_sequece_of_points(1)+1-2)*1440:day1end+(timepoints_of_continous_sequece_of_points(2)+1+1-2)*1440-1);
    elseif Frequency_name(1)=='B'
        timeseries = dataset.B_Frequency(day1end+(timepoints_of_continous_sequece_of_points(1)+1-2)*1440:day1end+(timepoints_of_continous_sequece_of_points(2)+1+1-2)*1440-1);
    %else
    %    error('Correct your frequency names.');
    end
    
    infmt = 'dd/MM/yyyy HH:mm:ss.sss';
    timeSpan = dataset.Time(day1end+(timepoints_of_continous_sequece_of_points(1)+1-2)*1440:day1end+(timepoints_of_continous_sequece_of_points(2)+1+1-2)*1440-1);
    timeSpan = datetime(timeSpan,'InputFormat',infmt);
    
    %% Arima Predictions
    training_data = timeseries(1:end-1440);
    test_data = timeseries(end-1440+1:end);
    prediction_range = size(test_data);
    prediction_range = prediction_range(1);

    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    EstMdl = estimate(Mdl,training_data);
    [predictions,predMse] = forecast(EstMdl,prediction_range,training_data);

    %% BEAST analysis
    timestep = beastparameters(1);
    tcpAmount = beastparameters(2);
    spcAmount = beastparameters(3);

    beastResults_pred = beast(predictions,'freq',timestep,'scp.minmax',[0,tcpAmount], ...
        'tcp.minmax',[0,spcAmount]);

    beastResults_test = beast(test_data,'freq',timestep,'scp.minmax',[0,tcpAmount], ...
        'tcp.minmax',[0,spcAmount]);
    
end

