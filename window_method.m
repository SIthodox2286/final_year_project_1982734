clear
import_baseline_data_imputed
import_transition_data_imputed
rng('default');

%% Install app to path
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\CPD'))

%% Further Data Formulation
% Obtain Time
date = transition_data_imputed(:,'Time');
sheet = transition_data_imputed(:,'Sheet');
Time = table2array(date); % 

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

freqencies = [sheet date freqencies];

T = size(freqencies,1);
clear R_Frequency Y_Frequency B_frequency

%% Set up data for evaluation T = join(Tleft,Tright)
R_frequencies = getFreq(transition_data_imputed,'R_Frequency',567+(1+1-2)*1440,567+(34+1-2)*1440-1);
Y_frequencies = getFreq(transition_data_imputed,'Y_Frequency',567+(1+1-2)*1440,567+(34+1-2)*1440-1);
B_frequencies = getFreq(transition_data_imputed,'B_Frequency',567+(1+1-2)*1440,567+(34+1-2)*1440-1);

% Plot to test
%figure;
%subplot(3,1,1);
%plot(R_frequencies(:,1),R_frequencies(:,2));
%subplot(3,1,2);
%plot(Y_frequencies(:,1),Y_frequencies(:,2));
%subplot(3,1,3);
%plot(B_frequencies(:,1),B_frequencies(:,2));

%% Moving window of R on Y - Affine transition

moving_window = R_frequencies(1441:2880,:); % day 3
background_signal = Y_frequencies(1441-16:2880-16,:); % moving on the record of day 3
transformation_result = myCPD(background_signal,moving_window,'affine');

cpdOpjects = repmat(transformation_result,1,22);
N = 1;

for i = -15:5
    N = N + 1;
    background_signal = Y_frequencies(1441+i:2880+i,:); % moving on the record of day 3
    transformation_result = myCPD(background_signal,moving_window,'affine');
    cpdOpjects(N) = transformation_result;
end

%%
figure();
for i = 5:size(cpdOpjects,2)-12
    result1=cpdOpjects(i);
    transformation = result1.Y;
    subplot(6,1,i-4)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end

%%
figure();
for i = 10:size(cpdOpjects,2)-6
    result1=cpdOpjects(i);
    transformation = result1.Y;
    subplot(6,1,i-9)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end

%%
figure();
for i = 16:size(cpdOpjects,2)
    result1=cpdOpjects(i);
    transformation = result1.Y;
    subplot(7,1,i-15)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end

%% Non-rigid transition
moving_window = R_frequencies(1441:2880,:); % day 3
background_signal = Y_frequencies(1441-16:2880-16,:); % moving on the record of day 3
transformation_result = myCPD(background_signal,moving_window,'affine');

cpdOpjects_nonRigid = repmat(transformation_result,1,22);
N = 1;

for i = -15:5
    N = N + 1;
    background_signal = Y_frequencies(1441+i:2880+i,:); % moving on the record of day 3
    transformation_result = myCPD(background_signal,moving_window,'nonrigid');
    cpdOpjects_nonRigid(N) = transformation_result;
end

%%
figure();
for i = 5:size(cpdOpjects_nonRigid,2)-12
    result1=cpdOpjects_nonRigid(i);
    transformation = result1.Y;
    subplot(6,1,i-4)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end

%%
figure();
for i = 10:size(cpdOpjects_nonRigid,2)-6
    result1=cpdOpjects_nonRigid(i);
    transformation = result1.Y;
    subplot(6,1,i-9)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end

%%
figure();
for i = 16:size(cpdOpjects_nonRigid,2)
    result1=cpdOpjects_nonRigid(i);
    transformation = result1.Y;
    subplot(7,1,i-15)
    cpd_plot_iter(Y_frequencies(1441+(-16+i):2880+(-16+i),:), transformation);  
    title(['the window cut moving for: ' num2str(-17+i) ' mins']);
end
    %% R = Y - 15
figure
subplot(6,1,1)
plot(R_frequencies(1441:2880,1),R_frequencies(1441:2880,2),'ro');hold on;
plot(Y_frequencies(1441+0:2880+0,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+0 min match','FontSize',12)

subplot(6,1,2)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+10:2880+10,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+10 min match','FontSize',12)

subplot(6,1,3)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+20:2880+20,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+20 min match','FontSize',12)

subplot(6,1,4)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+30:2880+30,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+30 min match','FontSize',12)

subplot(6,1,5)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+40:2880+40,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+40 min match','FontSize',12)

subplot(6,1,6)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+50:2880+50,1),Y_frequencies(1441+20:2880+20,2),'b.');hold off;
title('+50 min match','FontSize',12)

%% R = B + 17
figure
subplot(6,1,1)
plot(R_frequencies(1441:2880,1),R_frequencies(1441:2880,2),'ro');hold on;
plot(Y_frequencies(1441-15:2880-15,1),Y_frequencies(1441-15:2880-15,2),'b.');hold off;
title('-16 min match','FontSize',12)

subplot(6,1,2)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441-30:2880-10,1),Y_frequencies(1441-30:2880-10,2),'b.');hold off;
title('-15 min match','FontSize',12)

subplot(6,1,3)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441-10:2880-10,1),Y_frequencies(1441-10:2880-10,2),'b.');hold off;
title('-12 min match','FontSize',12)

subplot(6,1,4)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441-0:2880-0,1),Y_frequencies(1441-0:2880-0,2),'b.');hold off;
title('-7 min match','FontSize',12)

subplot(6,1,5)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+15:2880+15,1),Y_frequencies(1441+15:2880+15,2),'b.');hold off;
title('-5 min match','FontSize',12)

subplot(6,1,6)
plot(moving_window(:,1),moving_window(:,2),'ro');hold on;
plot(Y_frequencies(1441+30:2880+30,1),Y_frequencies(1441+30:2880+30,2),'b.');hold off;
title('0 min match','FontSize',12)

%%
save cdpObjects