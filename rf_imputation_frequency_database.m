function [imputed_data] = rf_imputation_frequency_database(original_data)
    %% RF imputation of Transition data
    %% RF imputation preparation - transition
    size_count = size(original_data);
    sprintf('Imputing Data of size %d',size_count(1))
    
    dataToimpute = original_data(:, ...
        setdiff(original_data.Properties.VariableNames,...
        {'Sheet','Time','RECORD'},'stable'));
    imputed_data = original_data;
    
    transition_name = original_data.Properties.VariableNames;
    
    tmp = templateTree('Surrogate','on','Reproducible',true);
    
    %% RF imputation of R_frequency
    
    missing_R_frequency = ismissing(dataToimpute.R_Frequency);
    
    % Fit ensemble of regression learners
    rf_Rfrequency = fitrensemble(dataToimpute,'R_Frequency','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name( ...
        find(~contains(transition_name,{'Sheet','Time','RECORD','R_Frequency'}))));
    imputed_data.R_Frequency(missing_R_frequency) = predict( ...
        rf_Rfrequency,...
        dataToimpute(missing_R_frequency,:));

    sprintf('Imputed R_frequency')
    
    %% RF imputation of Y_frequency
    missing_Y_frequency = ismissing(dataToimpute.Y_Frequency);
    
    %% Fit ensemble of classification learners
    rf_Yfrequency = fitcensemble(dataToimpute,'Y_Frequency','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name(find(~contains( ...
        transition_name,{'Sheet','Time','RECORD','R_Frequency','Y_Frequency'}))));
    %%
    imputed_data.Y_Frequency(missing_Y_frequency) = predict( ...
        rf_Yfrequency,...
        dataToimpute(missing_Y_frequency,:));

    sprintf('Imputed Y_frequency')
    
    %% RF imputation of B_frequency
    missing_B_frequency = ismissing(dataToimpute.B_Frequency);
    % Fit ensemble of classification learners
    rf_Bfrequency = fitcensemble(dataToimpute,'B_Frequency','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name(find(~contains( ...
        transition_name,{'Sheet','Time','RECORD', ...
        'R_Frequency','Y_Frequency','B_Frequency'}))));
    imputed_data.B_Frequency(missing_B_frequency) = predict( ...
        rf_Bfrequency,...
        dataToimpute(missing_B_frequency,:));

    sprintf('Imputed B_frequency')
    
    %%
    clear tmp
    tmp = templateTree('Surrogate','on','Reproducible',true);
    %% RF imputation of R Power
    missing_R_powerkw = ismissing(dataToimpute.R_Real_Power_kW);
    % Fit ensemble of classification learners
    rf_RPower = fitcensemble(dataToimpute,'R_Real_Power_kW','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name(find(~contains( ...
        transition_name,{'Sheet','Time','RECORD', ...
        'R_Real_Power_kW'}))));
    imputed_data.R_Real_Power_kW(missing_R_powerkw) = predict( ...
        rf_RPower,...
        dataToimpute(missing_R_powerkw,:));

    sprintf('Imputed R_Real_Power_kW')

    %% RF imputation of Y Power
    missing_Y_powerkw = ismissing(dataToimpute.Y_Real_Power_kW);
    % Fit ensemble of classification learners
    rf_YPower = fitcensemble(dataToimpute,'R_Real_Power_kW','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name(find(~contains( ...
        transition_name,{'Sheet','Time','RECORD', ...
        'R_Real_Power_kW', ...
        'Y_Real_Power_kW'}))));
    imputed_data.Y_Real_Power_kW(missing_Y_powerkw) = predict( ...
        rf_YPower,...
        dataToimpute(missing_Y_powerkw,:));

    sprintf('Imputed Y_Real_Power_kW')

    %% RF imputation of B Power
    missing_B_powerkw = ismissing(dataToimpute.B_Real_Power_kW);
    % Fit ensemble of classification learners
    rf_BPower = fitcensemble(dataToimpute,'R_Real_Power_kW','Method','Bag',...
        'NumLearningCycles',5,'Learners',tmp,'CategoricalPredictors',...
        transition_name(find(~contains( ...
        transition_name,{'Sheet','Time','RECORD', ...
        'R_Real_Power_kW', ...
        'Y_Real_Power_kW','B_Real_Power_kW'}))));
    imputed_data.B_Real_Power_kW(missing_B_powerkw) = predict( ...
        rf_BPower,...
        dataToimpute(missing_B_powerkw,:));

    sprintf('Imputed B_Real_Power_kW')
end
