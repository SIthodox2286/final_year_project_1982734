%% Import data from text file

% set datetime interval
datetime.setDefaultFormats('default','dd/MM/yyyy HH:mm:ss')
% set random for repeatablity
rng('default')

import_transition_data_imputed
import_baseline_data_imputed

%% Cross Correlation Different Frequencies - Some Basic Analysis
transition_R = transition_data_imputed(:,'R_Frequency');
transition_R = table2array(transition_R);
transition_Y = transition_data_imputed(:,'Y_Frequency');
transition_Y = table2array(transition_Y);
transition_B = transition_data_imputed(:,'B_Frequency');
transition_B = table2array(transition_B);

corrfRY = [];
corrfRB = [];
corrfYB = [];

i=0;
tLength = 1440;
for tLength = 1440:1440:length(transition_R)
    i=i+1;
    coff1 = corrcoef(transition_R(1:tLength),transition_Y(1:tLength));
    corrfRY(i) = coff1(1,2)
    
    coff2 = corrcoef(transition_R(1:tLength),transition_B(1:tLength));
    corrfRB(i) = coff2(1,2);

    coff3 = corrcoef(transition_Y(1:tLength),transition_B(1:tLength));
    corrfYB(i) = coff3(1,2);
end

baseline_R = baseline_data_imputed(:,'R_Frequency');
baseline_R = table2array(baseline_R);
baseline_Y = baseline_data_imputed(:,'Y_Frequency');
baseline_Y = table2array(baseline_Y);
baseline_B = baseline_data_imputed(:,'B_Frequency');
baseline_B = table2array(baseline_B);


corrfRY_b=[];
corrfRB_b=[];
corrfYB_b=[];
j=0;
for tLength = 1440:1440:length(baseline_R)
    j=j+1;
    coff1 = corrcoef(baseline_R(1:tLength),baseline_Y(1:tLength));
    corrfRY_b(j) = coff1(1,2);

    coff2 = corrcoef(baseline_R(1:tLength),baseline_B(1:tLength));
    corrfRB_b(j) = coff2(1,2);

    coff3 = corrcoef(baseline_Y(1:tLength),baseline_B(1:tLength));
    corrfYB_b(j) = coff3(1,2);
end

%corrfRY_b = corrcoef(baseline_R,baseline_Y);
%corrfRB_b = corrcoef(baseline_R,baseline_B);
%corrfYB_b = corrcoef(baseline_Y,baseline_B);

corrf = [mean(corrfRY_b(1,2)) mean(corrfRB_b(1,2)) mean(corrfYB_b(1,2)); mean(corrfRY(1,2)) mean(corrfRB(1,2)) mean(corrfYB(1,2))];

figure;
b = bar(corrf);
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

xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints;
labels3 = string(b(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

ylim([0 max(corrf(:,3))+0.1])
title('Cross Correlation Between Locations')
set(gca,'xticklabel',{'Baseline Data','Transition Data'})
legend('Coefficient R-Y','Coefficient R-B','Coefficient Y-B','Location','southeast')
%%
figure;
subplot(2,1,1); 
hold on;
plot(1440:1440:length(baseline_R),corrfRY_b)
plot(1440:1440:length(baseline_R),corrfRB_b)
plot(1440:1440:length(baseline_R),corrfYB_b);hold off
xlabel('Length of the Baseline Timeseries Sets')
ylabel('Coefficients')
legend('Coefficient R-Y','Coefficient R-B','Coefficient Y-B')

subplot(2,1,2);
hold on;
plot(1440:1440:length(transition_R),corrfRY)
plot(1440:1440:length(transition_R),corrfRB)
plot(1440:1440:length(transition_R),corrfYB);hold off
xlabel('Length of the Transition Timeseries Sets')
legend('Coefficient R-Y','Coefficient R-B','Coefficient Y-B')
ylabel('Coefficients')

%%
autocorr(transition_R,'NumLags',10,NumSTD=100)
