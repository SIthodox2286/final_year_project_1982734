%% Import Data
clear;
import_transition_data_gapped
import_baseline_data_gapped
import_transition_data_imputed
%%
time = transition_gapped.Time;

%%
R_frequencies = transition_gapped.R_Frequency;
Y_frequencies = transition_gapped.Y_Frequency;
B_frequencies = transition_gapped.B_Frequency;
%%
figure();
subplot(2,2,1);
qqplot(R_frequencies(1441:2880),Y_frequencies(1441-15:2880-15)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Quantile-Quantile Plot of Unimputed Y(t) against R(t-15), 1440 mins, starting from day 00:00 Day 2')

%subplot(2,2,2);
%qqplot(R_frequencies(1441:7767),Y_frequencies(1441-15:7767-15)); grid on;
%xlabel('R Frequencies');
%ylabel('Y Frequencies');
%title('Quantile-Quantile Plot of Unimputed Y(t) against R(t-15), for four days')

subplot(2,2,2);
qqplot(R_frequencies(1441:2880),Y_frequencies(1441:2880)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Quantile-Quantile Plot of Unimputed Y(t) against R(t), 1440 mins, starting from day 00:00 Day 2')

subplot(2,2,3);
qqplot(R_frequencies((1441+600):(2880+600)),Y_frequencies(1441+600-15:2880+600-15)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Quantile-Quantile Plot of Unimputed Y(t) against R(t-15), 1440 mins, starting from 10AM day 2')

subplot(2,2,4);
qqplot(R_frequencies(1+15:end),Y_frequencies(1:end-15)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Quantile-Quantile Plot of Unimputed Y(t) against R(t-15), complete data set')

%%
figure();
subplot(2,2,1);
scatter(R_frequencies(1441:2880),Y_frequencies((1441-15):(2880-15))); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against R(t-15), 1440 mins, starting from day 00:00 Day 2')

subplot(2,2,2);
scatter(R_frequencies(1441:2880),Y_frequencies(1441:2880)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against R(t), 1440 mins, starting from day 00:00 Day 2')

subplot(2,2,3);
scatter(R_frequencies(1441+600:2880+600),Y_frequencies(1441+600-15:2880+600-15)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against R(t-15), 1440 mins, starting from 10AM day 2')

subplot(2,2,4);
scatter(R_frequencies(1+15:end),Y_frequencies(1:end-15)); grid on;
xlabel('R Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against R(t-15), complete data set')

%%
figure();
subplot(2,2,1);
scatter(B_frequencies(1441:2880),Y_frequencies((1441-32):(2880-32))); grid on;
xlabel('B Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against B(t-32), 1440 mins, starting from day 00:00 Day 2')

subplot(2,2,2);
scatter(B_frequencies(1441:2880),Y_frequencies(1441:2880)); grid on;
xlabel('B Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against B(t), 1440 mins, starting from day 00:00 Day 2')

subplot(2,2,3);
scatter(B_frequencies(1441+600:2880+600),Y_frequencies(1441+600-32:2880+600-32)); grid on;
xlabel('B Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against B(t-32), 1440 mins, starting from 10AM day 2')

subplot(2,2,4);
scatter(B_frequencies(1+32:end),Y_frequencies(1:end-32)); grid on;
xlabel('B Frequencies');
ylabel('Y Frequencies');
title('Scatter Plot of Unimputed Y(t) against B(t-32), complete data set')

%% Find the correlative time point
differences = zeros(1,2880);
value = -1440:1440;

beginTime = 1441+100;
endTime = 2880+100;

for d = -1440:1440
    differences(d+1441) = abs(sum(R_frequencies(beginTime:endTime)-Y_frequencies((beginTime-d):(endTime-d))));
end

differences_RY = [differences',value'];
mismatch_RY = value(min(find(differences==min(differences))));
%
differences = zeros(1,2880);
value = -1440:1440;
for d = -1440:1440
    differences(d+1441) = abs(sum(R_frequencies(beginTime:endTime)-B_frequencies((beginTime-d):(endTime-d))));
end

differences_RB = [differences',value'];
mismatch_RB = value(min(find(differences==min(differences))));

differences = zeros(1,2880);
value = -1440:1440;
for d = -1440:1440
    differences(d+1441) = abs(sum(Y_frequencies(beginTime:endTime)-B_frequencies((beginTime-d):(endTime-d))));
end

differences_YB = [differences',value'];
mismatch_YB = value(min(find(differences==min(differences))));

figure();
subplot(2,2,1)
qqplot(R_frequencies(beginTime:endTime),Y_frequencies((beginTime-mismatch_RY):(endTime-mismatch_RY)))
xlabel('R Quantiles');
ylabel('Y Quantiles');

subplot(2,2,2)
qqplot(R_frequencies(beginTime:endTime),B_frequencies((beginTime-mismatch_RB):(endTime-mismatch_RB)))
xlabel('R Quantiles');
ylabel('B Quantiles');

subplot(2,2,3)
qqplot(Y_frequencies(beginTime:endTime),B_frequencies((beginTime-mismatch_YB):(endTime-mismatch_YB)))
xlabel('Y Quantiles');
ylabel('B Quantiles');

figure();
subplot(2,2,1)
scatter(R_frequencies(beginTime:endTime),Y_frequencies((beginTime-mismatch_RY):(endTime-mismatch_RY)))
xlabel('R Frequencies');
ylabel('Y Frequencies');
subplot(2,2,2)
scatter(R_frequencies(beginTime:endTime),B_frequencies((beginTime-mismatch_RB):(endTime-mismatch_RB)))
xlabel('R Frequencies');
ylabel('B Frequencies');
subplot(2,2,3)
scatter(Y_frequencies(beginTime:endTime),B_frequencies((beginTime-mismatch_YB):(endTime-mismatch_YB)))
xlabel('Y Frequencies');
ylabel('B Frequencies');
%% Find the correlative time point

timepoints = [];
for n = 3:33
    sheet = transition_gapped(transition_gapped.Sheet==n,:);
    begineTime = find(transition_gapped.RECORD == sheet.RECORD(1));
    timepoints(n-2)=begineTime;
end
timepoints = timepoints';
%

mismatch_sets = zeros(length(timepoints),13);

%
R_frequencies = transition_gapped.R_Frequency;
Y_frequencies = transition_gapped.Y_Frequency;
B_frequencies = transition_gapped.B_Frequency;

%newR_frequencies(find(R_frequencies==0))=mean(R_frequencies);
%newY_frequencies(find(Y_frequencies==0))=mean(Y_frequencies);
%newB_frequencies(find(B_frequencies==0))=mean(B_frequencies);

for i = 1:size(timepoints)
    differences = zeros(1,2880);
    value = -1440:1440;
    beginTime = timepoints(i);
    endTime = beginTime+1440-1;
    
    for d = -1440:1440
        differences(d+1441) = abs(sum(R_frequencies(beginTime:endTime)-Y_frequencies((beginTime+d):(endTime+d))));
    end

    differences_RY = [differences',value'];
    mismatch_RY = value(find(differences==min(differences)));
    mismatch_RY = min(mismatch_RY); % mismatch_i, not all the values
    %
    differences = zeros(1,2880);
    value = -1440:1440;
    for d = -1440:1440
        differences(d+1441) = abs(sum(R_frequencies(beginTime:endTime)-B_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_RB = [differences',value'];
    mismatch_RB = value(find(differences==min(differences)));
    mismatch_RB = min(mismatch_RB);

    differences = zeros(1,2880);
    value = -1440-mismatch_RY:1440-mismatch_RY;
    for d = -1440:1440
        differences(d+1441) = abs(sum(Y_frequencies(beginTime+mismatch_RY:endTime+mismatch_RY)-B_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_YB = [differences',value'];
    mismatch_YB = value(find(differences==min(differences)));
    mismatch_YB = min(mismatch_YB);

    differences = zeros(1,2880);
    value = -1440-mismatch_RB:1440-mismatch_RB;
    for d = -1440:1440
        differences(d+1441) = abs(sum(B_frequencies(beginTime+mismatch_RB:endTime+mismatch_RB)-Y_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_BY = [differences',value'];
    mismatch_BY = value(find(differences==min(differences)));
    mismatch_BY = min(mismatch_BY);
    
    % Relative to R
    mismatch_sets(i,1) = mismatch_RY;
    mismatch_sets(i,2) = mismatch_RB;
    mismatch_sets(i,3) = mismatch_YB;
    mismatch_sets(i,4) = mismatch_BY;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Following part of the codes calculate the relative frequencies mismatch from the
    % Y's perspective. 

    % SlidingYonR
    differences = zeros(1,2880);
    value = -1440:1440;
    for d = -1440:1440
        differences(d+1441) = abs(sum(Y_frequencies(beginTime:endTime)-R_frequencies((beginTime+d):(endTime+d))));
    end
   
    differences_YR = [differences',value'];
    mismatch_YR = value(find(differences==min(differences)));
    mismatch_YR = min(mismatch_YR);
    
    % SlidingYonB
    differences = zeros(1,2880);
    value = -1440:1440;
    for d = -1440:1440
        differences(d+1441) = abs(sum(Y_frequencies(beginTime:endTime)-B_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_YB2 = [differences',value'];
    mismatch_YB2 = value(find(differences==min(differences)));
    mismatch_YB2 = min(mismatch_YB2);
    
    % CheckYusingRB
    differences = zeros(1,2880);
    value = -1440-mismatch_YR:1440-mismatch_YR;

    for d = -1440:1440
        differences(d+1441) = abs(sum(R_frequencies(beginTime+mismatch_YR:endTime+mismatch_YR)-B_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_RB2 = [differences',value'];
    mismatch_RB2 = value(find(differences==min(differences)));
    mismatch_RB2 = min(mismatch_RB2);
    
    % CheckYusingBR
    differences = zeros(1,2880);
    value = -1440-mismatch_YB2:1440-mismatch_YB2;

    for d = -1440:1440
        differences(d+1441) = abs(sum(B_frequencies(beginTime+mismatch_YB2:endTime+mismatch_YB2)-R_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_BR = [differences',value'];
    mismatch_BR = value(find(differences==min(differences)));
    mismatch_BR = min(mismatch_BR);
    
    % Relative to Y
    mismatch_sets(i,5) = mismatch_YR;
    mismatch_sets(i,6) = mismatch_YB2;
    mismatch_sets(i,7) = mismatch_RB2;
    mismatch_sets(i,8) = mismatch_BR;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Following part of the codes calculate the relative frequencies mismatch from the
    % B's perspective. 

    % SlidingBonR
    differences = zeros(1,2880);
    value = -1440:1440;
    for d = -1440:1440
        differences(d+1441) = abs(sum(B_frequencies(beginTime:endTime)-R_frequencies((beginTime+d):(endTime+d))));
    end

    differences_BR2 = [differences',value'];
    mismatch_BR2 = value(find(differences==min(differences)));
    mismatch_BR2 = min(mismatch_BR2);
    
    % SlidingBonY
    differences = zeros(1,2880);
    value = -1440:1440;
    for d = -1440:1440
        differences(d+1441) = abs(sum(B_frequencies(beginTime:endTime)-Y_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_BY2 = [differences',value'];
    mismatch_BY2 = value(find(differences==min(differences)));
    mismatch_BY2 = min(mismatch_BY2);
    
    % CheckBusingRY
    differences = zeros(1,2880);
    value = -1440-mismatch_BR2:1440-mismatch_BR2;

    for d = -1440:1440
        differences(d+1441) = abs(sum(R_frequencies(beginTime+mismatch_BR2:endTime+mismatch_BR2)-Y_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_RY2 = [differences',value'];
    mismatch_RY2 = value(find(differences==min(differences)));
    mismatch_RY2 = min(mismatch_RY2);
    
    % CheckBusingYR
    differences = zeros(1,2880);
    value = -1440-mismatch_BY2:1440-mismatch_BY2;

    for d = -1440:1440
        differences(d+1441) = abs(sum(Y_frequencies(beginTime+mismatch_BY2:endTime+mismatch_BY2)-R_frequencies((beginTime+d):(endTime+d))));
    end
    
    differences_YR2 = [differences',value'];
    mismatch_YR2 = value(find(differences==min(differences)));
    mismatch_YR2 = min(mismatch_YR2);
    
    % Relative to B
    mismatch_sets(i,9) = mismatch_BR2;
    mismatch_sets(i,10) = mismatch_BY2;
    mismatch_sets(i,11) = mismatch_RY2;
    mismatch_sets(i,12) = mismatch_YR2;

    %
    mismatch_sets(i,13) = beginTime;
end
mismatchTable = array2table(mismatch_sets);
mismatchTable = renamevars(mismatchTable,["mismatch_sets1","mismatch_sets2","mismatch_sets3","mismatch_sets4","mismatch_sets5","mismatch_sets6","mismatch_sets7","mismatch_sets8"], ...
                 ["SlidingRonY","SlidingRonB","CheckRusingYB","CheckRusingBY","SlidingYonR","SlidingYonB","CheckYusingRB","CheckYusingBR"]);
mismatchTable = renamevars(mismatchTable,["mismatch_sets9","mismatch_sets10","mismatch_sets11","mismatch_sets12","mismatch_sets13"], ...
                 ["SlidingBonR","SlidingBonY","CheckBusingRY","CheckBusingYR","WindowBeginPoints"]);

%% Figure
displacementsMismatchR = (mismatch_sets(:,2)-mismatch_sets(:,1))-mismatch_sets(:,3);
figure();
bar(displacementsMismatchR);
xlabel('n^{th} Day')
ylabel('Mismatch Distance relative to R')

displacementsMismatchY = (mismatch_sets(:,5)-mismatch_sets(:,6))-mismatch_sets(:,8);
figure();
bar(displacementsMismatchY);
xlabel('n^{th} Day')
ylabel('Mismatch Distance relative to Y')

displacementsMismatchB = (mismatch_sets(:,9)-mismatch_sets(:,10))-mismatch_sets(:,12);
figure();
bar(displacementsMismatchB);
xlabel('n^{th} Day')
ylabel('Mismatch Distance relative to B')

displacementsMismatchR(find(abs(displacementsMismatchR)==1))=0;
%

figure();
abnormaldays = [length(find(displacementsMismatchR==0)),length(find(displacementsMismatchR~=0))];
names = categorical({'Matching Days','Unmatching Days'});
%names = reordercats(abnormaldays,{'Matching Days','Unmatching Days'});
bar(names,[length(find(displacementsMismatchR==[0,1])),length(find(displacementsMismatchR~=0))]);
%%
beginTimeList = zeros(31,2);
mismatch_YR_list = zeros(31,2);

for i = 1:size(timepoints)
    beginTime = timepoints(i)+mismatchTable.RY(i);
    endTime = beginTime+1440-1;

    beginTimeList(i,1)=beginTime;
    beginTimeList(i,2)=timepoints(i);

    differences = zeros(1,2880);
    value = -1440:1440;

    for d = -1440:1440
        differences(d+1441) = abs( ...
            sum(Y_frequencies(beginTime:endTime)- ...
            R_frequencies((beginTime+d):(endTime+d))) ...
            );
    end

    differences_YR = [differences',value'];
    mismatch_YR = value(find(differences==min(differences)));
    mismatch_YR = min(mismatch_YR(:,1));
    mismatch_YR_list(i,1) = mismatch_YR;
end

mismatch_YR_list(:,2) = mismatchTable.RY;


%%
i = 7;
beginTime = timepoints(i);
endTime = beginTime+1440-1;
currentR = R_frequencies(beginTime:endTime);
currentY = Y_frequencies(beginTime+mismatch_sets(i,1):endTime+mismatch_sets(i,1));
currentB = B_frequencies(beginTime+mismatch_sets(i,2):endTime+mismatch_sets(i,2));
figure()
scatter(currentY,currentB)

i = 10;
beginTime = timepoints(i);
endTime = beginTime+1440-1;
currentR = R_frequencies(beginTime:endTime);
currentY = Y_frequencies(beginTime+mismatch_sets(i,1):endTime+mismatch_sets(i,1));
currentB = B_frequencies(beginTime+mismatch_sets(i,2):endTime+mismatch_sets(i,2));
figure()
scatter(currentY,currentB)

i = 4;
beginTime = timepoints(i);
endTime = beginTime+1440-1;
currentR = R_frequencies(beginTime:endTime);
currentY = Y_frequencies(beginTime+mismatch_sets(i,1):endTime+mismatch_sets(i,1));
currentB = B_frequencies(beginTime+mismatch_sets(i,2)-mismatch_sets(i,3):endTime+mismatch_sets(i,2)-mismatch_sets(i,3));
figure()
scatter(currentY,currentB)

i = 8;
beginTime = timepoints(i);
endTime = beginTime+1440-1;
currentR = R_frequencies(beginTime:endTime);
currentY = Y_frequencies(beginTime+mismatch_sets(i,1):endTime+mismatch_sets(i,1));
currentB = B_frequencies(beginTime+mismatch_sets(i,2)-mismatch_sets(i,3):endTime+mismatch_sets(i,2)-mismatch_sets(i,3));
figure()
scatter(currentY,currentB)

