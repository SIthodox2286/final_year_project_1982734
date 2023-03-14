%% import the data
clear baseline_data_unprocessed
clear transition_data_unprocessed
import_baseline_data_script
import_transition_data_script
fixtime
%% extract frequency data - baseline
baseline_R = baseline_data_unprocessed(:,'R_Frequency');
baseline_R = table2array(baseline_R);
baseline_Y = baseline_data_unprocessed(:,'Y_Frequency');
baseline_Y = table2array(baseline_Y);
baseline_B = baseline_data_unprocessed(:,'B_Frequency');
baseline_B = table2array(baseline_B);

date=table2array(baseline_data_unprocessed(:,'Time'));
date = datetime(date);

figure;
subplot(2,1,1)
plot(date,baseline_R);
legend('Frequency at Location R - Baseline','Location','Southeast')

transition_R = transition_data_unprocessed(:,'R_Frequency');
transition_R = table2array(transition_R);
time = table2array(transition_data_unprocessed(:,'Time'));

subplot(2,1,2)
plot(time,transition_R);
legend('Frequency at Location R - Transition','Location','Southeast')
%% extract frequency data - transition
transition_R = transition_data_unprocessed(:,'R_Frequency');
transition_R = table2array(transition_R);
transition_Y = transition_data_unprocessed(:,'Y_Frequency');
transition_Y = table2array(transition_Y);
transition_B = transition_data_unprocessed(:,'B_Frequency');
transition_B = table2array(transition_B);

%% We need non-nan version for intial analysis without a loss of information
baseline_R(find(baseline_R==0))=nan;
baseline_Y(find(baseline_Y==0))=nan;
baseline_B(find(baseline_B==0))=nan;

baseline_R_no_nan = baseline_R(~isnan(baseline_R));
baseline_Y_no_nan = baseline_Y(~isnan(baseline_Y));
baseline_B_no_nan = baseline_B(~isnan(baseline_B));

transition_R(find(transition_R==0))=nan;
transition_R(find(transition_R==0))=nan;
transition_R(find(transition_R==0))=nan;

transition_R_no_nan = transition_R(~isnan(transition_R));
transition_Y_no_nan = transition_Y(~isnan(transition_Y));
transition_B_no_nan = transition_B(~isnan(transition_B));

TransTimeNoNaN = time(~isnan(transition_R));
%%
RMINfluctuation = (min(transition_R_no_nan)-mean(transition_R_no_nan))/mean(transition_R_no_nan);
BMINfluctuation = (min(transition_B_no_nan)-mean(transition_B_no_nan))/mean(transition_B_no_nan);
YMINfluctuation = (min(transition_Y_no_nan)-mean(transition_Y_no_nan))/mean(transition_Y_no_nan);

display(mean([RMINfluctuation,BMINfluctuation,YMINfluctuation]))

RMAXfluctuation = (max(transition_R_no_nan)-mean(transition_R_no_nan))/mean(transition_R_no_nan);
BMAXfluctuation = (max(transition_B_no_nan)-mean(transition_B_no_nan))/mean(transition_B_no_nan);
YMAXfluctuation = (max(transition_Y_no_nan)-mean(transition_Y_no_nan))/mean(transition_Y_no_nan);

display(mean([RMAXfluctuation,BMAXfluctuation,YMAXfluctuation]))

%% show average
mean_R_base = mean(baseline_R_no_nan);
mean_Y_base = mean(baseline_Y_no_nan);
mean_B_base = mean(baseline_B_no_nan);

mean_R_trans = mean(transition_R_no_nan);
mean_Y_trans = mean(transition_Y_no_nan);
mean_B_trans = mean(transition_B_no_nan);

information_mean = [mean_R_base mean_R_trans; mean_Y_base mean_Y_trans;...
    mean_B_base mean_B_trans];
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
legend('Baseline','Transition');
title('Mean of the baseline and transition data for Frequency in locations')
%saveas(gcf,'Figures\mean_no_imputation_figure.pdf')

%% show variance
var_R_base = std(baseline_R_no_nan)^2;
var_Y_base = std(baseline_Y_no_nan)^2;
var_B_base = std(baseline_B_no_nan)^2;

var_R_trans = std(transition_R_no_nan)^2;
var_Y_trans = std(transition_Y_no_nan)^2;
var_B_trans = std(transition_B_no_nan)^2;

information_variance = [var_R_base var_R_trans; var_Y_base var_Y_trans;...
    var_B_base var_B_trans];
barnames = categorical({'R Frequency','Y Frequency','B Frequency'});
barnames = reordercats(barnames,{'R Frequency','Y Frequency', ...
    'B Frequency'});
b = bar(barnames,information_variance);
maxBar = max(max(information_variance));
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
legend('Baseline','Transition');
title('Variance of the baseline and transition data for Frequency in locations')
%saveas(gcf,'Figures\variance_no_imputation_figure.pdf')

%% Q25, Q50 and Q75

Q25R_baseline = quantile(baseline_R_no_nan,0.25);
Q50R_baseline = quantile(baseline_R_no_nan,0.5);
Q75R_baseline = quantile(baseline_R_no_nan,0.75);

Q25Y_baseline = quantile(baseline_Y_no_nan,0.25);
Q50Y_baseline = quantile(baseline_Y_no_nan,0.5);
Q75Y_baseline = quantile(baseline_Y_no_nan,0.75);

Q25B_baseline = quantile(baseline_B_no_nan,0.25);
Q50B_baseline = quantile(baseline_B_no_nan,0.5);
Q75B_baseline = quantile(baseline_B_no_nan,0.75);

Q25R_transition = quantile(transition_R_no_nan,0.25);
Q50R_transition = quantile(transition_R_no_nan,0.5);
Q75R_transition = quantile(transition_R_no_nan,0.75);

Q25Y_transition = quantile(transition_Y_no_nan,0.25);
Q50Y_transition = quantile(transition_Y_no_nan,0.5);
Q75Y_transition = quantile(transition_Y_no_nan,0.75);

Q25B_transition = quantile(transition_B_no_nan,0.25);
Q50B_transition = quantile(transition_B_no_nan,0.5);
Q75B_transition = quantile(transition_B_no_nan,0.75);

Q25 = [Q25R_baseline Q25R_transition; Q25Y_baseline Q25Y_transition;...
    Q25B_baseline Q25B_transition];

Q50 = [Q50R_baseline Q50R_transition; Q50Y_baseline Q50Y_transition;...
    Q50B_baseline Q50B_transition];

Q75 = [Q75R_baseline Q75R_transition; Q75Y_baseline Q75Y_transition;...
    Q75B_baseline Q75B_transition];

informationQ = [Q25;Q50;Q75];
namesQ = {'R Frequency Q25','Y Frequency Q25','B Frequency Q25',...
    'R Frequency Q50','Y Frequency Q50','B Frequency Q50',...
    'R Frequency Q75','Y Frequency Q75','B Frequency Q75'};
barnamesQ = categorical(namesQ);
barnamesQ = reordercats(barnamesQ,namesQ);
b = bar(barnamesQ,informationQ);
maxBar = max(max(informationQ));
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
legend('Baseline','Transition');
title('Quantiles of the baseline and transition data for Frequency in locations')


%% show percentage of missing values
nan_in_BR = (sum(isnan(baseline_R))/size(baseline_R,1)).*100;
nan_in_TR = (sum(isnan(transition_R))/size(transition_R,1)).*100;

nan_in_BY = (sum(isnan(baseline_Y))/size(baseline_Y,1)).*100;
nan_in_TY = (sum(isnan(transition_Y))/size(transition_Y,1)).*100;

nan_in_BB = (sum(isnan(baseline_B))/size(baseline_B,1)).*100;
nan_in_TB = (sum(isnan(transition_B))/size(transition_B,1)).*100;

information_missing = [nan_in_BR nan_in_TR; nan_in_BY nan_in_TY;...
    nan_in_BB nan_in_TB];
barnames = categorical({'R Frequency','Y Frequency','B Frequency'});
barnames = reordercats(barnames,{'R Frequency','Y Frequency', ...
    'B Frequency'});
b = bar(barnames,information_missing);
maxBar = max(max(information_missing));
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
legend('Baseline','Transition');
ylabel('Percentage')
title('Missing Readings of the baseline and transition data for Frequency in locations')
%saveas(gcf,'Figures\missing_point_propotion_figure.pdf')

%% Peak and Dip research
transition_data_unprocessed(:,'Time') = Time;

PeakR_transition = quantile(transition_R_no_nan,0.9);
PeakY_transition = quantile(transition_Y_no_nan,0.9);
PeakB_transition = quantile(transition_B_no_nan,0.9);

Rpeak = transition_R_no_nan(transition_R_no_nan>=PeakR_transition);
RpeakTime = transition_data_unprocessed(transition_data_unprocessed.R_Frequency ...
    >=PeakR_transition,'Time');
RpeakTime = table2array(RpeakTime);
RpeakTimeTime = hour(RpeakTime);

figure; hold on
plot(TransTimeNoNaN,transition_R_no_nan,'b.');
plot(RpeakTime,Rpeak,'ro'); hold off
title('R Peak Selected');

figure;
histogram(RpeakTimeTime);
title('R Peak Time Statistics')
xlabel('Hour in a Day')
ylabel('Rate of Occurances')

DipR_transition = quantile(transition_R_no_nan,0.1);
DipY_transition = quantile(transition_Y_no_nan,0.1);
DipB_transition = quantile(transition_B_no_nan,0.1);

transition_data_unprocessed.R_Frequency(find(transition_data_unprocessed.R_Frequency==0))=nan;


Rdip = transition_R_no_nan(transition_R_no_nan<=DipR_transition);
RdipTime = transition_data_unprocessed(transition_data_unprocessed.R_Frequency ...
    <=DipR_transition,'Time');
RdipTime = table2array(RdipTime);
RdipTimeTime = hour(RdipTime);

TransTimeNoNaNR = table2array(Time);
TransTimeNoNaNR = TransTimeNoNaNR(~isnan(transition_R));

figure; hold on
plot(TransTimeNoNaNR,transition_R_no_nan,'b.');
plot(RdipTime,Rdip,'ro'); hold off
title('R Dip Selected');

figure;
histogram(RdipTimeTime);
title('R Dip Time Statistics')
xlabel('Hour in a Day')
ylabel('Rate of Occurances')

transition_data_unprocessed.Y_Frequency(find(transition_data_unprocessed.Y_Frequency==0))=nan;

transition_Y_no_nan = transition_data_unprocessed.Y_Frequency(~isnan(transition_data_unprocessed.Y_Frequency));

Ydip = transition_Y_no_nan(transition_Y_no_nan<=DipY_transition);
YdipTime = transition_data_unprocessed(transition_data_unprocessed.Y_Frequency ...
    <=DipY_transition,'Time');
YdipTime = table2array(YdipTime);
YdipTimeTime = hour(YdipTime);

TransTimeNoNaNY = table2array(Time);
TransTimeNoNaNY = TransTimeNoNaNY(~isnan(transition_Y));

figure; hold on
plot(TransTimeNoNaNY,transition_Y_no_nan,'b.');
plot(YdipTime,Ydip,'ro'); hold off
title('Y Dip Selected');

figure;
histogram(YdipTimeTime);
title('Y Dip Time Statistics')

transition_data_unprocessed.B_Frequency(find(transition_data_unprocessed.B_Frequency==0))=nan;
Bdip = transition_B_no_nan(transition_B_no_nan<=DipB_transition);
BdipTime = transition_data_unprocessed(transition_data_unprocessed.B_Frequency ...
    <=DipB_transition,'Time');
BdipTime = table2array(BdipTime);
BdipTimeTime = hour(BdipTime);

TransTimeNoNaNB = table2array(Time);
TransTimeNoNaNB = TransTimeNoNaNB(~isnan(transition_B));

figure; hold on
plot(TransTimeNoNaNB,transition_B_no_nan,'b.');
plot(BdipTime,Bdip,'ro'); hold off
title('B Dip Selected');

figure;
histogram(BdipTimeTime);
title('B Dip Time Statistics')






