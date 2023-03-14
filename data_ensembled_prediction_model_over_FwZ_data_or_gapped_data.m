%% Import data from text file
clear
rng default

% set datetime record fromat transition_gapped
datetime.setDefaultFormats('default','dd/MM/yyyy HH:mm:ss')
% set random for repeatablity
rng('default')

import_transition_data_gapped
import_baseline_data_gapped

%% Obtain Time
date = transition_gapped(:,'Time');
Time = table2array(date); % 

%%
plot(Time(568:568+1440),transition_gapped.R_Frequency(568:568+1440),'.')
%% ARIMA Estimation Y
%
[Day5DataY,Day5AllY] = getFreq(transition_gapped,'Y_Frequency',568+(12+1-2)*1440,568+(15+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

% Estimation
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
[yF,yMSE] = forecast(EstMdl,l(1),y);

upper = yF + sqrt(yMSE);
lower = yF - sqrt(yMSE);
fh = Day5AllY.Time(end-1440+1:end);
fh = datetime(fh);

%%
[Day30DataY,Day30AllY] = getFreq(transition_gapped,'Y_Frequency',568+(2+1-2)*1440,568+(34+1-2)*1440-1);
Day30DataY = Day30DataY(:,2);

[Day25DataY,Day25AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day25DataY = Day25DataY(:,2);

[Day20DataY,Day20AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day20DataY = Day20DataY(:,2);

[Day15DataY,Day15AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day15DataY = Day15DataY(:,2);

[Day10DataY,Day10AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day10DataY = Day10DataY(:,2);

[Day5DataY,Day5AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

[Day2DataY,Day2AllY] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataY = Day2DataY(:,2);

%% Estimation 
MSETable = [1,2,3,4,5,6,7];
daycount = [2,5,10,15,20,25,30];
correlation = [1,2,3,4,5,6,7];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

information = [EstMdl,EstMdl];

for i = 1:length(MSETable)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    elseif i ==5
        y=Day20DataY(1:end-1440);
        test=Day20DataY(end-1440+1:end);
        l = size(Day20DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day20DataY(1:end-1440));
    elseif i ==6
        y=Day25DataY(1:end-1440);
        test=Day25DataY(end-1440+1:end);
        l = size(Day25DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day25DataY(1:end-1440));
    else
        y=Day30DataY(1:end-1440);
        test=Day30DataY(end-1440+1:end);
        l = size(Day30DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day30DataY(1:end-1440));
    end
    
    information(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    fh = Day5AllY.Time(end-1440+1:end);
    fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETable(i) = err;
    placeholder = corrcoef(test,yF);
    correlation(i) = placeholder(1,2);
end

%%
%%
[Day30DataY,Day30AllY] = getFreq(transition_gapped,'R_Frequency',568+(2+1-2)*1440,568+(34+1-2)*1440-1);
Day30DataY = Day30DataY(:,2);

[Day25DataY,Day25AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day25DataY = Day25DataY(:,2);

[Day20DataY,Day20AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day20DataY = Day20DataY(:,2);

[Day15DataY,Day15AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day15DataY = Day15DataY(:,2);

[Day10DataY,Day10AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day10DataY = Day10DataY(:,2);

[Day5DataY,Day5AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

[Day2DataY,Day2AllY] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataY = Day2DataY(:,2);

% Estimation 
MSETableR = [1,2,3,4,5,6,7];
daycountR = [2,5,10,15,20,25,30];
correlationR = [1,2,3,4,5,6,7];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

informationR = [EstMdl,EstMdl];

for i = 1:length(MSETableR)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    elseif i ==5
        y=Day20DataY(1:end-1440);
        test=Day20DataY(end-1440+1:end);
        l = size(Day20DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day20DataY(1:end-1440));
    elseif i ==6
        y=Day25DataY(1:end-1440);
        test=Day25DataY(end-1440+1:end);
        l = size(Day25DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day25DataY(1:end-1440));
    else
        y=Day30DataY(1:end-1440);
        test=Day30DataY(end-1440+1:end);
        l = size(Day30DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day30DataY(1:end-1440));
    end
    
    informationR(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    fh = Day5AllY.Time(end-1440+1:end);
    fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETableR(i) = err;
    placeholder = corrcoef(test,yF);
    correlationR(i) = placeholder(1,2);
    display(i)
end

display('mission restart');
display('mission restart');
display('mission restart');
display('mission restart');

[Day30DataY,Day30AllY] = getFreq(transition_gapped,'B_Frequency',568+(2+1-2)*1440,568+(34+1-2)*1440-1);
Day30DataY = Day30DataY(:,2);

[Day25DataY,Day25AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day25DataY = Day25DataY(:,2);

[Day20DataY,Day20AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day20DataY = Day20DataY(:,2);

[Day15DataY,Day15AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day15DataY = Day15DataY(:,2);

[Day10DataY,Day10AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day10DataY = Day10DataY(:,2);

[Day5DataY,Day5AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
Day5DataY = Day5DataY(:,2);

[Day2DataY,Day2AllY] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataY = Day2DataY(:,2);

% Estimation 
MSETableB = [1,2,3,4,5,6,7];
daycountB = [2,5,10,15,20,25,30];
correlationB = [1,2,3,4,5,6,7];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

informationR = [EstMdl,EstMdl];

for i = 1:length(MSETableB)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    elseif i ==5
        y=Day20DataY(1:end-1440);
        test=Day20DataY(end-1440+1:end);
        l = size(Day20DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day20DataY(1:end-1440));
    elseif i ==6
        y=Day25DataY(1:end-1440);
        test=Day25DataY(end-1440+1:end);
        l = size(Day25DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day25DataY(1:end-1440));
    else
        y=Day30DataY(1:end-1440);
        test=Day30DataY(end-1440+1:end);
        l = size(Day30DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day30DataY(1:end-1440));
    end
    
    informationB(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    fh = Day5AllY.Time(end-1440+1:end);
    fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETableB(i) = err;
    placeholder = corrcoef(test,yF);
    correlationB(i) = placeholder(1,2);
    display(i)
end

%%
save('MSETable_Y_transition_gapped.mat','MSETable')
save('correlation_Y_transition_gapped.mat','correlation')
save('information_Y_transition_gapped.mat','information')

save('MSETable_R_transition_gapped.mat','MSETableR')
save('correlation_R_transition_gapped.mat','correlationR')
%save('information_R_transition_gapped.mat','informationR')

save('MSETable_B_transition_gapped.mat','MSETableB')
save('correlation_B_transition_gapped.mat','correlationB')
save('information_B_transition_gapped.mat','informationR')

%%
%% ARIMA Estimation Y BASELINE
%[Day30DataY,Day30AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(2+1-2)*1440,568+(34+1-2)*1440-1);
Day19DataY = baseline_gapped.Y_Frequency(631:631+1440*(18+1-2)-1);

%[Day25DataY,Day25AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day15DataY = baseline_gapped.Y_Frequency(631:631+1440*(17+1-2)-1);

%[Day20DataY,Day20AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day10DataY = baseline_gapped.Y_Frequency(631:631+1440*(12+1-2)-1);

%[Day15DataY,Day15AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day5DataY = baseline_gapped.Y_Frequency(631:631+1440*(7+1-2)-1);

%[Day10DataY,Day10AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day2DataY = baseline_gapped.Y_Frequency(631:631+1440*(4+1-2)-1);

%[Day5DataY,Day5AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
%Day5DataY = Day5DataY(:,2);

%[Day2DataY,Day2AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
%Day2DataY = Day2DataY(:,2);

MSETable_Y_baseline = [1,2,3,4,5];
daycount_baseline = [2,5,10,15,19];
correlation_Y_baseline = [1,2,3,4,5];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

information_Y_baseline = [EstMdl,EstMdl];

for i = 1:length(MSETable_Y_baseline)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    else
        y=Day19DataY(1:end-1440);
        test=Day19DataY(end-1440+1:end);
        l = size(Day19DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day19DataY(1:end-1440));
    end
    
    information_Y_baseline(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    %fh = Day5AllY.Time(end-1440+1:end);
   % fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETable_Y_baseline(i) = err;
    placeholder = corrcoef(test,yF);
    correlation_Y_baseline(i) = placeholder(1,2);
end
MSETable_Y_baseline_gapped=MSETable_Y_baseline;
correlation_Y_baseline_gapped=correlation_Y_baseline;
information_Y_baseline_gapped=information_Y_baseline;

save('MSETable_Y_baseline_gapped.mat','MSETable_Y_baseline_gapped')
save('correlation_Y_baseline_gapped.mat','correlation_Y_baseline_gapped')
save('information_Y_baseline_gapped.mat','information_Y_baseline_gapped')
%%
Day19DataY = baseline_gapped.R_Frequency(631:631+1440*(18+1-2)-1);

%[Day25DataY,Day25AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day15DataY = baseline_gapped.R_Frequency(631:631+1440*(17+1-2)-1);

%[Day20DataY,Day20AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day10DataY = baseline_gapped.R_Frequency(631:631+1440*(12+1-2)-1);

%[Day15DataY,Day15AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day5DataY = baseline_gapped.R_Frequency(631:631+1440*(7+1-2)-1);

%[Day10DataY,Day10AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day2DataY = baseline_gapped.R_Frequency(631:631+1440*(4+1-2)-1);

%[Day5DataY,Day5AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
%Day5DataY = Day5DataY(:,2);

%[Day2DataY,Day2AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
%Day2DataY = Day2DataY(:,2);

MSETable_R_baseline = [1,2,3,4,5];
daycount_baselineR = [2,5,10,15,19];
correlation_R_baseline = [1,2,3,4,5];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

information_R_baseline = [EstMdl,EstMdl];

for i = 1:length(MSETable_R_baseline)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    else
        y=Day19DataY(1:end-1440);
        test=Day19DataY(end-1440+1:end);
        l = size(Day19DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day19DataY(1:end-1440));
    end
    
    information_R_baseline(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    %fh = Day5AllY.Time(end-1440+1:end);
   % fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETable_R_baseline(i) = err;
    placeholder = corrcoef(test,yF);
    correlation_R_baseline(i) = placeholder(1,2);
    display(i)
end
MSETable_R_baseline_gapped=MSETable_R_baseline;
correlation_R_baseline_gapped=correlation_R_baseline;
information_R_baseline_gapped=information_R_baseline;

save('MSETable_R_baseline_gapped.mat','MSETable_R_baseline_gapped')
save('correlation_R_baseline_gapped.mat','correlation_R_baseline_gapped')
save('information_R_baseline_gapped.mat','information_R_baseline_gapped')

display('Mid-Turn Break');
display('Mid-Turn Break');
display('Mid-Turn Break');
display('Mid-Turn Break');

Day19DataY = baseline_gapped.B_Frequency(631:631+1440*(18+1-2)-1);

%[Day25DataY,Day25AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(31+1-2)*1440-1);
Day15DataY = baseline_gapped.B_Frequency(631:631+1440*(17+1-2)-1);

%[Day20DataY,Day20AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(26+1-2)*1440-1);
Day10DataY = baseline_gapped.B_Frequency(631:631+1440*(12+1-2)-1);

%[Day15DataY,Day15AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(21+1-2)*1440-1);
Day5DataY = baseline_gapped.B_Frequency(631:631+1440*(7+1-2)-1);

%[Day10DataY,Day10AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(16+1-2)*1440-1);
Day2DataY = baseline_gapped.B_Frequency(631:631+1440*(4+1-2)-1);

%[Day5DataY,Day5AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(11+1-2)*1440-1);
%Day5DataY = Day5DataY(:,2);

%[Day2DataY,Day2AllY] = getFreq(baseline_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
%Day2DataY = Day2DataY(:,2);

MSETable_B_baseline = [1,2,3,4,5];
daycount_baselineB = [2,5,10,15,19];
correlation_B_baseline = [1,2,3,4,5];

Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
y=Day5DataY(1:end-1440);
l = size(Day5DataY(end-1440+1:end));

EstMdl = estimate(Mdl,Day5DataY(1:end-1440));

information_B_baseline = [EstMdl,EstMdl];

for i = 1:length(MSETable_B_baseline)
    Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
    if i==1
        y=Day2DataY(1:end-1440);
        test=Day2DataY(end-1440+1:end);
        l = size(Day2DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day2DataY(1:end-1440));
    elseif i ==2
        y=Day5DataY(1:end-1440);
        test=Day5DataY(end-1440+1:end);
        l = size(Day5DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day5DataY(1:end-1440));
    elseif i ==3
        y=Day10DataY(1:end-1440);
        test=Day10DataY(end-1440+1:end);
        l = size(Day10DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day10DataY(1:end-1440));
    elseif i ==4
        y=Day15DataY(1:end-1440);
        test=Day15DataY(end-1440+1:end);
        l = size(Day15DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day15DataY(1:end-1440));
    else
        y=Day19DataY(1:end-1440);
        test=Day19DataY(end-1440+1:end);
        l = size(Day19DataY(end-1440+1:end));
        EstMdl = estimate(Mdl,Day19DataY(1:end-1440));
    end
    
    information_B_baseline(i)=EstMdl;

    [yF,yMSE] = forecast(EstMdl,l(1),y);
    
    upper = yF + sqrt(yMSE);
    lower = yF - sqrt(yMSE);
    %fh = Day5AllY.Time(end-1440+1:end);
   % fh = datetime(fh);
    err = immse(test,yF);
    err = err/mean(test);
    MSETable_B_baseline(i) = err;
    placeholder = corrcoef(test,yF);
    correlation_B_baseline(i) = placeholder(1,2);
    display(i)
end
MSETable_B_baseline_gapped=MSETable_B_baseline;
correlation_B_baseline_gapped=correlation_B_baseline;
information_B_baseline_gapped=information_B_baseline;

save('MSETable_B_baseline_gapped.mat','MSETable_B_baseline_gapped')
save('correlation_B_baseline_gapped.mat','correlation_B_baseline_gapped')
save('information_B_baseline_gapped.mat','information_B_baseline_gapped')

%%
figure
plot(datetime(Day5AllY.Time),Day5DataY,'.','Color',[.75,.75,.75])
hold on
h1 = plot(fh,yF,'r.','LineWidth',1);
xlim([datetime(Day5AllY.Time(1)) fh(end)])
%title('Forecast and 95% Forecast Interval')
legend('Data','Forecast')
hold off

%% Find the real change point of the observed date Y
timestep = 60;
reproduceinfo = [timestep,16,16];
alltheday = Day5AllY((end-1440+1:end),:);
daydataexp = Day5AllY.Y_Frequency(end-1440+1:end);

realmodel = beast(Day5AllY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

[cpReal1,cpReal2] = takeCP(realmodel,0.3); 
cpReal = [cpReal1(:,1);cpReal2(:,1)]; 
cpReal = unique(cpReal); 
cpTimeReal = fh(cpReal(:,1)); cpDataReal = daydataexp(cpReal(:,1));
%[cpReal,cpTimeReal,cpDataReal] = mergeCP(timestep,realmodel,alltheday,Day5AllY.Y_Frequency(end-1440+1:end),0,1);

% model build for the predicted data
predmodel = beast(yF,'freq',reproduceinfo(1),'scp.minmax',[0,reproduceinfo(2)], ...
        'tcp.minmax',[0,reproduceinfo(3)]);

% Season CP, Trend CP
[cpPred1,cpPred2] = takeCP(predmodel,0.3); cpPred = [cpPred1(:,1);cpPred2(:,1)]; cpPred = unique(cpPred); cpTimePred = fh(cpPred(:,1)); cpDataPred = yF(cpPred(:,1));
%[cpPred,cpTimePred,cpDataPred] = mergeCP(timestep,predmodel,fh,yF,1,1);
%
figure; 
subplot(2,1,1); hold on;
plot(datetime(Day5AllY.Time(end-1440+1:end)),Day5AllY.Y_Frequency(end-1440+1:end),'.',"Color","red",'DisplayName','Y-freq Ovetime');
xline(cpTimeReal,'k-','HandleVisibility','off');
plot(cpTimeReal,cpDataReal,'ko','DisplayName','Y - CP'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off

subplot(2,1,2); hold on;
plot(fh,yF,'.',"Color","blue",'DisplayName','Y-freq Predicted');
xline(cpTimePred,'k-','HandleVisibility','off');
plot(cpTimePred,cpDataPred,'ko','DisplayName','Y - CP'); hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast'); hold off
%%
figure;
plotbeast(realmodel)
figure
plotbeast(predmodel)

%% Usins ARIMA model with 2-day's historical data to produce the valid predictions for BEAST
%% ARIMA Estimation Y, 2-day
%infmt = 'dd/MM/yyyy HH:mm:ss.sss';

% Extract Transition Data
[day2_R_data_transition,day2_R_data_all] = getFreq(transition_gapped,'R_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
day2_R_data_transition = day2_R_data_transition(:,2);
[day2_Y_data_transition,day2_Y_data_all] = getFreq(transition_gapped,'Y_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
day2_Y_data_transition = day2_Y_data_transition(:,2);
[day2_B_data_transition,day2_B_data_all] = getFreq(transition_gapped,'B_Frequency',568+(5+1-2)*1440,568+(8+1-2)*1440-1);
day2_B_data_transition = day2_B_data_transition(:,2);

% Extract Baseline Data
day2_R_data_baseline = baseline_gapped.R_Frequency(631+1440*(3+1-2)-1:631+1440*(6+1-2)-1);
day2_Y_data_baseline = baseline_gapped.Y_Frequency(631+1440*(3+1-2)-1:631+1440*(6+1-2)-1);
day2_B_data_baseline = baseline_gapped.B_Frequency(631+1440*(3+1-2)-1:631+1440*(6+1-2)-1);


% Estimation R TRANS
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yR1=day2_R_data_transition(1:end-1440);
lR1 = size(day2_R_data_transition(end-1440+1:end));
EstMdlR1 = estimate(Mdl,day2_R_data_transition(1:end-1440));
[yRF1,yRMSE1] = forecast(EstMdlR1,lR1(1),yR1);

% Estimation Y TRANS
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yY1=day2_Y_data_transition(1:end-1440);
lY1 = size(day2_Y_data_transition(end-1440+1:end));
EstMdlY1 = estimate(Mdl,day2_Y_data_transition(1:end-1440));
[yYF1,yYMSE1] = forecast(EstMdlY1,lY1(1),yY1);

% Estimation B TRANS
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yB1=day2_B_data_transition(1:end-1440);
lB1 = size(day2_B_data_transition(end-1440+1:end));
EstMdlB1 = estimate(Mdl,day2_B_data_transition(1:end-1440));
[yBF1,yBMSE1] = forecast(EstMdlB1,lB1(1),yB1);

%
% Estimation R base
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yR2=day2_R_data_baseline(1:end-1440);
lR2 = size(day2_R_data_baseline(end-1440+1:end));

EstMdlR2 = estimate(Mdl,day2_R_data_baseline(1:end-1440));
[yRF2,yRMSE2] = forecast(EstMdlR2,lR2(1),yR2);

% Estimation Y base
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yY2=day2_Y_data_baseline(1:end-1440);
lY2 = size(day2_Y_data_baseline(end-1440+1:end));

EstMdlY2 = estimate(Mdl,day2_Y_data_baseline(1:end-1440));
[yYF2,yYMSE2] = forecast(EstMdlY2,lY2(1),yY2);

% Estimation B base
Mdl = arima('ARLags',1:9,'D',1,'Seasonality',1440);
yB2=day2_B_data_baseline(1:end-1440);
lB2 = size(day2_B_data_baseline(end-1440+1:end));

EstMdlB2 = estimate(Mdl,day2_B_data_baseline(1:end-1440));
[yBF2,yBMSE2] = forecast(EstMdlB2,lB2(1),yB2);



%%
gapped_transition_predicted_R = yRF1;
gapped_transition_predicted_Y = yYF1;
gapped_transition_predicted_B = yBF1;
gapped_baseline_predicted_R = yRF2;
gapped_baseline_predicted_Y = yRF2;
gapped_baseline_predicted_B = yRF2;


save('gapped_transition_predicted_R.mat','gapped_transition_predicted_R')
save('gapped_transition_predicted_Y.mat','gapped_transition_predicted_Y')
save('gapped_transition_predicted_B.mat','gapped_transition_predicted_B')
save('gapped_baseline_predicted_R.mat','gapped_baseline_predicted_R')
save('gapped_baseline_predicted_Y.mat','gapped_baseline_predicted_Y')
save('gapped_baseline_predicted_B.mat','gapped_baseline_predicted_B')

%% Find the real change point of the observed date Y - 60

% prepare time for plot
infmt = 'dd/MM/yyyy HH:mm:ss.sss';
examinetimebaseline = baseline_gapped.Time(631:631+1440*(4+1-2)-1);
examinetimebaseline = datetime(examinetimebaseline,'InputFormat',infmt);
examinetimebaseline = examinetimebaseline(end-1440+1:end);
examinetimetransition = day2_R_data_all.Time(end-1440+1:end);
examinetimetransition = datetime(examinetimetransition,'InputFormat',infmt);
%

%alltheday = Day5AllY((end-1440+1:end),:);
%daydataexp = Day5AllY.Y_Frequency(end-1440+1:end);
%day2_R_data_baseline
%day2_Y_data_baseline
%day2_B_data_baseline
%day2_R_data_all
%day2_R_data_transition
Time = examinetimebaseline;
R_Frequency = gapped_baseline_predicted_R;
allthedayBaseLR = table(R_Frequency,Time);
daydataexpBaseLR = day2_R_data_baseline(end-1440+1:end);
Y_Frequency = gapped_baseline_predicted_Y;
allthedayBaseLY = table(Y_Frequency,Time);
daydataexpBaseLY = day2_Y_data_baseline(end-1440+1:end);
B_Frequency = gapped_baseline_predicted_B;
allthedayBaseLB = table(B_Frequency,Time);
daydataexpBaseLB = day2_B_data_baseline(end-1440+1:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allthedayTranSR = day2_R_data_all((end-1440+1:end),:);
daydataexpTranSR = day2_R_data_all.R_Frequency(end-1440+1:end);
allthedayTranSY = day2_Y_data_all((end-1440+1:end),:);
daydataexpTranSY = day2_Y_data_all.Y_Frequency(end-1440+1:end);
allthedayTranSB = day2_B_data_all((end-1440+1:end),:);
daydataexpTranSB = day2_B_data_all.B_Frequency(end-1440+1:end);

%%%%%%%%%%%% BEAST Modelling
timestep1 = 60;
reproduceinfo1 = [60,9,9];

timestep2 = 1440/4;
reproduceinfo2 = [1440/4,9,9];

timestep3 = 1440/2;
reproduceinfo3 = [1440/2,9,9];

%%%%%%%%%%%%%%%%The real models
% BASELINE
% 60
realmodelBaseLR1 = beast(allthedayBaseLR.R_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
realmodelBaseLY1 = beast(allthedayBaseLY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
realmodelBaseLB1 = beast(allthedayBaseLB.B_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
% 1440/4
realmodelBaseLR2 = beast(allthedayBaseLR.R_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
realmodelBaseLY2 = beast(allthedayBaseLY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
realmodelBaseLB2 = beast(allthedayBaseLB.B_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
% 1440/2
realmodelBaseLR3 = beast(allthedayBaseLR.R_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
realmodelBaseLY3 = beast(allthedayBaseLY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
realmodelBaseLB3 = beast(allthedayBaseLB.B_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
% Transition
% 60
realmodelTranSR1 = beast(allthedayTranSR.R_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
realmodelTranSY1 = beast(allthedayTranSY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
realmodelTranSB1 = beast(allthedayTranSB.B_Frequency(end-1440+1:end),'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
% 1440/4
realmodelTranSR2 = beast(allthedayTranSR.R_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
realmodelTranSY2 = beast(allthedayTranSY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
realmodelTranSB2 = beast(allthedayTranSB.B_Frequency(end-1440+1:end),'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
% 1440/2
realmodelTranSR3 = beast(allthedayTranSR.R_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
realmodelTranSY3 = beast(allthedayTranSY.Y_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
realmodelTranSB3 = beast(allthedayTranSB.B_Frequency(end-1440+1:end),'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);

%%%%%%%%%%%%%%%%The predict models
% BASELINE
% 60
predmodelBaseLR1 = beast(gapped_baseline_predicted_R,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
predmodelBaseLY1 = beast(gapped_baseline_predicted_Y,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
predmodelBaseLB1 = beast(gapped_baseline_predicted_B,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
% 1440/4
predmodelBaseLR2 = beast(gapped_baseline_predicted_R,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
predmodelBaseLY2 = beast(gapped_baseline_predicted_Y,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
predmodelBaseLB2 = beast(gapped_baseline_predicted_B,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
% 1440/2
predmodelBaseLR3 = beast(gapped_baseline_predicted_R,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
predmodelBaseLY3 = beast(gapped_baseline_predicted_Y,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
predmodelBaseLB3 = beast(gapped_baseline_predicted_B,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
% Transition
% 60
predmodelTranSR1 = beast(gapped_transition_predicted_R,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
predmodelTranSY1 = beast(gapped_transition_predicted_Y,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
predmodelTranSB1 = beast(gapped_transition_predicted_B,'freq',reproduceinfo1(1),'scp.minmax',[0,reproduceinfo1(2)], ...
        'tcp.minmax',[0,reproduceinfo1(3)]);
% 1440/4
predmodelTranSR2 = beast(gapped_transition_predicted_R,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
predmodelTranSY2 = beast(gapped_transition_predicted_Y,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
predmodelTranSB2 = beast(gapped_transition_predicted_B,'freq',reproduceinfo2(1),'scp.minmax',[0,reproduceinfo2(2)], ...
        'tcp.minmax',[0,reproduceinfo2(3)]);
% 1440/2
predmodelTranSR3 = beast(gapped_transition_predicted_R,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
predmodelTranSY3 = beast(gapped_transition_predicted_Y,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
predmodelTranSB3 = beast(gapped_transition_predicted_B,'freq',reproduceinfo3(1),'scp.minmax',[0,reproduceinfo3(2)], ...
        'tcp.minmax',[0,reproduceinfo3(3)]);
%% Save the models because processing takes time
save('Predicted_Models_Baseline_with_Gapped_BEAST.mat','predmodelBaseLR1','predmodelBaseLY1', ...
    'predmodelBaseLB1','predmodelBaseLR2','predmodelBaseLY2','predmodelBaseLB2' ...
    ,'predmodelBaseLR3','predmodelBaseLY3','predmodelBaseLB3')

save('Predicted_Models_Transition_with_Gapped_BEAST.mat','predmodelTranSR1','predmodelTranSY1', ...
    'predmodelTranSB1','predmodelTranSR2','predmodelTranSY2','predmodelTranSB2' ...
    ,'predmodelTranSR3','predmodelTranSY3','predmodelTranSB3')

save('Real_Models_Baseline_with_Gapped_BEAST.mat','realmodelBaseLR1','realmodelBaseLY1', ...
    'realmodelBaseLB1','realmodelBaseLR2','realmodelBaseLY2','realmodelBaseLB2' ...
    ,'realmodelBaseLR3','realmodelBaseLY3','realmodelBaseLB3')

save('Real_Models_Transition_with_Gapped_BEAST.mat','realmodelTranSR1','realmodelTranSY1', ...
    'realmodelTranSB1','realmodelTranSR2','realmodelTranSY2','realmodelTranSB2' ...
    ,'realmodelTranSR3','realmodelTranSY3','realmodelTranSB3')
%%
%[cpReal1,cpReal2] = takeCP(realmodel,0); 
%cpReal = [cpReal1(:,1);cpReal2(:,1)]; 
%cpReal = unique(cpReal); cpTimeReal = fh(cpReal); 
%cpDataReal = daydataexp(cpReal);
%[cpReal,cpTimeReal,cpDataReal] = mergeCP(timestep,realmodel,alltheday,Day5AllY.Y_Frequency(end-1440+1:end),0,1);
%%
[tcpTranSR1,scpTranSR1,thresCPTranSR1]=beastCPinfo(predmodelTranSR1, ...
    examinetimetransition,gapped_transition_predicted_R,1,1,reproduceinfo1(1));
[tcpTranSR2,scpTranSR2,thresCPTranSR2]=beastCPinfo(predmodelTranSR2, ...
    examinetimetransition,gapped_transition_predicted_R,1,1,reproduceinfo2(1));
[tcpTranSR3,scpTranSR3,thresCPTranSR3]=beastCPinfo(predmodelTranSR3, ...
    examinetimetransition,gapped_transition_predicted_R,1,1,reproduceinfo3(1));
%%
cpSR1 = [predmodelTranSR1.trend.cp,predmodelTranSR1.season.cp];
cpSR1 = unique(cpSR1);
cpSR1 = cpSR1(~isnan(cpSR1));
cpSR1_Frq = predmodelTranSR1.data(cpSR1);
cpSR1_time = examinetimetransition(cpSR1);

cpSR2 = [tcpTranSR2;scpTranSR2];
cpSR2 = unique(cpSR2);
cpSR2 = cpSR2(~isnan(cpSR2));
cpSR2_Frq = predmodelTranSR2.data(cpSR2);
cpSR2_time = examinetimetransition(cpSR2);

cpSR3 = [tcpTranSR3;scpTranSR3];
cpSR3 = unique(cpSR3);
cpSR3 = cpSR3(~isnan(cpSR3));
cpSR3_Frq = predmodelTranSR3.data(cpSR3);
cpSR3_time = examinetimetransition(cpSR3);

%%
figure;
subplot(3,1,1); hold on;
plot(examinetimetransition,predmodelTranSR1.data,'b.')
xline(cpSR1_time,'r');
legend('Transition R-Frequency Imputed','All CP','Location','southwest')

ylabel('Frequency')
hold off;

subplot(3,1,2);  hold on;
plot(examinetimetransition,predmodelTranSR2.data,'b.')
xline(cpSR2_time,'r');
legend('Transition R-Frequency Imputed','All CP','Location','southwest')

ylabel('Frequency')
hold off;

subplot(3,1,3);  hold on;
plot(examinetimetransition,predmodelTranSR3.data,'b.')
xline(cpSR3_time,'r');
legend('Transition R-Frequency Imputed','All CP','Location','southwest')
xlabel('Date in Transition Period')
ylabel('Frequency')
hold off;

%%
[Day2DataR,Day2AllR] = getFreq(transition_gapped,'R_Frequency',568+(2+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataR = Day2DataR(:,2);

[Day2DataY,Day2AllY] = getFreq(transition_gapped,'Y_Frequency',568+(2+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataY = Day2DataY(:,2);

[Day2DataB,Day2AllB] = getFreq(transition_gapped,'B_Frequency',568+(2+1-2)*1440,568+(8+1-2)*1440-1);
Day2DataB = Day2DataB(:,2);

%2,3=>4, 7,8=>9, 12,13=>14, 17,18=>19, 20,21=>22, 25,26=>27, 28,29=>30;
beastparameters = [60,9,9];

dayset1 = [2,4];
dayset2 = [7,9];
dayset3 = [12,14];
dayset4 = [20,22];
dayset5 = [25,27];
all_sets = [dayset1;dayset2;dayset3;dayset4;dayset5];

dayset1 = [2,4];
dayset2 = [5,7];
dayset3 = [8,10];
dayset4 = [11,13];
dayset5 = [14,16];

all_sets_baseline = [dayset1;dayset2;dayset3;dayset4;dayset5];

[time1,pred1,test1] = arima_beast_prediction(transition_gapped,568,dayset1,'R_frequency',beastparameters);

timeStorage = {time1,time1,time1,time1,time1};
predResults = [pred1,pred1,pred1,pred1,pred1];
testResults = [test1,test1,test1,test1,test1];

predResults_transition_gapped_R = predResults;
predResults_transition_gapped_Y = predResults;
predResults_transition_gapped_B = predResults;

testResults_transition_gapped_R = predResults;
testResults_transition_gapped_Y = predResults;
testResults_transition_gapped_B = predResults;

timeStoredTranS = timeStorage;

transitionDay1EndAt = 537;
baselineDay1EndAt = 631;

for i=1:5
    dayset = all_sets(i,:);
    [timeR,predR,testR] = arima_beast_prediction(transition_gapped,transitionDay1EndAt,dayset,'R_frequency',beastparameters);
    [timeY,predY,testY] = arima_beast_prediction(transition_gapped,transitionDay1EndAt,dayset,'Y_frequency',beastparameters);
    [timeB,predB,testB] = arima_beast_prediction(transition_gapped,transitionDay1EndAt,dayset,'B_frequency',beastparameters);

    timeStoredTranS(i) = {timeR};
    
    predResults_transition_gapped_R(i) = predR;
    predResults_transition_gapped_Y(i) = predY;
    predResults_transition_gapped_B(i) = predB;
    
    testResults_transition_gapped_R(i) = testR;
    testResults_transition_gapped_Y(i) = testY;
    testResults_transition_gapped_B(i) = testB;
end

%% Baseline
predResults_baseline_imputed_R = predResults;
predResults_baseline_imputed_Y = predResults;
predResults_baseline_imputed_B = predResults;

testResults_baseline_imputed_R = predResults;
testResults_baseline_imputed_Y = predResults;
testResults_baseline_imputed_B = predResults;

timeStoredBaseL = timeStorage;

%%
save('ARIMA_BEAST_accuracy_Transition_1.mat','predResults_transition_gapped_R','predResults_transition_gapped_Y', ...
    'predResults_transition_gapped_B','testResults_transition_gapped_R','testResults_transition_gapped_Y', ...
    'testResults_transition_gapped_B','timeStoredTranS')
%%
save('ARIMA_BEAST_accuracy_Baseline_1.mat','predResults_baseline_imputed_R','predResults_baseline_imputed_Y', ...
    'predResults_baseline_imputed_B','testResults_baseline_imputed_R','testResults_baseline_imputed_Y', ...
    'testResults_baseline_imputed_B','timeStoredBaseL')

%% TEST 2
dayset1 = [2,4];
dayset2 = [7,8];
dayset3 = [12,14];
dayset4 = [20,22];
dayset5 = [25,27];
all_sets = [dayset1;dayset2;dayset3;dayset4;dayset5];

import_transition_data_imputed
beastparameters = [60,9,9];

[time1,pred1,test1] = arima_beast_prediction(transition_gapped,568,dayset1,'R_frequency',beastparameters);

timeStorage = {time1,time1,time1,time1,time1};
predResults = [pred1,pred1,pred1,pred1,pred1];
testResults = [test1,test1,test1,test1,test1];

predResults_transition_imputed_R_repeats = predResults;
predResults_transition_gapped_R_repeats = predResults;

timeStoredTranS = timeStorage;

transitionDay1EndAt = 537;

for i=1:20
    [timeR_gap,predR_gap,testR_gap] = arima_beast_prediction(transition_gapped,transitionDay1EndAt,[7,9],'R_frequency',beastparameters);
    [timeR_rfi,predR_rfi,testR_rfi] = arima_beast_prediction(transition_data_imputed,transitionDay1EndAt,[7,9],'R_frequency',beastparameters);


    timeStoredTranS(i) = {timeR_gap};
    
    predResults_transition_imputed_R_repeats(i) = predR_gap;
    predResults_transition_gapped_R_repeats(i) = predR_rfi;
end

save('ARIMA_BEAST_accuracy_Transition_stab_studies.mat','predResults_transition_imputed_R_repeats', ...
    'predResults_transition_gapped_R_repeats');
