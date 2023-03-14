function [cpMerged,cpTime,cpData] = mergeCP(timestep,beastmodel,DayAllData,DayData,datetimeinput,plotSwitch)
    %% Extract index of change points out from the model
    [points_season_R,points_trend_R] = takeCP(beastmodel,0);
    CP = [points_season_R;points_trend_R];
    CP = unique(sort(CP(:,1)));
    % Select CP time and data values by matching the CP index
    try 
        isempty(datetimeinput)
    catch 
        datetimeinput = 0;
    end

    try 
        isempty(plotSwitch)
    catch
        plotSwitch = 0;
    end

    if datetimeinput == 1
        length_m_R=DayAllData;
    else
        length_m_R = DayAllData(:,'Time');
        length_m_R = table2array(length_m_R);
        length_m_R = datetime(length_m_R);
    end

    %% Merge datapoints that close enough
    
    if timestep < 1
        timestep = 1;
    end
    
    listCP = CP;
    prev = -1;
    
    % remember that the index are effectively minuets, so they can be
    % directly corresponds to timestep in length of minuets
    for i = 1:length(listCP)
        this = listCP(i);
        if this~=prev % If they are different points
            endPoint = this+timestep; % what time would be a (timestep) away from current point

            % one way to remove those points that are not far enough
            listCP(find(listCP(i+1:end)<endPoint)+i)=this;

            % keep record
            prev = this;
        else
            % If we have already removed this point, then no process is
            % needed.
            prev = this;
        end
    end
    
    CP = unique(listCP);
    
    % Trend and Seasonal change points distinguishing
    %sCp = beastmodel.season.cp;
    %sCpPr = beastmodel.season.cpPr;
    %sCp = sCp(ismember(sCp,CP));
    %sCpPr = sCpPr(ismember(sCp,CP));
    
    %tCp = beastmodel.trend.cp;
    %tCpPr = beastmodel.trend.cpPr;
    %tCp = tCp(ismember(tCp,CP));
    %tCpPr = tCpPr(ismember(tCp,CP));

%% Eliminate those changepoints that are not abrupt enough
    % take range of +- Standard Deviation
    
    lowlimit = prctile(DayData,25);
   % uplimit = prctile(DayData,.99);
    % select points that are within the range
    if plotSwitch==1
        figure; hold on;
        
        %plot(CP,DayData(CP),'ro')
        yline(lowlimit,'m--');
     %   yline(uplimit,'y--');
    end
    keptpoints = [];
    for i = 1:length(CP)-1
        point1 = CP(i);
        point2 = CP(i+1);
        
        temp = DayData(point1:point2);
        x = point1:point2;

        if plotSwitch==1
            plot(x,temp,'.')
        end
        if min(temp)<=lowlimit
            % do nothing, keep the point
            if plotSwitch==1
                plot(point1,DayData(point1),'ro')
            end
            keptpoints(end+1)=point1;
        else
            if plotSwitch==1
                plot(point2,DayData(point2),'bo')
            end
            CP(i) = CP(i+1);
        end
    end
    if plotSwitch==1
        hold off
    end

    cpTime = length_m_R(keptpoints(:));
    cpData = DayData(keptpoints(:));
    cpMerged = unique(keptpoints);
end

