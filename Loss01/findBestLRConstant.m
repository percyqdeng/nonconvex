% Given training set X, t
% Perform 5-fold cross validation with different value of C and 
% return bestC, for which the prediction error rate is minimum 
function bestC = findBestLRConstant(X, t)

N = length(t);
ids = randperm(N);

bestC = 0.0;
minErrRate = 1000;

for C = 2 .^ [0 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0.5 1 2 4 6 8 10]
    
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
        model = train(t0,sparse(X0),['-s 0 -c ', num2str(C), ' -e 0.0001']);
        errors(k+1) = getPredictionErrorRate(Xt, tt, model.w');
    end
    
    errRate = mean(errors);     %average error for given C
    if errRate + 0.001 < minErrRate
        bestC = C;
        minErrRate = errRate;
    end
    
end

end
