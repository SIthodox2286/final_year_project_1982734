%% Import Data
clear;
import_transition_data_gapped
import_transition_data_imputed

%%
[beastmodel_R1,Day5AllR,Day5DataR] = beast_date(transition_gapped,'R_Frequency',[11 12],60);
[beastmodel_R2,Day5AllR,Day5DataR] = beast_date(transition_gapped,'R_Frequency',[11 12],60);
[beastmodel_R3,Day5AllR,Day5DataR] = beast_date(transition_gapped,'R_Frequency',[11 12],60);

% Preparation for plots
[points_season_R1,points_trend_R1] = takeCP(beastmodel_R1,0.0);
% Preparation for plots
[points_season_R2,points_trend_R2] = takeCP(beastmodel_R2,0.0);
% Preparation for plots
[points_season_R3,points_trend_R3] = takeCP(beastmodel_R3,0.0);

% Take Date and time information
format long

length_m_R = Day5AllR(:,'Time');
length_m_R = table2array(length_m_R);
length_m_R = datetime(length_m_R);
timeR = Day5AllR(:,'Time');
timeR = table2array(timeR);

% Occurance Analysis Across Different Timepoints (Seansonal Changes)
seasonal_timepointsR1 = length_m_R(points_season_R1(:,1));
season_datapointsR1 = Day5DataR(points_season_R1(:,1));
trends_timepointsR1 = length_m_R(points_trend_R1(:,1));
trends_datapointsR1 = Day5DataR(points_trend_R1(:,1));

seasonal_timepointsR2 = length_m_R(points_season_R2(:,1));
season_datapointsR2 = Day5DataR(points_season_R2(:,1));
trends_timepointsR2 = length_m_R(points_trend_R2(:,1));
trends_datapointsR2 = Day5DataR(points_trend_R2(:,1));

seasonal_timepointsR3 = length_m_R(points_season_R3(:,1));
season_datapointsR3 = Day5DataR(points_season_R3(:,1));
trends_timepointsR3 = length_m_R(points_trend_R3(:,1));
trends_datapointsR3 = Day5DataR(points_trend_R3(:,1));

% Plot CPs
figure;
subplot(3,1,1);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR1,'b-','HandleVisibility','off');
xline(trends_timepointsR1,'g-','HandleVisibility','off');
plot(seasonal_timepointsR1,season_datapointsR1,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR1,trends_datapointsR1,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,2);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR2,'b-','HandleVisibility','off');
xline(trends_timepointsR2,'g-','HandleVisibility','off');
plot(seasonal_timepointsR2,season_datapointsR2,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR2,trends_datapointsR2,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')


subplot(3,1,3);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR3,'b-','HandleVisibility','off');
xline(trends_timepointsR3,'g-','HandleVisibility','off');
plot(seasonal_timepointsR3,season_datapointsR3,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR3,trends_datapointsR3,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')
%%
dates = datetime(transition_data_imputed.Time);
transition_data_imputed.Time = dates;

%%
[beastmodel_R1,Day5AllR,Day5DataR] = beast_date(transition_data_imputed,'R_Frequency',[11 12],60);
[beastmodel_R2,Day5AllR,Day5DataR] = beast_date(transition_data_imputed,'R_Frequency',[11 12],60);
[beastmodel_R3,Day5AllR,Day5DataR] = beast_date(transition_data_imputed,'R_Frequency',[11 12],60);

% Preparation for plots
[points_season_R1,points_trend_R1] = takeCP(beastmodel_R1,0.0);
% Preparation for plots
[points_season_R2,points_trend_R2] = takeCP(beastmodel_R2,0.0);
% Preparation for plots
[points_season_R3,points_trend_R3] = takeCP(beastmodel_R3,0.0);

% Take Date and time information
format long

length_m_R = Day5AllR(:,'Time');
length_m_R = table2array(length_m_R);
length_m_R = datetime(length_m_R);
timeR = Day5AllR(:,'Time');
timeR = table2array(timeR);

% Occurance Analysis Across Different Timepoints (Seansonal Changes)
seasonal_timepointsR1 = length_m_R(points_season_R1(:,1));
season_datapointsR1 = Day5DataR(points_season_R1(:,1));
trends_timepointsR1 = length_m_R(points_trend_R1(:,1));
trends_datapointsR1 = Day5DataR(points_trend_R1(:,1));

seasonal_timepointsR2 = length_m_R(points_season_R2(:,1));
season_datapointsR2 = Day5DataR(points_season_R2(:,1));
trends_timepointsR2 = length_m_R(points_trend_R2(:,1));
trends_datapointsR2 = Day5DataR(points_trend_R2(:,1));

seasonal_timepointsR3 = length_m_R(points_season_R3(:,1));
season_datapointsR3 = Day5DataR(points_season_R3(:,1));
trends_timepointsR3 = length_m_R(points_trend_R3(:,1));
trends_datapointsR3 = Day5DataR(points_trend_R3(:,1));

% Plot CPs
figure;
subplot(3,1,1);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR1,'b-','HandleVisibility','off');
xline(trends_timepointsR1,'g-','HandleVisibility','off');
plot(seasonal_timepointsR1,season_datapointsR1,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR1,trends_datapointsR1,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')

subplot(3,1,2);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR2,'b-','HandleVisibility','off');
xline(trends_timepointsR2,'g-','HandleVisibility','off');
plot(seasonal_timepointsR2,season_datapointsR2,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR2,trends_datapointsR2,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')


subplot(3,1,3);hold on;
plot(length_m_R,Day5DataR,'.',"Color","red",'DisplayName','R-freq Ovetime');
xline(seasonal_timepointsR3,'b-','HandleVisibility','off');
xline(trends_timepointsR3,'g-','HandleVisibility','off');
plot(seasonal_timepointsR3,season_datapointsR3,'bo','DisplayName','R - Seasonal CP');
plot(trends_timepointsR3,trends_datapointsR3,'g*','DisplayName','R - Trends CP');
hold off;
legend('FontSize',8,'FontWeight','bold','Location','southeast')
%% %%%%%%%%%%%% TO DO
% To Do: Get measurements on the increased stability by
% gathering average number of change points (timewise location and amount)
% over sufficient amount of repeats in modelling;