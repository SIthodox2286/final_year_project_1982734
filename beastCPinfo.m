function [cpPred1,cpPred2,cpPred,cpTimePred,cpDataPred] = beastCPinfo(predmodel,fh,yF,a,b,timestep)
    [cpPred1,cpPred2] = takeCP(predmodel,0); cpPred = [cpPred1(:,1);cpPred2(:,1)]; cpPred = unique(cpPred); cpTimePred = fh(cpPred); cpDataPred = yF(cpPred);
    [cpPred,cpTimePred,cpDataPred] = mergeCP(timestep,predmodel,fh,yF,a,b);
end
