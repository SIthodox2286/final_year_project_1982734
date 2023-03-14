function [output,muAll,sigmaAll] = mynormalize(doubleArray)
    [row,col] = size(doubleArray);
    output = doubleArray;
    muAll = (1:col)';
    sigmaAll = (1:col)';
    for i = 1:col
       X = doubleArray(:,i);
       
       % Calculation
       mu = mean(X);
       sigma = std(X);
       Xnorm = (X - mu)./sigma;

       % Saving for Output
       output(:,i) = Xnorm;
       muAll(i) = mu;
       sigmaAll(i) = sigma;
    end
end

