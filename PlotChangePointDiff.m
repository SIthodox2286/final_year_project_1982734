function [f] = PlotChangePointDiff(timespan,changepoints)
f = figure;
xLoc = 1:size(diff(timespan(changepoints(:,1))),1);
bar1 = bar(xLoc,diff(timespan(changepoints(:,1))));
xtips1 = bar1(1).XEndPoints;
ytips1 = bar1(1).YEndPoints;
labels1 = string(bar1(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
ylim([0 max(diff(datetime(timespan(changepoints(:,1)))))+0.05])
f.Position = [300 350 1000 400];
end

