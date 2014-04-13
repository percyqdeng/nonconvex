% Given training set X, t
% Return minimal 01 loss by logistic regression
function [minLoss runTime] = getMinimal01LossBySVM(X, t)

ticId = tic;

minLoss = 1e10;

for C = 2 .^ [0 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0.5 1 2 4 6 8 10]
    w = getWeightsByLinearSVM(X,t,C);
    l = cal01Loss(X,t,w);
    if (l < minLoss)
        minLoss = l;
    end
end

runTime = toc(ticId); 

end
