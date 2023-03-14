function [CPMarix] = Regulate_CP(Data,CPMarix,windowSize)
    %% Regulate Change Points - Window Method
    selected = [];
    for i = 1:windowSize:size(Data,1)
        selection = CPMarix(CPMarix(:,1)<(i+windowSize));
        selection = selection(selection>=i);
        if ~isempty(selection)
            if size(selection,1)>1
               selection(2:end)=NaN;
               selected = [selected;selection];
            else
               selected = [selected;selection];
            end
        end
    end
    
    CPMarix(:,1)=selected;
    CPMarix=CPMarix(~isnan(CPMarix(:,1)),:);
end

