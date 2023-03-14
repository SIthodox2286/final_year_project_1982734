%% Import Data
clear;
import_transition_data_gapped
import_baseline_data_gapped
import_transition_data_imputed
import_baseline_data_imputed
%%
addpath(genpath('D:\Users\ediso\Desktop\Technical Projects\MatlabProcessing\CPD'))
time = transition_gapped.Time;
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
%%
display(skewness(transition_gapped.R_Frequency))
display(skewness(transition_data_imputed.R_Frequency))

display(skewness(baseline_gapped.R_Frequency))
display(skewness(baseline_data_imputed.R_Frequency))

display(skewness(baseline_gapped.Y_Frequency))
display(skewness(baseline_data_imputed.Y_Frequency))

MB1 = [skewness(baseline_gapped.R_Frequency),...
    skewness(baseline_gapped.Y_Frequency),skewness(baseline_gapped.B_Frequency)];

MB2 = [skewness(baseline_data_imputed.R_Frequency),...
    skewness(baseline_data_imputed.Y_Frequency),skewness(baseline_data_imputed.B_Frequency)];

MT1 = [skewness(transition_gapped.R_Frequency),...
    skewness(transition_gapped.Y_Frequency),skewness(transition_gapped.B_Frequency)];

MT2 = [skewness(transition_data_imputed.R_Frequency),...
    skewness(transition_data_imputed.Y_Frequency),skewness(transition_data_imputed.B_Frequency)];

mean_baseline_skew_diff = mean(MB1-MB2)
mean_transition_skew_diff = mean(MT1-MT2)

MTT2 = [abs(MB2(1)-MB2(2)),abs(MB2(1)-MB2(3)),abs(MB2(3)-MB2(2))];

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

%% Demonstration of Sliding
beginTime1 = timepoints(1);
endTime1 = beginTime1+1440-1;
beginTime2 = timepoints(3);
endTime2 = beginTime2+1440-1;
beginTime3 = timepoints(5);
endTime3 = beginTime3+1440-1;
timeT = 1:length(B_frequencies);
figure; 
subplot(3,1,1); 
hold on;


plot(time(1:endTime3+100),B_frequencies(1:endTime3+100),'b.');
plot(time(beginTime1:endTime1),R_frequencies(beginTime2:endTime2),'ro')
plot(time(beginTime1:endTime1),B_frequencies(beginTime1:endTime1),'gx')
hold off;
legend('B-Frequency','R-Frequency Window','Windowed B-Frequency')

ylabel("Frequency")
subplot(3,1,2);
hold on;



plot(time(1:endTime3+100),B_frequencies(1:endTime3+100),'b.');
plot(time(beginTime2:endTime2),R_frequencies(beginTime2:endTime2),'ro')
plot(time(beginTime2:endTime2),B_frequencies(beginTime2:endTime2),'gx')
hold off;
legend('B-Frequency','R-Frequency Window','Windowed B-Frequency')

ylabel("Frequency")
subplot(3,1,3);
hold on;


plot(time(1:endTime3+100),B_frequencies(1:endTime3+100),'b.');
plot(time(beginTime3:endTime3),R_frequencies(beginTime2:endTime2),'ro')
plot(time(beginTime3:endTime3),B_frequencies(beginTime3:endTime3),'gx')
legend('B-Frequency','R-Frequency Window','Windowed B-Frequency')
xlabel('Dates in Transition Period')
ylabel("Frequency")
hold off;
%%
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
%%
mismatchTable_ABS_Transition = mismatchTable;
save('dataIncluded\ABS_Transition_mismatch.mat','mismatchTable_ABS_Transition');

%% SET = [order R, order Y, order B] , find the order of the frequencies
%ORDER = appear 1st ---> 2nd ---> 3rd
orderSetR=[];
orderSetY=[];
orderSetB=[];

orderset = [];

for i = 1:31
    RY = mismatchTable.SlidingRonY(i);
    RB = mismatchTable.SlidingRonB(i);

    if RY > RB 
        if and(RY>0,RB>0)     % R B Y
            orderSetR(i,:) = [1,3,2];
        elseif and(RY>0,RB<0) % B R Y
            orderSetR(i,:) = [2,3,1];
        else                  % B Y R
            orderSetR(i,:) = [3,2,1];
        end
    elseif RY < RB
        if and(RY>0,RB>0)     % R Y B
            orderSetR(i,:) = [1,2,3];
        elseif and(RY<0,RB>0) % Y R B
            orderSetR(i,:) = [2,1,3];
        else                  % Y B R
            orderSetR(i,:) = [3,1,2];
        end
    else % RY == RB
        if RY > 0       % R Y=B
            orderSetR(i,:) = [1,0,0];
        elseif RY <0    % Y=B R
            orderSetR(i,:) = [3,0,0];
        else % RY == 0  % R=Y=B
            orderSetR(i,:) = [0,0,0];
        end
    end

    YR = mismatchTable.SlidingYonR(i);
    YB = mismatchTable.SlidingYonB(i);

    if YR > YB 
        if and(YR>0,YB>0)     % Y B R
            orderSetY(i,:) = [3,1,2];
        elseif and(YR>0,YB<0) % B Y R
            orderSetY(i,:) = [3,2,1];
        else                  % B R Y
            orderSetY(i,:) = [2,3,1];
        end
    elseif YR < YB
        if and(YR>0,YB>0)     % Y R B
            orderSetY(i,:) = [2,1,3];
        elseif and(YR<0,YB>0) % R Y B
            orderSetY(i,:) = [1,2,3];
        else %and(YR<0,YB<0)  % R B Y
            orderSetY(i,:) = [1,3,2];
        end
    else % YR == YB
        if YR > 0       % Y R=B
            orderSetY(i,:) = [0,1,0];
        elseif YR <0    % R=B Y
            orderSetY(i,:) = [0,3,0];
        else % RY == 0  % R=Y=B
            orderSetY(i,:) = [0,0,0];
        end
    end

    BR = mismatchTable.SlidingBonR(i);
    BY = mismatchTable.SlidingBonY(i);
    
    if BR > BY
        if and(BR>0,BY>0)       % B Y R
            orderSetB(i,:) = [3,2,1];
        elseif and(BR>0,BY<0)   % Y B R
            orderSetB(i,:) = [3,1,2];
        else %and(BR<0,BY<0)    % Y R B
            orderSetB(i,:) = [2,1,3];
        end
    elseif BR < BY
        if and(BR>0,BY>0)       % B R Y
            orderSetB(i,:) = [2,3,1];
        elseif and(BR<0,BY>0)   % R B Y
            orderSetB(i,:) = [1,3,2];
        else %and(BR<0,BY<0)    % R Y B
            orderSetB(i,:) = [1,2,3];
        end
    else % BR == BY
        if BR > 0       % B Y=R
            orderSetB(i,:) = [0,0,1];
        elseif BR <0    % Y=R B
            orderSetB(i,:) = [0,0,3];
        else % RY == 0  % R=Y=B
            orderSetB(i,:) = [0,0,0];
        end
    end
end

Rat1inR = length(find(orderSetR(:,1)==1));
Rat2inR = length(find(orderSetR(:,1)==2));
Rat3inR = length(find(orderSetR(:,1)==3));
Rat0inR = length(find(orderSetR(:,1)==0));

Rat1inY = length(find(orderSetY(:,1)==1));
Rat2inY = length(find(orderSetY(:,1)==2));
Rat3inY = length(find(orderSetY(:,1)==3));
Rat0inY = length(find(orderSetY(:,1)==0));

Rat1inB = length(find(orderSetB(:,1)==1));
Rat2inB = length(find(orderSetB(:,1)==2));
Rat3inB = length(find(orderSetB(:,1)==3));
Rat0inB = length(find(orderSetB(:,1)==0));

Yat1inR = length(find(orderSetR(:,2)==1));
Yat2inR = length(find(orderSetR(:,2)==2));
Yat3inR = length(find(orderSetR(:,2)==3));
Yat0inR = length(find(orderSetR(:,2)==0));

Yat1inY = length(find(orderSetY(:,2)==1));
Yat2inY = length(find(orderSetY(:,2)==2));
Yat3inY = length(find(orderSetY(:,2)==3));
Yat0inY = length(find(orderSetY(:,2)==0));

Yat1inB = length(find(orderSetB(:,2)==1));
Yat2inB = length(find(orderSetB(:,2)==2));
Yat3inB = length(find(orderSetB(:,2)==3));
Yat0inB = length(find(orderSetB(:,2)==0));

Bat1inR = length(find(orderSetR(:,3)==1));
Bat2inR = length(find(orderSetR(:,3)==2));
Bat3inR = length(find(orderSetR(:,3)==3));
Bat0inR = length(find(orderSetR(:,3)==0));

Bat1inY = length(find(orderSetY(:,3)==1));
Bat2inY = length(find(orderSetY(:,3)==2));
Bat3inY = length(find(orderSetY(:,3)==3));
Bat0inY = length(find(orderSetY(:,3)==0));

Bat1inB = length(find(orderSetB(:,3)==1));
Bat2inB = length(find(orderSetB(:,3)==2));
Bat3inB = length(find(orderSetB(:,3)==3));
Bat0inB = length(find(orderSetB(:,3)==0));

%% SET = [order R, order Y, order B] , find the order of the frequencies
%ORDER = appear 1st ---> 2nd ---> 3rd
orderSetRall=[0,0,0,0,0,0,0,0,0,0,0,0,0]';
orderSetYall=[0,0,0,0,0,0,0,0,0,0,0,0,0]';
orderSetBall=[0,0,0,0,0,0,0,0,0,0,0,0,0]';

orderset = [];

for i = 1:31
    RY = mismatchTable.SlidingRonY(i);
    RB = mismatchTable.SlidingRonB(i);

    if RY > RB 
        if and(RY>0,RB>0)     % R B Y
            orderSetRall(1) = orderSetRall(1)+1;
        elseif and(RY>0,RB==0) % B=R Y
            orderSetRall(2) = orderSetRall(2)+1;
        elseif and(RY>0,RB<0) % B R Y
            orderSetRall(3) = orderSetRall(3)+1;
        elseif and(RY==0,RB<0) % B R=Y
            orderSetRall(4) = orderSetRall(4)+1;
        else                  % B Y R
            orderSetRall(5) = orderSetRall(5)+1;
        end
    elseif RY < RB
        if and(RY>0,RB>0)     % R Y B
            orderSetRall(6) =orderSetRall(6)+1;
        elseif and(RY==0,RB>0) % Y=R B
            orderSetRall(7) = orderSetRall(7)+1;
        elseif and(RY<0,RB>=0) % Y R B
            orderSetRall(8) = orderSetRall(8)+1;
        elseif and(RY<0,RB==0) % Y R=B
            orderSetRall(9) = orderSetRall(9)+1;
        else                  % Y B R
            orderSetRall(10) = orderSetRall(10)+1;
        end
    else % RY == RB
        if RY > 0       % R Y=B
            orderSetRall(11) = orderSetRall(11)+1;
        elseif RY <0    % Y=B R
            orderSetRall(12) = orderSetRall(12)+1;
        else % RY == 0  % R=Y=B
            orderSetRall(13) = orderSetRall(13)+1;
        end
    end

    YR = mismatchTable.SlidingYonR(i);
    YB = mismatchTable.SlidingYonB(i);

    if YR > YB 
        if and(YR>0,YB>0)     % Y B R
            orderSetYall(1) = orderSetYall(1)+1;
        elseif and(YR>0,YB==0) % B=Y R
            orderSetYall(2) = orderSetYall(2)+1;
        elseif and(YR>0,YB<0) % B Y R
            orderSetYall(3) = orderSetYall(3)+1;
        elseif and(YR==0,YB<0) % B Y=R
            orderSetYall(4) = orderSetYall(4)+1;
        else                  % B R Y
            orderSetYall(5) = orderSetYall(5)+1;
        end
    elseif YR < YB
        if and(YR>0,YB>0)     % Y R B
            orderSetYall(6) = orderSetYall(6)+1;
        elseif and(YR==0,YB>0) % R=Y B
            orderSetYall(7) = orderSetYall(7)+1;
        elseif and(YR<0,YB>0) % R Y B
            orderSetYall(8) = orderSetYall(8)+1;
        elseif and(YR<0,YB==0) % R Y=B
            orderSetYall(9) = orderSetYall(9)+1;
        else %and(YR<0,YB<0)  % R B Y
            orderSetYall(10) = orderSetYall(10)+1;
        end
    else % YR == YB
        if YR > 0       % Y R=B
            orderSetYall(11) = orderSetYall(11)+1;
        elseif YR <0    % R=B Y
            orderSetYall(12) = orderSetYall(12)+1;
        else % RY == 0  % R=Y=B
            orderSetYall(13) = orderSetYall(13)+1;
        end
    end

    BR = mismatchTable.SlidingBonR(i);
    BY = mismatchTable.SlidingBonY(i);
    
    if BR > BY
        if and(BR>0,BY>0)       % B Y R
            orderSetBall(1) = orderSetBall(1)+1;
        elseif and(BR>0,BY==0)   % Y=B R
            orderSetBall(2) = orderSetBall(2)+1;
        elseif and(BR>0,BY<0)   % Y B R
            orderSetBall(3) = orderSetBall(3)+1;
        elseif and(BR==0,BY<0)   % Y B=R
            orderSetBall(4) = orderSetBall(4)+1;
        else %and(BR<0,BY<0)    % Y R B
            orderSetBall(5) = orderSetBall(5)+1;
        end
    elseif BR < BY
        if and(BR>0,BY>0)       % B R Y
            orderSetBall(6) = orderSetBall(6)+1;
        elseif and(BR==0,BY>0)   % R=B Y
            orderSetBall(7) = orderSetBall(7)+1;
        elseif and(BR<0,BY>0)   % R B Y
            orderSetBall(8) = orderSetBall(8)+1;
        elseif and(BR<0,BY==0)   % R B=Y
            orderSetBall(9) = orderSetBall(9)+1;
        else %and(BR<0,BY<0)    % R Y B
            orderSetBall(10) = orderSetBall(10)+1;
        end
    else % BR == BY
        if BR > 0       % B Y=R
            orderSetBall(11) = orderSetBall(11)+1;
        elseif BR <0    % Y=R B
            orderSetBall(12) = orderSetBall(12)+1;
        else % RY == 0  % R=Y=B
            orderSetBall(13) = orderSetBall(13)+1;
        end
    end
end

% There are 93 set of analysis in total, which is the result of sliding
% each frequencies over the others for one time, producing 3*31 number of
% data points.

%% FIGURE ORDER
figure()
bar([Rat1inR+Rat1inY+Rat1inB,Rat2inR+Rat2inY+Rat2inB,Rat3inR+Rat3inY+Rat3inB,Rat0inY+Rat0inB])
names = {'1^{st}','2^{nd}','3^{rd}','(R=Y,R=B)'};
title('Order of R overall')
set(gca,'xticklabel',names)

figure()
bar([Rat1inR,Rat1inY,Rat1inB])
title('R Being 1^{st} from different perspective')
names = {'From R','From Y','From B'};
set(gca,'xticklabel',names)

figure()
bar([Yat1inR+Yat1inY+Yat1inB,Yat2inR+Yat2inY+Yat2inB,Yat3inR+Yat3inY+Yat3inB,Yat0inR+Yat0inB])
names = {'1^{st}','2^{nd}','3^{rd}','(R=Y,R=B)'};
title('Order of Y overall')
set(gca,'xticklabel',names)

figure()
bar([Yat1inR,Yat1inY,Yat1inB])
title('Y Being 1^{st} from different perspective')
names = {'From R','From Y','From B'};
set(gca,'xticklabel',names)

figure()
bar([Bat1inR+Bat1inY+Bat1inB,Bat2inR+Bat2inY+Bat2inB,Bat3inR+Bat3inY+Bat3inB,Bat0inR+Bat0inY])
names = {'1^{st}','2^{nd}','3^{rd}','(R=Y,R=B)'};
title('Order of B overall')
set(gca,'xticklabel',names)

figure()
bar([Rat1inR,Yat1inR,Bat1inR;Rat1inY,Yat1inY,Bat1inY;Rat1inB,Yat1inB,Bat1inB],'stacked')
title('Frequency Appear 1^{st} from different perspective')
names = {'From R','From Y','From B'};
set(gca,'xticklabel',names)
ylim([0 31+0.5])

figure()
bar([Rat2inR,Yat2inR,Bat2inR;Rat2inY,Yat2inY,Bat2inY;Rat2inB,Yat2inB,Bat2inB],'stacked')
title('Frequency Appear 2^{nd} from different perspective')
names = {'From R','From Y','From B'};
set(gca,'xticklabel',names)
ylim([0 31+0.5])

figure()
bar([Rat3inR,Yat3inR,Bat3inR;Rat3inY,Yat3inY,Bat3inY;Rat3inB,Yat3inB,Bat3inB],'stacked')
title('Frequency Appear 3^{rd} from different perspective')
names = {'From R','From Y','From B'};
set(gca,'xticklabel',names)
ylim([0 31+0.5])

%% Sequencing Overview
figure()
bar(orderSetRall)
title('Sequencing Observed using R as the Sliding Window')
names = {'R B Y','B=R Y','B R Y','B R=Y','B Y R','R Y B','Y=R B','Y R B','Y R=B','Y B R',...
    'R Y=B','Y=B R','R=Y=B'};
set(gca,'xticklabel',names)
ylim([0 max(orderSetRall)+1])

figure()
bar(orderSetYall)
title('Sequencing Observed using Y as the Sliding Window')
names = {'Y B R','B=Y R','B Y R','B Y=R','B R Y','Y R B','Y=R B','R Y B','R Y=B','R B Y',...
    'Y R=B','R=B Y','R=Y=B'};
set(gca,'xticklabel',names)
ylim([0 max(orderSetYall)+1])

figure()
bar(orderSetBall)
title('Sequencing Observed using B as the Sliding Window')
names = {'B Y R','Y=B R','Y B R','Y B=R','Y R B','B R Y','R=B Y','R B Y','R B=Y','R Y B',...
    'B Y=R','Y=R B','R=Y=B'};
set(gca,'xticklabel',names)
ylim([0 max(orderSetBall)+1])

%% All Sequencings
overallSequencing=[];
% R Y B
overallSequencing(1)=orderSetRall(6)+orderSetYall(8)+orderSetBall(10);
% R B Y
overallSequencing(2)=orderSetRall(1)+orderSetYall(10)+orderSetBall(8);
% Y R B
overallSequencing(3)=orderSetRall(8)+orderSetYall(6)+orderSetBall(5);
% Y B R
overallSequencing(4)=orderSetRall(10)+orderSetYall(1)+orderSetBall(3);
% B R Y
overallSequencing(5)=orderSetRall(3)+orderSetYall(5)+orderSetBall(6);
% B Y R
overallSequencing(6)=orderSetRall(5)+orderSetYall(3)+orderSetBall(1);
% R=Y B
overallSequencing(7)=orderSetRall(7)+orderSetYall(4)+orderSetBall(12);
% B R=Y
overallSequencing(8)=orderSetRall(4)+orderSetYall(4)+orderSetBall(11);
% R=B Y
overallSequencing(9)=orderSetRall(2)+orderSetYall(12)+orderSetBall(7);
% Y R=B
overallSequencing(10)=orderSetRall(9)+orderSetYall(11)+orderSetBall(4);
% B=Y R
overallSequencing(11)=orderSetRall(12)+orderSetYall(2)+orderSetBall(2);
% R B=Y
overallSequencing(12)=orderSetRall(11)+orderSetYall(9)+orderSetBall(9);
% R=Y=B
overallSequencing(13)=orderSetRall(13)+orderSetYall(13)+orderSetBall(13);

figure()
bar(overallSequencing)
title('All Sequencing Observed Using Sliding Window Method')
names = {'R Y B','R B Y','Y R B','Y B R','B R Y','B Y R','R=Y B','B R=Y','R=B Y','Y R=B',...
    'B=Y R','R B=Y','R=Y=B'};
set(gca,'xticklabel',names)
ylim([0 max(overallSequencing)+1])
ylabel('Occurances')
xlabel('Sequences')

%% FIGURE MISMATCH
displacementsMismatchR = (mismatch_sets(:,2)-mismatch_sets(:,1))+mismatch_sets(:,3);
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
%% Coherent Point Drift Analysis - Failed

timepoints = [];
for n = 3:33
    sheet = transition_gapped(transition_gapped.Sheet==n,:);
    begineTime = find(transition_gapped.RECORD == sheet.RECORD(1));
    timepoints(n-2)=begineTime;
end
timepoints = timepoints';

transform_table = [myCPD(Y_frequencies((timepoints(1)+0):(timepoints(1)+1440-1+0)) ...
            ,R_frequencies(timepoints(1):(timepoints(1)+1440-1)),'nonrigid');myCPD(Y_frequencies((timepoints(1)+0):(timepoints(1)+1440-1+0)) ...
            ,R_frequencies(timepoints(1):(timepoints(1)+1440-1)),'nonrigid')];

beginTime = timepoints(20);
endTime = beginTime+1440-1;
transform_table_20 = transform_table;
for d = -100:100
    display(d)
    transform_table_20(d+101,:) = myCPD(Y_frequencies((beginTime+d):(endTime+d)) ...
        ,R_frequencies(beginTime:endTime),'nonrigid');
    clc;
end
%%
for i = 1:size(timepoints)
    differences = zeros(1,200);
    value = -100:100;
    beginTime = timepoints(i);
    endTime = beginTime+1440-1;
    
    for d = -100:100
        differences(d+101) = abs(sum(R_frequencies(beginTime:endTime)- ...
            Y_frequencies((beginTime+d):(endTime+d))));
        transform_table(d+101,:) = myCPD(Y_frequencies((beginTime+d):(endTime+d)) ...
            ,R_frequencies(beginTime:endTime),'nonrigid');
    end

    differences_RY = [differences',value'];
    mismatch_RY = value(find(differences==min(differences)));
    mismatch_RY = min(mismatch_RY); % mismatch_i, not all the values
    %
    differences = zeros(1,2880);
    value = -100:100;
    for d = -100:100
        differences(d+101) = abs(sum(R_frequencies(beginTime:endTime)- ...
            B_frequencies((beginTime+d):(endTime+d))));
    end
end

%%
%listNumber = find(displacementsMismatchR~=0)+1;

%figure();hold on;
%for i = 1:size(unique(transition_gapped.Sheet))
%    if ismember(i, listNumber)
%        R_frequency = table2array(transition_gapped(transition_gapped.Sheet==i,'R_Frequency'));
%        idx = transition_gapped(transition_gapped.Sheet==i,'RECORD');
%        thisTime = time(table2array(idx)+1);
%        plot(thisTime,R_frequency,'r.')
%    else
%        R_frequency = table2array(transition_gapped(transition_gapped.Sheet==i,'R_Frequency'));
%        idx = transition_gapped(transition_gapped.Sheet==i,'RECORD');
%        thisTime = time(table2array(idx)+1);
%        plot(thisTime,R_frequency,'.','Color',  [0.5 0.5 0.5])
%    end
%end