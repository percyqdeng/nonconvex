function [errRate, err] = getBestPredictionRatesByBPM(X,t,N_runs)

[N, D] = size(X);
Nt = floor(0.2*N);  % # points in test set
rates = zeros(1,N_runs);

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
    w = getWeightsByBPM(X0, t0);
    rates(i) = getPredictionErrorRate(Xt, tt, w);
end

errRate = mean(rates);
err = std(rates);


end

