%Find the transformation that registers model with the
%   scene, S <== T M.
% Output:
%   param =[dx dy theta]
function [tmodel] = ICP(model,scene,thr,display_it)

if nargin < 3
    thr = .1;
    display_it = 0;
end;

if nargin < 4
    display_it = 0;
end;

%finding correspondence
correspondence = zeros(size(model));
len = size(model,1);


old_param = 1e20*ones(1,3);
param = 1e10*ones(1,3);
step = 0;
while norm(old_param-param)>1e-10 & step <200;
    step = step+1;
    old_param = param;
    indx = [];
    for ii = 1:len;
        dist = (scene(:,1)-model(ii,1)).^2 + ...
            (scene(:,2)-model(ii,2)).^2;
        [mn,idx] = min(dist);
        if(mn<thr)
            indx=[indx,ii];
            correspondence(ii,:) = scene(idx,:);
        end;
    end;

    if display_it
        figure(1); hold off;
        set(gca,'FontSize',12);
        plot(model(:,1),model(:,2),'r+');
        hold on;
        plot(scene(:,1),scene(:,2),'go');
        for ii = 1:length(indx);
            plot([model(indx(ii),1),correspondence(indx(ii),1)],...
                [model(indx(ii),2),correspondence(indx(ii),2)])
        end;
        pbaspect([1,1,1]);
        drawnow;
    end;
        
    %estimating the parameters;
    [theta,dxy] = ICP2D(model(indx,:),correspondence(indx,:));
    param = [dxy,theta];
    model = TransformPoint(param,model);
end;

tmodel = model;