function [original] = mydenormalize(normlaized,mu,sigma)
    [row,col] = size(normlaized);
    original = normlaized;
    
    for i = 1:col
       Xnorm = normlaized(:,i);
       thisMu = mu(i);
       thisSigma = sigma(i);
       
       % Calculation
       X = Xnorm.*thisSigma + thisMu;

       % Saving for Output
       original(:,i) = X;
    end
end

