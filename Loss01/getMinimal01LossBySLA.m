% Given training set X, t
% Return minimal 01 loss by logistic regression
function [minLoss runTime] = getMinimal01LossBySLA(X, t)

ticId = tic;
w = getWeightsByALA(X,t);
minLoss = cal01Loss(X,t,w);
runTime = toc(ticId);  

end
