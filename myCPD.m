function [Transform] = myCPD(sourse_signal,moving_signal,transitionType)
%MYCPD Summary of this function goes here

    opt.method=transitionType; % use affine registration
    opt.viz=0;           % don't show every iteration
    opt.outliers=0.1;    % use 0.1 noise weight
    
    opt.normalize=1;     % normalize to unit variance and zero mean before registering (default)
    opt.lambda=3;         % estimate global scaling too (default)
    opt.beta=2;           % estimate strictly rotational matrix (default)
    opt.corresp=1;       % do not compute the correspondence vector at the 
                         % end of registration (default). Can be quite slow for large data sets.
    
    opt.max_it=100;      % max number of iterations
    opt.tol=1e-10;       % tolerance
    opt.fgt=0;           % Use Case
                         % registering 2nd to 1st

    Transform=cpd_register(sourse_signal,moving_signal,opt);
end

