% Given training set X, t
% Return minimal 01 loss by 
function [minLoss runTime] = getMinimal01LossByCSA(X, t, timeLimit)

ticId = tic;
[w T0] = getWeightsByPointsSelection3(X, t, timeLimit);
minLoss = cal01Loss(X,t,w);
runTime = toc(ticId);     

end
