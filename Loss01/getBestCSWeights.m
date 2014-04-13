% Given training set X, t
% Return minimal 01 loss by logistic regression
function [minw minLoss] = getBestCSWeights(X, t0, w)

w = [-1; w];
t = getPredictionVector(X,w);

minw = getWeightsByLinearSVM(X,t);
minLoss = cal01Loss(X,t0,minw);
w2 = getWeightsByLogisticRegression(X,t);
l2 = cal01Loss(X,t0,w2);
if l2 < minLoss
    minLoss = l2;
    minw = w2;
end

end
