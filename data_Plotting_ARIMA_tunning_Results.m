load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_B_baseline_gapped.mat
load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_B_transition_gapped.mat
load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_R_baseline_gapped.mat
load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_R_transition_gapped.mat
load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_Y_baseline_gapped.mat
load dataIncluded\'ARIMAforFillwithZero(Gapped)'\MSETable_Y_transition_gapped.mat

MSETable_B_transition_gapped = MSETableB;
MSETable_Y_transition_gapped = MSETable;
MSETable_R_transition_gapped = MSETableR;


load dataIncluded\'ARIMA for Imputed'\MSETable_B_baseline_Imputed.mat
load dataIncluded\'ARIMA for Imputed'\MSETable_B_transition_Imputed.mat
load dataIncluded\'ARIMA for Imputed'\MSETable_R_baseline_Imputed.mat
load dataIncluded\'ARIMA for Imputed'\MSETable_R_transition_Imputed.mat
load dataIncluded\'ARIMA for Imputed'\MSETable_Y_baseline_imputed.mat
load dataIncluded\'ARIMA for Imputed'\MSETable_Y_transition_imputed.mat

MSETableY = MSETable;

daycount_transition = [2,5,10,15,20,25,30];
daycount_baseline = [2,5,10,15,19];

figure;
subplot(2,2,1)
hold on;

subtitle('Baseline Data RF Imputed','FontSize',16,'FontWeight','bold');

plot(daycount_baseline,MSETable_R_baseline_Imputed,'ro','MarkerSize',10);
plot(daycount_baseline,MSETable_Y_baseline_imputed,'o',"Color","#EDB120",'MarkerSize',10);
plot(daycount_baseline,MSETable_B_baseline_Imputed,'bo','MarkerSize',10);

plot(daycount_baseline,MSETable_R_baseline_Imputed,'r-','MarkerSize',2);
plot(daycount_baseline,MSETable_Y_baseline_imputed,'-',"Color","#EDB120",'MarkerSize',2);
plot(daycount_baseline,MSETable_B_baseline_Imputed,'b-','MarkerSize',2);

legend('Baseline R','Baseline Y','Baseline B')

xlabel('Length of Training data (days)')
ylabel('MAPE (%)')

hold off;

subplot(2,2,2)

hold on;

subtitle('Transition Data RF Imputed','FontSize',16,'FontWeight','bold');

plot(daycount_transition,MSETableR,'ro','MarkerSize',10);
plot(daycount_transition,MSETableY,'o',"Color","#EDB120",'MarkerSize',10);
plot(daycount_transition,MSETableB,'bo','MarkerSize',10);

plot(daycount_transition,MSETableR,'r-','MarkerSize',2);
plot(daycount_transition,MSETableY,'-',"Color","#EDB120",'MarkerSize',2);
plot(daycount_transition,MSETableB,'b-','MarkerSize',2);

xlabel('Length of Training data (days)')
ylabel('MAPE (%)')

legend('Transition R','Transition Y','Transition B')

hold off;

subplot(2,2,3)

hold on;

subtitle('Baseline Data Fill with Zeros','FontSize',16,'FontWeight','bold');

plot(daycount_baseline,MSETable_R_baseline_gapped,'ro','MarkerSize',10);
plot(daycount_baseline,MSETable_Y_baseline_gapped,'o',"Color","#EDB120",'MarkerSize',10);
plot(daycount_baseline,MSETable_B_baseline_gapped,'bo','MarkerSize',10);

plot(daycount_baseline,MSETable_R_baseline_gapped,'r-','MarkerSize',2);
plot(daycount_baseline,MSETable_Y_baseline_gapped,'-',"Color","#EDB120",'MarkerSize',2);
plot(daycount_baseline,MSETable_B_baseline_gapped,'b-','MarkerSize',2);

legend('Baseline R','Baseline Y','Baseline B','Location','north')
xlabel('Length of Training data (days)')
ylabel('MAPE (%)')

hold off;

subplot(2,2,4)

hold on;
subtitle('Transition Fill with Zeros','FontSize',16,'FontWeight','bold');

plot(daycount_transition,MSETable_R_transition_gapped,'ro','MarkerSize',10);
plot(daycount_transition,MSETable_Y_transition_gapped,'o',"Color","#EDB120",'MarkerSize',12);
plot(daycount_transition,MSETable_B_transition_gapped,'bo','MarkerSize',10);

plot(daycount_transition,MSETable_R_transition_gapped,'r-','MarkerSize',2);
plot(daycount_transition,MSETable_Y_transition_gapped,'-',"Color","#EDB120",'LineWidth',3);
plot(daycount_transition,MSETable_B_transition_gapped,'b-','MarkerSize',2);

legend('Transition R','Transition Y','Transition B','Location','north')
xlabel('Length of Training data (days)')
ylabel('MAPE (%)')

hold off;
