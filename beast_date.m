function [beastmodel,dataAlldays,analysisData,reproduceinfo] = beast_date(dataTable,FrequencyName,TimeLimits,frequency)
    %% Introduction
    % This function is used to analysis the Microgrid frequency dataset
    % provided by MECS-TRIID Project Report (public version). Using in
    % occations otherwise may not be compatible. 
    %% Main
    lower = TimeLimits(1);
    upper = TimeLimits(2);

    if abs(upper-lower) > 34
        msg = 'The Maximum Length of dates available is 34, now your are inputing %.2f';
        error(msg,Length)
    elseif upper >= 35
        msg = 'The Maximum date available is the 34th day of the record, now your are inputing %.2f';
        error(msg,Length)
    elseif lower <= 1
        msg = 'The Maximum date available is the 2nd day of the record, now your are inputing %.2f';
        error(msg,Length)
    elseif abs(upper-lower) > 30
        msg = 'You are inputing a time span larger than 30, which is %.2f, which would heavily influence the performance and may crush your MATLAB.';
        error(msg,Length)
    end
    
    if (TimeLimits(2) - TimeLimits(1)) > 0
        dataAlldays = dataTable(dataTable.Sheet<=upper,{FrequencyName,'Sheet','Time'});
        dataAlldays = dataAlldays(dataAlldays.Sheet>=lower,:);
        analysisData = table2array(dataAlldays(:,FrequencyName));
        Length = (upper-lower)*2*2; % For two dips per day and two CP per dip
    elseif (TimeLimits(2) - TimeLimits(1)) < 0
        upper = TimeLimits(1);
        lower = TimeLimits(2);
        dataAlldays = dataTable(dataTable.Sheet<=upper,{FrequencyName,'Sheet','Time'});
        dataAlldays = dataAlldays(dataAlldays.Sheet>=lower,:);
        analysisData = table2array(dataAlldays(:,FrequencyName));
        Length = upper-lower;
        Length = Length*4; % For two dips per day and two CP per dip
    else
        dataAlldays = dataTable(dataTable.Sheet==upper,{FrequencyName,'Sheet','Time'});
        analysisData = table2array(dataAlldays(:,FrequencyName));
        Length = 4; % For two dips per day and two CP per dip
    end
    
    %% BEAST model auto optimization
    scpmax = Length^2
    tcpmax = Length^2
    beastmodel = beast(analysisData,'freq',frequency,'scp.minmax',[0,scpmax], ...
        'tcp.minmax',[0,tcpmax]);

    reproduceinfo = [frequency,scpmax,tcpmax];
   
end

