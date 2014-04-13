% Given training set X, t
% Perform 5-fold cross validation with different value of R and 
% return bestR, for which the prediction error rate is minimum 
function bestR = findBestSLOConstant(X, t, C)

N = length(t);
ids = randperm(N);

bestR = 0.0;
minErrRate = 1000;

for R = 2 .^ [0 -8 -4 -2 -1 0.5 1 2 4 8 12 16]
    
    n_folds = 5;    %5-folds cross validation to find best constant C
    size = floor(N / n_folds);
    errors = zeros(1, n_folds);
    
    for k=0:(n_folds-1)
        idst = ids(k*size+1 : (k+1)*size);
        ids0 = [ids(1:k*size), ids((k+1)*size+1:N)];
        t0 = t(ids0);   %training data
        X0 = X(ids0,:);  
        tt = t(idst);   %test data
        Xt = X(idst,:);
        w = getWeightsByLinearSVM(X0, t0, C);
        w = smoothLossOptimizer(X0, t0, w, R);
        errors(k+1) = getPredictionErrorRate(Xt, tt, w);
    end
    
    errRate = mean(errors);     %average error for given C
    if errRate + 0.001 < minErrRate
        bestR = R;
        minErrRate = errRate;
    end
    
end

end
