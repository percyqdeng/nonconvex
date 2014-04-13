% Given training set X, t
% Return minimal 01 loss by combinatorial search
function [minLoss T0] = getMinimal01LossByPCS(X, t, timeLimit)

[w T0] = getWeightsByPointsSelection2(X, t, timeLimit);
minLoss = cal01Loss(X,t,w);
    

end
