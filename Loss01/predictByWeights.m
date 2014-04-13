function [predictedTargets, successRate] = predictByWeights(t, X, w)

N = length(t);
predictedTargets = X * w;
predictedTargets(predictedTargets>0) = 1;
predictedTargets(predictedTargets ~= 1) = -1;
d = abs(predictedTargets - t);
N_correct = sum(d==0);
successRate = N_correct / N;
if successRate < 0.5
    successRate = 1 - successRate;
    predictedTargets = -1 * predictedTargets;
end


end
