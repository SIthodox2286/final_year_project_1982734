%% Import data from text file
clear
% set datetime record fromat
datetime.setDefaultFormats('default','dd/MM/yyyy HH:mm:ss')
% set random for repeatablity
rng('default')

import_transition_data_imputed
import_baseline_data_imputed

%% Obtain Time
date = transition_data_imputed(:,'Time');
Time = table2array(date); % 

%% BEAST analysis
[beastmodel_R,Day5AllR,Day5DataR] = beast_date(transition_data_imputed,'R_Frequency',[2 12],1440/2);
[beastmodel_Y,Day5AllY,Day5DataY] = beast_date(transition_data_imputed,'Y_Frequency',[2 12],1440/2);
[beastmodel_B,Day5AllB,Day5DataB] = beast_date(transition_data_imputed,'B_Frequency',[2 12],1440/2);

%% Preparation for plots
[points_season_R,points_trend_R] = takeCP(beastmodel_R);
[points_season_Y,points_trend_Y] = takeCP(beastmodel_Y);
[points_season_B,points_trend_B] = takeCP(beastmodel_B);

%% Regulate Change points - Window Method
%points_season_R = Regulate_CP(Day5DataR,points_season_R,60);
%points_season_Y = Regulate_CP(Day5DataY,points_season_Y,60);
%points_season_B = Regulate_CP(Day5DataB,points_season_B,60);

% Take Date and time information
format long

length_m_R = Day5AllR(:,'Time');
length_m_R = table2array(length_m_R);
length_m_R = datetime(length_m_R);
timeR = Day5AllR(:,'Time');
timeR = table2array(timeR);

length_m_Y = Day5AllY(:,'Time');
length_m_Y = table2array(length_m_Y);
length_m_Y = datetime(length_m_Y);
timeY = Day5AllY(:,'Time');
timeY = table2array(timeY);

length_m_B = Day5AllB(:,'Time');
length_m_B = table2array(length_m_B);
length_m_B = datetime(length_m_B);
timeB = Day5AllB(:,'Time');
timeB = table2array(timeB);

% Occurance Analysis Across Different Timepoints (Seansonal Changes)
seasonal_timepointsR = length_m_R(points_season_R(:,1));
season_datapointsR = Day5DataR(points_season_R(:,1));
trends_timepointsR = length_m_R(points_trend_R(:,1));
trends_datapointsR = Day5DataR(points_trend_R(:,1));

seasonal_timepointsY = length_m_Y(points_season_Y(:,1));
season_datapointsY = Day5DataY(points_season_Y(:,1));
trends_timepointsY = length_m_Y(points_trend_Y(:,1));
trends_datapointsY = Day5DataY(points_trend_Y(:,1));

seasonal_timepointsB = length_m_B(points_season_B(:,1));
season_datapointsB = Day5DataB(points_season_B(:,1));
trends_timepointsB = length_m_B(points_trend_B(:,1));
trends_datapointsB = Day5DataB(points_trend_B(:,1));

%%

%%
% Plot CPs
figure;
subplot(3,1,1);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR,'k-','HandleVisibility','off');
xline(trends_timepointsR,'m-','HandleVisibility','off');
plot(seasonal_timepointsR,season_datapointsR,'ko','DisplayName','R - Seasonal CP');
plot(trends_timepointsR,trends_datapointsR,'mo','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,2);hold on;
plot(length_m_Y,Day5DataY,'.',"Color","y",'DisplayName','Y-freq Ovetime');
xline(trends_timepointsY,'m-','HandleVisibility','off');
xline(seasonal_timepointsY,'k-','HandleVisibility','off');
plot(seasonal_timepointsY,season_datapointsY,'ko','DisplayName','Y - Seasonal CP');
plot(trends_timepointsY,trends_datapointsY,'mo','DisplayName','Y - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,3);hold on;
plot(length_m_B,Day5DataB,'.',"Color","b",'DisplayName','B-freq Ovetime');
xline(trends_timepointsB,'m-','HandleVisibility','off');
xline(seasonal_timepointsB,'k-','HandleVisibility','off');
plot(seasonal_timepointsB,season_datapointsB,'ko','DisplayName','B - Trends CP')
plot(trends_timepointsB,trends_datapointsB,'mo','DisplayName','B - Seasonal CP'); 
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')


%% Plot the observed and estimated timeseries
f = figure;
subplot(3,1,1); hold on;
plot(length_m_R,Day5DataR-mode(Day5DataR),'.',"Color",'#f6c7c4', ...
    'DisplayName','R data');
plot(length_m_Y,Day5DataY-mode(Day5DataY),'.',"Color","#ffd284", ...
    'DisplayName','Y data');
plot(length_m_B,Day5DataB-mode(Day5DataB),'.',"Color","#c6dfe3",...
    'DisplayName','B data');

plot(length_m_R,beastmodel_R.season.Y,'r-','DisplayName','R Harmonic')
plot(length_m_Y,beastmodel_Y.season.Y,'y-','DisplayName','Y Harmonic')
plot(length_m_B,beastmodel_B.season.Y,'b-','DisplayName','B Harmonic')
legend
title('Seasonal Harmonic model of 5 days Transition Frequencies')
xlabel('Time');
ylabel('Seasonal Harmonic Amplitude')
f.Position = [0 100 1800 800];

subplot(3,1,2); hold on;
plot(length_m_R,Day5DataR,'.',"Color",'#f6c7c4', ...
    'DisplayName','R data');
plot(length_m_Y,Day5DataY,'.',"Color","#ffd284", ...
    'DisplayName','Y data');
plot(length_m_B,Day5DataB,'.',"Color","#c6dfe3",...
    'DisplayName','B data');
plot(length_m_R,beastmodel_R.trend.Y,'r-','DisplayName','R Harmonic')
plot(length_m_Y,beastmodel_Y.trend.Y,'y-','DisplayName','Y Harmonic')
plot(length_m_B,beastmodel_B.trend.Y,'b-','DisplayName','B Harmonic')
legend
title('Trend model of 5 days Transition Frequencies')
xlabel('Time');
ylabel('Grid Frequency')
f.Position = [0 100 1800 800];
%%
figure
hold on;
plot(length_m_R,Day5DataR,'.',"Color",'#f6c7c4', ...
    'DisplayName','R data');
plot(length_m_Y,Day5DataY,'.',"Color","#ffd284", ...
    'DisplayName','Y data');
plot(length_m_B,Day5DataB,'.',"Color","#c6dfe3",...
    'DisplayName','B data');

plot(length_m_R,beastmodel_R.season.Y+beastmodel_R.trend.Y,'r-','DisplayName','R Harmonic')
plot(length_m_Y,beastmodel_Y.season.Y+beastmodel_Y.trend.Y,'y-','DisplayName','Y Harmonic')
plot(length_m_B,beastmodel_B.season.Y+beastmodel_B.trend.Y,'b-','DisplayName','B Harmonic')
legend
xlabel('Time');
ylabel('Grid Frequency')

f.Position = [0 100 1800 800];

%% Plot Time differences among data points
f1 = PlotChangePointDiff(length_m_R,points_season_R);
f2 = PlotChangePointDiff(length_m_Y,points_season_Y);
f3 = PlotChangePointDiff(length_m_B,points_season_B);

%% Change points clustering
changePoints = [points_trend_R;points_season_R];
changePoints = unique(changePoints);
changePoints = sort(changePoints);

%% Plot change point only information
changePoingts_seson = Day5DataR(points_season_R);
changePoingts_trend = Day5DataR(points_trend_R);

length_p1 = length_m_R(points_season_R);
vertical_line_1 = length_p1(1:end);

length_p2 = length_m_R(points_trend_R);
vertical_line_2 = length_p2(1:end);

figure; 
subplot(3,1,1);hold on;
plot(length_m_R,Day5DataR,'b.');
plot(length_p1(1:end),changePoingts_seson(1:end),'ro');
xline(vertical_line_1,'-',"Color","#77AC30"); hold off;
subtitle('Seasonal/Wave Changepoints');

subplot(3,1,2);hold on;
plot(length_m_R,Day5DataR,'b.');
plot(length_p2(1:end),changePoingts_trend(1:end),'ko');
xline(vertical_line_2,'-',"Color","red"); hold off;
subtitle('Trend/Linear-trend Changepoints');
%%
figure
hold on;
plot(length_m_R,Day5DataR,'b.');

plot(length_p1(1:end),changePoingts_seson(1:end),'o',"Color","blue");
plot(length_p2(1:end),changePoingts_trend(1:end),'o',"Color","red");
xline(vertical_line_1,'-',"Color","blue"); hold off;
xline(vertical_line_2,'-',"Color","red"); hold off;
legend('Data','SCP','TCP','Location','southeast');


%% Text feedback
printbeast(beastmodel_R2)

%% Plot results
plotbeast(beastmodel_R2)
