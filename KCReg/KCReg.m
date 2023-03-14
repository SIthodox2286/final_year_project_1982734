% function [param] = KCReg(M, S, h, display,motion);
%M is a N by 2 array containing 2D model points
%S is a M by 2 array containing 2D Scene points
%h is the "bandwith"
%display: display the intermediate steps or not. default is not display
%motion:  the transformation model, can be
%         euclidean
%         affine
%         projective;
%         Default motion model is euclidean;
function [param] = KCReg(M,S, h, display,motion);

if nargin<3;
    disp('Not enough input parameters');
    return;
end;

if nargin<4
    display = 0;
    motion = 'euclidean';
end;

if nargin<5
    motion = 'euclidean';
end;

%set the global parameters that can be seen by "ComputeKC".
global display_it;
display_it = display;
global Scene;
Scene = S;
global Model;
Model = M;
global resolution;
resolution = h;
global min_val;
min_val = min(S);
global max_val;
max_val = max(S);
global SceneKDE;
SceneKDE = ComputeKDE(S);


if(display_it)  
    figure(2);
  %  subplot(1,2,1); hold off;
    DisplayPoints(Model,Scene);
    set(gca,'FontSize',16);
    title('Initial setup');
    drawnow;
end;


switch lower(motion)
    case 'euclidean'
        opt = optimset('MaxFunEvals',2000,'MaxIter',2000,'TolFun',1e-6,'TolX',1e-10);
        param = fminsearch('ComputeKC',[0,0,0]',opt);
    case 'affine'
        opt = optimset('MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-6,'TolX',1e-10);
        param = fminsearch('ComputeKC',[1 0 0 1 0 0]',opt);        
    case 'projective'
        opt = optimset('MaxFunEvals',5000,'MaxIter',5000,'TolFun',1e-6,'TolX',1e-10);
        param = fminsearch('ComputeKC',[1 0 0 0 1 0 0 0 ]',opt);
        resolution = resolution/3;
        SceneKDE = ComputeKDE(S);
        param = fminsearch('ComputeKC',param,opt);
    otherwise
        disp('Unknown motion type');
        return;
end;
