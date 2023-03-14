import_baseline_data_script
import_transition_data_script
import_transition_data_gapped
import_baseline_data_gapped
import_transition_data_imputed
import_baseline_data_imputed

%%
rf_r = transition_data_imputed.R_Frequency;
gapped_r = transition_gapped.R_Frequency;
time = datetime(transition_data_imputed.Time);

figure;
subplot(2,1,1);
plot(time,rf_r,'r.');
ylim([0 max(rf_r)+10])
legend('Transition R Frequency Imputed by Random Forest');

subplot(2,1,2);
plot(time,gapped_r,'b.');
legend('Transition R Frequency Imputed by Fill with Zeros');

%% SK Transition
display(skewness(transition_gapped.R_Frequency))
display(skewness(transition_data_imputed.R_Frequency))
display(skewness(transition_data_unprocessed.R_Frequency))

%% SK Baseline
display(skewness(baseline_gapped.R_Frequency))
display(skewness(baseline_data_imputed.R_Frequency))
display(skewness(baseline_data_unprocessed.R_Frequency))

%% std Transition
display(std(transition_gapped.R_Frequency))
display(std(transition_data_imputed.R_Frequency))
display(std(transition_data_unprocessed.R_Frequency))

%% std Baseline
display(std(baseline_gapped.R_Frequency))
display(std(baseline_data_imputed.R_Frequency))
display(std(baseline_data_unprocessed.R_Frequency))







