%% Import data from text file
clear baseline_data_unprocessed
clear transition_data_unprocessed
clear transition_data_imputed
clear baseline_data_imputed
import_baseline_data_script
import_transition_data_script
import_baseline_data_imputed
import_transition_data_imputed

%% Data Processing - Fix Time data
%% Obtain Time
date = transition_data_imputed(:,'Time');
Time = table2array(date); % 

%% Frequencies
R1_frequency_baseline = baseline_data_unprocessed(:,'R_Frequency');
R1_frequency_baseline = table2array(R1_frequency_baseline);

R2_frequency_baseline = baseline_data_imputed(:,'R_Frequency');
R2_frequency_baseline= table2array(R2_frequency_baseline);

R1_frequency = transition_data_unprocessed(:,'R_Frequency');
R1_frequency = table2array(R1_frequency);

R2_frequency = transition_data_imputed(:,'R_Frequency');
R2_frequency= table2array(R2_frequency);

Y1_frequency = transition_data_unprocessed(:,'Y_Frequency');
Y1_frequency = table2array(Y1_frequency);

Y2_frequency = transition_data_imputed(:,'Y_Frequency');
Y2_frequency= table2array(Y2_frequency);

B1_frequency = transition_data_unprocessed(:,'B_Frequency');
B1_frequency = table2array(B1_frequency);

B2_frequency = transition_data_imputed(:,'B_Frequency');
B2_frequency= table2array(B2_frequency);

%% plot unprocessed
date = table2array(transition_data_imputed(:,'Time'));
date = datetime(date);

datebase = table2array(baseline_data_imputed(:,'Time'));
datebase = datetime(datebase);

figure;
subplot(2,1,1);
plot(datebase,R1_frequency_baseline,'r.');
title('Unimputed R Frequency Baseline Overtime');

% plot imputed
subplot(2,1,2);
plot(datebase,R2_frequency_baseline,'b.');
title('Imputed R Frequency Baseline Overtime');


figure;
subplot(2,1,1);
plot(date,R1_frequency,'r.');
title('Unimputed R Frequency Transition Overtime');

% plot imputed
subplot(2,1,2);
plot(date,R2_frequency,'b.');
title('Imputed R Frequency Transition Overtime');
%%
figure;
subplot(2,1,1);
plot(date,Y1_frequency,'r.');
title('Unimputed Y Frequency Overtime');

% plot imputed
subplot(2,1,2);
plot(date,Y2_frequency,'b.');
title('Imputed Y Frequency Overtime');

figure;
subplot(2,1,1);
plot(date,B1_frequency,'r.');
title('Unimputed B Frequency Overtime');

% plot imputed
subplot(2,1,2);
plot(date,B2_frequency,'b.');
title('Imputed B Frequency Overtime');

%% show average
mean_R1 = mean(R1_frequency(~isnan(R1_frequency)));
mean_Y1 = mean(Y1_frequency(~isnan(Y1_frequency)));
mean_B1 = mean(B1_frequency(~isnan(B1_frequency)));

mean_R2 = mean(R2_frequency);
mean_Y2 = mean(Y2_frequency);
mean_B2 = mean(B2_frequency);

figure
information_mean = [mean_R1 mean_R2; mean_Y1 mean_Y2;...
    mean_B1 mean_B2];
barnames = categorical({'R Frequency','Y Frequency','B Frequency'});
barnames = reordercats(barnames,{'R Frequency','Y Frequency', ...
    'B Frequency'});
b = bar(barnames,information_mean);
maxBar = max(max(information_mean));
ylim([0, maxBar*1.25]);

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Before Imputation','After Imputation');
title(['Mean of the transition data for Frequency in locations before ' ...
    'and after imputation'])
%saveas(gcf,'Figures\mean_comparison_imputation.pdf')

figure;
percentagechange = [abs((mean_R1-mean_R2)/mean_R1)*100;...
    abs((mean_Y1-mean_Y2)/mean_Y1)*100;...
    abs((mean_B1-mean_B2)/mean_B1)*100];
barnamesPerc = categorical({'R Frequency','Y Frequency','B Frequency'});
barnamesPerc = reordercats(barnamesPerc,{'R Frequency','Y Frequency', ...
    'B Frequency'});
bperc = bar(barnamesPerc,percentagechange);
xtipsperc= bperc(1).XEndPoints;
ytipsperc = bperc(1).YEndPoints;
labelsperc = string(bperc(1).YData);
text(xtipsperc,ytipsperc,labelsperc,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Percentage Change of Mean');

%% show variance
std_R1 = std(R1_frequency(~isnan(R1_frequency)));
std_Y1 = std(Y1_frequency(~isnan(Y1_frequency)));
std_B1 = std(B1_frequency(~isnan(B1_frequency)));

std_R2 = std(R2_frequency);
std_Y2 = std(Y2_frequency);
std_B2 = std(B2_frequency);

figure
information_std = [std_R1 std_R2; std_Y1 std_Y2;...
    std_B1 std_B2];
barnames = categorical({'R Frequency','Y Frequency','B Frequency'});
barnames = reordercats(barnames,{'R Frequency','Y Frequency', ...
    'B Frequency'});
b = bar(barnames,information_std);
maxBar = max(max(information_std));
ylim([0, maxBar*1.25]);

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Before Imputation','After Imputation');
title(['Standard Deviation of the transition data for' ...
    ' Frequency in locations before and after imputation'])
%saveas(gcf,'Figures\std_comparison_imputation.pdf')

figure;
percentagechange = [abs((std_R1-std_R2)/std_R1)*100;...
    abs((std_Y1-std_Y2)/std_Y1)*100;...
    abs((std_B1-std_B2)/std_B1)*100];
barnamesPerc = categorical({'R Frequency','Y Frequency','B Frequency'});
barnamesPerc = reordercats(barnamesPerc,{'R Frequency','Y Frequency', ...
    'B Frequency'});
bperc = bar(barnamesPerc,percentagechange);
xtipsperc= bperc(1).XEndPoints;
ytipsperc = bperc(1).YEndPoints;
labelsperc = string(bperc(1).YData);
text(xtipsperc,ytipsperc,labelsperc,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('Percentage Change of Standard Deviation');

%% Test Change-Poing Analysis on the Data
figure
findchangepts(R2_frequency,'Statistic','std', ...
    'MaxNumChanges',35);
title('Standard Deviation Based Change-point Search')
legend('Data','local mean','Change Point')

figure
findchangepts(R2_frequency,'Statistic','mean', ...
    'MinThreshold',min(R2_frequency));
title('Mean Based Change-point Search')
legend('Data','local mean','Change Point')

%%
figure
findchangepts(R2_frequency,'Statistic','linear',...
    'MaxNumChanges',35);
title('Linear Based Change-point Search')
legend('Data','local mean','Change Point')


%% Further Data Formulation
R_Frequency = transition_data_imputed(:,'R_Frequency');
Y_Frequency = transition_data_imputed(:,'Y_Frequency');
B_frequency = transition_data_imputed(:,'B_Frequency');

freqencies = B_frequency;

freqencies = addvars(freqencies,Y_Frequency, ...
    'Before',"B_Frequency");
freqencies.Y_Frequency = table2array( ...
    freqencies.Y_Frequency);

freqencies = addvars(freqencies,R_Frequency, ...
    'Before',"Y_Frequency");
freqencies.R_Frequency = table2array( ...
    freqencies.R_Frequency);

TT = addvars(freqencies,date, ...
    'Before',"R_Frequency");

T = size(TT,1);

R_Frequency_base = baseline_data_imputed(:,'R_Frequency');
Y_Frequency_base = baseline_data_imputed(:,'Y_Frequency');
B_frequency_base = baseline_data_imputed(:,'B_Frequency');

freqencies_base = B_frequency_base;

freqencies_base = addvars(freqencies_base,Y_Frequency_base, ...
    'Before',"B_Frequency");
freqencies_base.Y_Frequency_base = table2array( ...
    freqencies_base.Y_Frequency_base);

freqencies_base = addvars(freqencies_base,R_Frequency_base, ...
    'Before',"Y_Frequency_base");
freqencies_base.R_Frequency_base = table2array( ...
    freqencies_base.R_Frequency_base);

freqencies_base = renamevars(freqencies_base,["Y_Frequency_base","R_Frequency_base"], ...
                 ["Y_Frequency","R_Frequency"]);

TT_base = addvars(freqencies_base,date_base, ...
    'Before',"R_Frequency");

T_base = size(TT,1);

%% Test usage of Control Charts
figure
chart = controlchart(table2array(freqencies),'rules','we2');
x = chart.mean;
cl = chart.mu;
se = chart.sigma./sqrt(chart.n);
hold on
plot(cl+2*se,'m')
title("Control Chart with 2 of 3 above cl + 2*se (Transition)")

figure;
chartBase = controlchart(table2array(freqencies_base),'rules','we2');
x = chartBase.mean;
cl = chartBase.mu;
se = chartBase.sigma./sqrt(chartBase.n);
hold on
plot(cl+2*se,'m')
title("Control Chart with 2 of 3 above cl + 2*se (Baseline)")

%% Beyansian Change-point test
R_frequency_33_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'R_Frequency','Sheet','Time'});
R_frequency_33_day_all = R_frequency_33_day_all(R_frequency_33_day_all.Sheet>1,:);
R_frequency_33_day = table2array(R_frequency_33_day_all(:,'R_Frequency'));

%% Box Plot 
figure;
box_trans=boxplot(table2array(freqencies),'Labels',{'R Frequency','Y Frequency', ...
    'B Frequency'},'Orientation','horizontal');
title('Boxplot of the Transition Data Frequencies')

figure;
box_base=boxplot(table2array(freqencies_base),'Labels',{'R Frequency','Y Frequency', ...
    'B Frequency'},'Orientation','horizontal');
title('Boxplot of the Baseline Data Frequencies')

%% BEAST model auto optimization
beastmodel = beast(R_frequency_33_day,'freq',1440,'scp.minmax',[0,50], ...
    'tcp.minmax',[0,50]);

%% Text feedback
printbeast(beastmodel)

%% Plot results
plotbeast(beastmodel,"ncpStat",'mean')

%% Preparation for plots
points_season = sort(beastmodel.season.cp(1:end-1));
points_season = points_season(~isnan(points_season));
points_season = [1;points_season];
points_trend = sort(beastmodel.trend.cp);
points_trend = points_trend(~isnan(points_trend));
points_trend = [1;points_trend];
length_m = R_frequency_33_day_all(:,'Time');
length_m = table2array(length_m);
length_m = datetime(length_m);
time = R_frequency_33_day_all(:,'Time');
time = table2array(time);

%% Plot the observed and estimated timeseries
figure;hold on;
plot(length_m,R_frequency_33_day,'g.')
plot(length_m,beastmodel.trend.Y+beastmodel.season.Y,'r-')
legend('Observation','Curve fit by BEAST','Location','southeast')
title('Timeseries of 33 days Transition Frequency at site-R')

%% Plot change point only information
changePoingts_seson = R_frequency_33_day(points_season);
changePoingts_trend = R_frequency_33_day(points_trend);

length_p1 = length_m(points_season);
vertical_line_1 = length_p1(2:end);

length_p2 = length_m(points_trend);
vertical_line_2 = length_p2(2:end);

figure; 
subplot(3,1,1);hold on;
plot(length_m,R_frequency_33_day,'b.');
plot(length_p1(2:end),changePoingts_seson(2:end),'ro');
xline(vertical_line_1,'-',"Color","#77AC30"); hold off;
subtitle('Seasonal/Wave Changepoints');

subplot(3,1,2);hold on;
plot(length_m,R_frequency_33_day,'b.');
plot(length_p2(2:end),changePoingts_trend(2:end),'ko');
xline(vertical_line_2,'-',"Color","red"); hold off;
subtitle('Trend/Linear-trend Changepoints');

subplot(3,1,3);hold on;
plot(length_m,R_frequency_33_day,'b.');
plot(length_p1(2:end),changePoingts_seson(2:end),'o',"Color","blue");
plot(length_p2(2:end),changePoingts_trend(2:end),'o',"Color","red");
xline(vertical_line_1,'-',"Color","blue"); hold off;
xline(vertical_line_2,'-',"Color","red"); hold off;
legend('Data','SCP','TCP','Location','southeast');
subtitle('Total Changepoints detected');


%% ARIMA attempt of modelling
%% formulation of model
Mdl = arima(2,0,1);

preidx = 1:Mdl.P;
estidx = (Mdl.P + 1):T;

%%
EstMdl = estimate(Mdl,TT{estidx,"R_Frequency"},...
    'Y0',TT{preidx,"R_Frequency"},'Display','off');   

% extract values for plot
resid = infer(EstMdl,TT{estidx,"R_Frequency"},...
    'Y0',TT{preidx,"R_Frequency"});

yhat = TT{estidx,"R_Frequency"} - resid;

%% Correlation analysis
correlation = corrcoef(TT{estidx,"R_Frequency"},yhat);
display(correlation)

%%
figure;
plot(datetime(TT.date(estidx)),TT{estidx,"R_Frequency"},'.'); hold on
plot(datetime(TT.date(estidx)),yhat,'.','LineWidth',2); 
hold off;

figure;
plot(yhat,resid,'.')
ylabel('Residuals')
xlabel('Fitted values')



