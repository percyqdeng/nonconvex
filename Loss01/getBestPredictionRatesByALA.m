function [errRate, err] = getBestPredictionRatesByALA(X,t,N_runs)

[N, D] = size(X);
Nt = floor(0.2*N);  % # points in test set
rates = zeros(1,N_runs);
bestC = findBestSVMConstant(X, t);
bestR = findBestALAConstant(X, t, bestC);

for i=1:N_runs
    
    %extract training set & test set
    ids = randperm(N);
    ids1 = ids(1:(N-Nt));
    ids2 = ids((N-Nt+1):N);
    X0 = X(ids1,:);
    t0 = t(ids1);
    Xt = X(ids2,:);
    tt = t(ids2);
    
    %find best solution
    wlr = getWeightsByLinearSVM(X0, t0, bestC);
    w = smoothLossOptimizer(X0, t0, wlr, bestR);
    %relabel & use svm to determine weights
    %t1 = getPredictionVector(X0, w);
    %w = getWeightsByLinearSVM(X0, t1, bestC);
    rates(i) = getPredictionErrorRate(Xt, tt, w);
end

errRate = mean(rates);
err = std(rates);


end

