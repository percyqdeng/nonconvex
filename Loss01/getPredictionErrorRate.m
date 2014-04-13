function errorRate = getPredictionErrorRate(X, t, w)

N = length(t);
predictedTargets = X * w;
predictedTargets(predictedTargets>0) = 1;
predictedTargets(predictedTargets ~= 1) = -1;
d = abs(predictedTargets - t);
N_correct = sum(d==0);
errorRate = 1 - N_correct / N;
%if errorRate > 0.5
%    errorRate = 1 - errorRate;
%end


end
