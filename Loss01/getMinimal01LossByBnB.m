% Given training set X, t
% Return minimal 01 loss by BnB
function [minLoss T0] = getMinimal01LossByBnB(X, t, timeLimit)

[pred, minLoss, T0] = getBnBOptimalPredictionVector2(X, t, timeLimit);    

end
