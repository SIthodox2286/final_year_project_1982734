clear
load dataIncluded\'BEASTARIMA'\ARIMA_BEAST_accuracy_Transition_1.mat
load dataIncluded\'BEASTARIMA'\ARIMA_BEAST_accuracy_Transition_2.mat
load dataIncluded\'BEASTARIMA'\ARIMA_BEAST_accuracy_Baseline_2.mat
load dataIncluded\'BEASTARIMA'\ARIMA_BEAST_accuracy_Transition_stab_studies.mat
%%
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

%% For Transition Imputed
R2_score_transition_imputed = zeros(5,3);
MAPE_transition_imputed = zeros(5,3);

for i = 1:5
    % R
    tcp_test_transition_imputeds = testResults_transition_imputed_R(i).trend.cp;
    tcp_pred_transition_imputeds = predResults_transition_imputed_R(i).trend.cp;
    scp_test_transition_imputeds = testResults_transition_imputed_R(i).season.cp;
    scp_pred_transition_imputeds = predResults_transition_imputed_R(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_imputeds;scp_test_transition_imputeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_imputeds;scp_pred_transition_imputeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    %err = immse(change_points_test,change_points_pred);
    %err = err/mean(change_points_test);
    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_imputed(i,1) = R2_score;
    MAPE_transition_imputed(i,1) = 100*err;
    % Y
    tcp_test_transition_imputeds = testResults_transition_imputed_Y(i).trend.cp;
    tcp_pred_transition_imputeds = predResults_transition_imputed_Y(i).trend.cp;
    scp_test_transition_imputeds = testResults_transition_imputed_Y(i).season.cp;
    scp_pred_transition_imputeds = predResults_transition_imputed_Y(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_imputeds;scp_test_transition_imputeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_imputeds;scp_pred_transition_imputeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_imputed(i,2) = R2_score;
    MAPE_transition_imputed(i,2) = 100*err;
    % B
    tcp_test_transition_imputeds = testResults_transition_imputed_B(i).trend.cp;
    tcp_pred_transition_imputeds = predResults_transition_imputed_B(i).trend.cp;
    scp_test_transition_imputeds = testResults_transition_imputed_B(i).season.cp;
    scp_pred_transition_imputeds = predResults_transition_imputed_B(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_imputeds;scp_test_transition_imputeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_imputeds;scp_pred_transition_imputeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_imputed(i,3) = R2_score;
    MAPE_transition_imputed(i,3) = 100*err;
end

%% For Transition Gapped
R2_score_transition_gapped = zeros(5,3);
MAPE_transition_gapped = zeros(5,3);

for i = 1:5
    % R
    tcp_test_transition_gappeds = testResults_transition_gapped_R(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_transition_gapped_R(i).trend.cp;
    scp_test_transition_gappeds = testResults_transition_gapped_R(i).season.cp;
    scp_pred_transition_gappeds = predResults_transition_gapped_R(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_gapped(i,1) = R2_score;
    MAPE_transition_gapped(i,1) = 100*err;
    % Y
    tcp_test_transition_gappeds = testResults_transition_gapped_Y(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_transition_gapped_Y(i).trend.cp;
    scp_test_transition_gappeds = testResults_transition_gapped_Y(i).season.cp;
    scp_pred_transition_gappeds = predResults_transition_gapped_Y(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_gapped(i,2) = R2_score;
    MAPE_transition_gapped(i,2) = 100*err;
    % B
    tcp_test_transition_gappeds = testResults_transition_gapped_B(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_transition_gapped_B(i).trend.cp;
    scp_test_transition_gappeds = testResults_transition_gapped_B(i).season.cp;
    scp_pred_transition_gappeds = predResults_transition_gapped_B(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_transition_gapped(i,3) = R2_score;
    MAPE_transition_gapped(i,3) = 100*err;
end

%% For Baseline Imputed
R2_score_baseline_imputed = zeros(5,3);
MAPE_baseline_imputed = zeros(5,3);

for i = 1:5
    % R
    tcp_test_transition_gappeds = testResults_baseline_imputed_R(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_baseline_imputed_R(i).trend.cp;
    scp_test_transition_gappeds = testResults_baseline_imputed_R(i).season.cp;
    scp_pred_transition_gappeds = predResults_baseline_imputed_R(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_baseline_imputed(i,1) = R2_score;
    MAPE_baseline_imputed(i,1) = 100*err;
    % Y
    tcp_test_transition_gappeds = testResults_baseline_imputed_Y(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_baseline_imputed_Y(i).trend.cp;
    scp_test_transition_gappeds = testResults_baseline_imputed_Y(i).season.cp;
    scp_pred_transition_gappeds = predResults_baseline_imputed_Y(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_baseline_imputed(i,2) = R2_score;
    MAPE_baseline_imputed(i,2) = 100*err;
    % B
    tcp_test_transition_gappeds = testResults_baseline_imputed_B(i).trend.cp;
    tcp_pred_transition_gappeds = predResults_baseline_imputed_B(i).trend.cp;
    scp_test_transition_gappeds = testResults_baseline_imputed_B(i).season.cp;
    scp_pred_transition_gappeds = predResults_baseline_imputed_B(i).season.cp;
    
    
    
    change_points_test = sort(unique([tcp_test_transition_gappeds;scp_test_transition_gappeds]));
    change_points_test = change_points_test(~isnan(change_points_test));
    
    change_points_pred = sort(unique([tcp_pred_transition_gappeds;scp_pred_transition_gappeds]));
    change_points_pred = change_points_pred(~isnan(change_points_pred));
    
    if length(change_points_pred)<length(change_points_test)
        change_points_test = change_points_test(1:length(change_points_pred));
    elseif length(change_points_test)<length(change_points_pred)
        change_points_pred = change_points_pred(1:length(change_points_test));
    end
    
    R2_score = corrcoef(change_points_test,change_points_pred);
    R2_score = R2_score(1,2)^2;

    templist = [];
    for ii = 1:length(change_points_test)
        x = abs(change_points_test(ii)-change_points_pred(ii));
        x = x/change_points_test(ii);
        templist(ii) = x;
    end
    err = sum(templist)/length(change_points_test);
    
    R2_score_baseline_imputed(i,3) = R2_score;
    MAPE_baseline_imputed(i,3) = 100*err;
end
%%
save('R2_scores_and_MAPE_final_ARIMABEAST.mat',"R2_score_transition_imputed", ...
    "MAPE_transition_imputed","R2_score_transition_gapped","MAPE_transition_gapped", ...
    "R2_score_baseline_imputed","MAPE_baseline_imputed")

%%
averageMAPE_transition_imputed=mean(MAPE_transition_imputed);

averageMAPE_transition_gapped=mean(MAPE_transition_gapped);

averageMAPE_baseline_imputed=mean(MAPE_baseline_imputed);

averageMAPE_transition_gapped(3)=mean(MAPE_transition_gapped(2:end,3));

averageMAPE_baseline_imputed(3)=mean(MAPE_baseline_imputed(2:end,3));

meanAll = [averageMAPE_transition_imputed;averageMAPE_transition_gapped;averageMAPE_baseline_imputed];
meanAll = mean(meanAll)

%%
figure;
subplot(3,1,1); hold on;
xaxis = [4,9,14,22,27]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('MAPE (%)');
xlabel('Date Imputed');
legend('TranS R RFI','TranS Y RFI','TranS B RFI')

subplot(3,1,2); hold on;
xaxis = [4,9,14,22,27]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,MAPE_transition_gapped(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,MAPE_transition_gapped(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('MAPE (%)');
xlabel('Date Imputed');
legend('TranS R FwZ','TranS Y FwZ','TranS B FwZ')

subplot(3,1,3); hold on;
xaxis = [4,7,10,13,16]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,MAPE_baseline_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,MAPE_baseline_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('MAPE (%)');
xlabel('Date Imputed');
legend('BaseL R RFI','BaseL Y RFI','BaseL B RFI')
%%
%%
figure;
subplot(3,1,1); hold on;
xaxis = [4,9,14,22,27]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,R2_score_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,R2_score_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('R^{2} Score');
xlabel('Date Imputed');
legend('TranS R RFI','TranS Y RFI','TranS B RFI')

subplot(3,1,2); hold on;
xaxis = [4,9,14,22,27]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,R2_score_transition_gapped(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,R2_score_transition_gapped(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('R^{2} Score');
xlabel('Date Imputed');
legend('TranS R FwZ','TranS Y FwZ','TranS B FwZ')

subplot(3,1,3); hold on;
xaxis = [4,7,10,13,16]';
color = ['#D95319';'#EDB120';'#0000FF'];
for i = 1:3
    plot(xaxis,R2_score_transition_gapped(:,i),'.','MarkerSize',20,'Color',color(i,:));
    %plot(xaxis,MAPE_transition_imputed(:,i),'LineWidth',2,'Color',color(i,:));
end
for i = 1:3
    %plot(xaxis,MAPE_transition_imputed(:,i),'.','MarkerSize',20,'Color',color(i,:));
    plot(xaxis,R2_score_transition_gapped(:,i),'LineWidth',2,'Color',color(i,:));
end
hold off;
ylabel('R^{2} Score');
xlabel('Date Imputed');
legend('BaseL R RFI','BaseL Y RFI','BaseL B RFI')
%%
import_transition_data_gapped

infmt = 'dd/MM/yyyy HH:mm:ss.sss';
timeSpan = transition_gapped.Time(568+(7+1-2)*1440:568+(9+1+1-2)*1440-1);
timeSpan = datetime(timeSpan,'InputFormat',infmt);
timeSpan = timeSpan(end-1440+1:end);
%% Distribution of the Predicted Changes
numOfCPsRF = [];
cpListRF=zeros(18,20);
cpListRF(:,:)=nan;
numOfCPsGP = [];
cpListGP=zeros(18,20);
cpListGP(:,:)=nan;

timecpListRF = cpListGP;
timecpListGP = cpListGP;

for i = 1:20
    % R
    tcp_gap_transition_gappeds = predResults_transition_imputed_R_repeats(i).trend.cp;
    tcp_rfi_transition_gappeds = predResults_transition_gapped_R_repeats(i).trend.cp;
    scp_gap_transition_gappeds = predResults_transition_imputed_R_repeats(i).season.cp;
    scp_rfi_transition_gappeds = predResults_transition_gapped_R_repeats(i).season.cp;
    
    
    
    change_points_gap = sort(unique([tcp_gap_transition_gappeds;scp_gap_transition_gappeds]));
    change_points_gap = change_points_gap(~isnan(change_points_gap));
    
    change_points_rfi = sort(unique([tcp_rfi_transition_gappeds;scp_rfi_transition_gappeds]));
    change_points_rfi = change_points_rfi(~isnan(change_points_rfi));
    
   
    %cpListGP(i) = {change_points_rfi};
    numOfCPsGP(i) = length(change_points_gap);
    %cpListRF(i) = {change_points_gap};
    numOfCPsRF(i) = length(change_points_rfi);
    for j = 1:length(change_points_gap)
        cpListGP(j,i) = change_points_gap(j);
        timecpListGP(j,i) = change_points_gap(j);
    end

    for k = 1:length(change_points_rfi)
        cpListRF(k,i) = change_points_rfi(k);
        timecpListRF(k,i) = change_points_rfi(k);
    end
end

numOfCPsRF = numOfCPsRF';
numOfCPsGP = numOfCPsGP';

timecpListOld = timecpListGP;
timecpListGP = [];

k=0;
for i = 1:20
    for j = 1:18
        k=k+1;
        timecpListGP(k)=timecpListOld(j,i);
    end
end
timecpListGP = timecpListGP(~isnan(timecpListGP))';

timecpListOldRF = timecpListRF;
timecpListRF = [];


k=0;
for i = 1:20
    for j = 1:18
        k =k + 1;
        timecpListRF(k)=timecpListOldRF(j,i);
    end
end
timecpListRF = timecpListRF(~isnan(timecpListRF))';
%realtimeCpGP
%realtimeCpRF
for i = 1:length(timecpListGP)
    realtimeCpGP(i)=timeSpan(timecpListGP(i));
end

for i = 1:length(timecpListRF)
    realtimeCpRF(i)=timeSpan(timecpListRF(i));
end
%%
figure;
histogram(realtimeCpRF)
xlabel('Time in the Day');
ylabel('Amount of Change Point Occurances Predicted');
legend('CP Found Over Model Using RF Imputed data')

figure;
histogram(realtimeCpGP)
xlabel('Time in the Day');
ylabel('Amount of Change Point Occurances Predicted');
legend('CP Found Over Model Using Fill-with-Zeros data')

%%
figure;

subplot(2,1,1);
histogram(numOfCPsGP)
xlabel('Number of CP Found.');
ylabel('X number of times over 20 Repeats');

subplot(2,1,2);
histogram(numOfCPsRF)
xlabel('Number of CP Found.');
ylabel('X number of times over 20 Repeats');
