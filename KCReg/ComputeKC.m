% given the transformation parameter param, compute the KC value;
function KCVal = ComputeKC(param);
global Scene;
global Model;
global SceneKDE;
global display_it;
global resolution;

PT = TransformPoint(param,Model);

MKDE = ComputeKDE(PT);
KCVal = -sum(sum(MKDE.*SceneKDE));



%The following for display purpose only.
if(display_it)
    figure(3); hold off;
    %subplot(1,2,2); 
    DisplayPoints(PT,Scene);
    set(gca,'FontSize',16);
    title(sprintf('KC Value: %f',-KCVal));
    drawnow;
end;
