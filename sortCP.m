function [beastmodelCPsorted] = sortCP(beastmodel)
    sCp = beastmodel.season.cp;
    beastmodel.season.cp = sort(beastmodel.season.cp);
    [yes,idx]=ismember(beastmodel.season.cp,sCp);
    beastmodel.season.cpPr = beastmodel.season.cpPr(idx);
    tCp = beastmodel.trend.cp;
    beastmodel.trend.cp = sort(beastmodel.trend.cp);
    [yes,idx]=ismember(beastmodel.trend.cp,sCp);
    beastmodel.trend.cpPr = beastmodel.trend.cpPr(idx);
    beastmodelCPsorted = beastmodel;
end

