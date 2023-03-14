%% Import data from text file
clear;
import_transition_data_imputed

%% Obtain power information
transition_name = transition_data_imputed.Properties.VariableNames;
transition_data = table2array(transition_data_imputed(:,...
    transition_name(4:end)));
R_power_5_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'R_Real_Power_kW','Sheet','Time'});
R_power_5_day_all = R_power_5_day_all(R_power_5_day_all.Sheet>=30,:);
oldR_power_5_day = table2array(R_power_5_day_all(:,'R_Real_Power_kW'));

%% Plot amplitude and time
plot(oldR_power_5_day)
xlabel('Time (mins)')
ylabel('Amplitude of Power (kW)')

%% Test CWT
Fs = 1000;
t = linspace(0,5,5e3);
x = 2*cos(2*pi*100*t).*(t<1)+cos(2*pi*50*t).*(3<t)+0.3*randn(size(t));
plot(t,x)
xlabel('Time (s)')
ylabel('Amplitude')
cwt(x,Fs)

%% Quick Knn imputation Because RF takes 1hr+ to finish
dist1 = 'seuclidean';

transition_data = knnimpute(transition_data);
for i = 4:size(transition_data_imputed,2)
    name = transition_name(i);
    transition_data_imputed(:,name)=array2table(transition_data(:,i-3));
end

%%
R_power_5_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'R_Real_Power_kW','Sheet','Time'});
R_power_5_day_all = R_power_5_day_all(R_power_5_day_all.Sheet>=30,:);
R_power_5_day = table2array(R_power_5_day_all(:,'R_Real_Power_kW'));
Rdatearray = datetime(R_power_5_day_all.Time);

Y_power_5_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'Y_Real_Power_kW','Sheet','Time'});
Y_power_5_day_all = Y_power_5_day_all(Y_power_5_day_all.Sheet>=30,:);
Y_power_5_day = table2array(Y_power_5_day_all(:,'Y_Real_Power_kW'));
Ydatearray = datetime(Y_power_5_day_all.Time);

B_power_5_day_all = transition_data_imputed( ...
transition_data_imputed.Sheet<35,{'B_Real_Power_kW','Sheet','Time'});
B_power_5_day_all = B_power_5_day_all(B_power_5_day_all.Sheet>=30,:);
B_power_5_day = table2array(B_power_5_day_all(:,'B_Real_Power_kW'));
Bdatearray = datetime(B_power_5_day_all.Time);

figure;
plot(Rdatearray,R_power_5_day,'r.'); hold on;
plot(Rdatearray,oldR_power_5_day,'b.')
xlabel('Time (mins)')
ylabel('Amplitude of Power (kW)')
legend('Imputed','Raw-data')

R_power_5_day = timetable(Rdatearray,R_power_5_day);
Y_power_5_day = timetable(Ydatearray,Y_power_5_day);
B_power_5_day = timetable(Bdatearray,B_power_5_day);
%% Continuous Wavelet Analysis Over Power

fbR = cwtfilterbank(SignalLength=numel(R_power_5_day),SamplingFrequency=1/120);
figure
cwt(R_power_5_day,fbR);
title('CWT of Real Power measured at R in kW')
[cfsR,frqR] = cwt(R_power_5_day,fbR);
figure
subplot(2,1,1)
plot(Rdatearray,R_power_5_day.R_power_5_day)
axis tight
title("Power Signal and Scalogram at R")
xlabel("Time (date and time)")
ylabel("Amplitude")
subplot(2,1,2)
surface(Rdatearray,frqR,abs(cfsR))
axis tight
shading flat
xlabel("Time (date and time)")
ylabel("Frequency (Hz)")
set(gca,"yscale","log")

fbY = cwtfilterbank(SignalLength=numel(Y_power_5_day),SamplingFrequency=1/60);
figure
cwt(Y_power_5_day,fbY);
title('CWT of Real Power measured at Y in kW')
[cfsY,frqY] = cwt(Y_power_5_day,fbY);
figure
subplot(2,1,1)
plot(Ydatearray,Y_power_5_day.Y_power_5_day)
axis tight
title("Power Signal and Scalogram at Y")
xlabel("Time (date and time)")
ylabel("Amplitude")
subplot(2,1,2)
surface(Ydatearray,frqY,abs(cfsY))
axis tight
shading flat
xlabel("Time (date and time)")
ylabel("Frequency (Hz)")
set(gca,"yscale","log")

fbB = cwtfilterbank(SignalLength=numel(B_power_5_day),SamplingFrequency=1/60);
figure
cwt(B_power_5_day,fbB);
title('CWT of Real Power measured at B in kW')

[cfsB,frqB] = cwt(B_power_5_day,fbB);
figure
subplot(2,1,1)
plot(Bdatearray,B_power_5_day.B_power_5_day)
axis tight
title("Power Signal and Scalogram at B")
xlabel("Time (date and time)")
ylabel("Amplitude")
subplot(2,1,2)
surface(Bdatearray,frqB,abs(cfsB))
axis tight
shading flat
xlabel("Time (date and time)")
ylabel("Frequency (Hz)")
set(gca,"yscale","log")

%%
scaR = scales(fbR);
scaY = scales(fbY);
scaB = scales(fbB);

[~,idxR] = min(abs(scaR-1));
[~,idxY] = min(abs(scaY-1));
[~,idxB] = min(abs(scaB-1));

[psiR,tR] = wavelets(fbR);
[psiY,tY] = wavelets(fbY);
[psiB,tB] = wavelets(fbB);

mR = psiR(idxR,:);
mY = psiY(idxY,:);
mB = psiB(idxB,:);

figure;
subplot(3,1,1)
plot(tR,abs(mR))
grid on
hold on
plot(tR,real(mR))
plot(tR,imag(mR))
hold off
xlim([-2000 2000])
legend("abs(mR)","real(mR)","imag(mR)")
title("TimeBandwidth = R")

subplot(3,1,2)
plot(tY,abs(mY))
grid on
hold on
plot(tY,real(mY))
plot(tY,imag(mY))
hold off
xlim([-2000 2000])
legend("abs(mY)","real(mY)","imag(mY)")
title("TimeBandwidth = Y")

subplot(3,1,3)
plot(tB,abs(mB))
grid on
hold on
plot(tB,real(mB))
plot(tB,imag(mB))
hold off
xlim([-2000 2000])
legend("abs(mB)","real(mB)","imag(mB)")
title("TimeBandwidth = B")
