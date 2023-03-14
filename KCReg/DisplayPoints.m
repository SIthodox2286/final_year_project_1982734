function DisplayPoints(Model, Scene);

set(gca,'FontSize',12);
plot(Model(:,1),Model(:,2),'k+');
hold on;
plot(Scene(:,1),Scene(:,2),'go');
%axis equal;
xlim([min(Scene(:,1))-1.5,max(Scene(:,1))+1.5]);
ylim([min(Scene(:,2))-1.5,max(Scene(:,2))+1.5]);   

pbaspect([1,1,1]);