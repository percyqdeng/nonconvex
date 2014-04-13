function main_mean_error()

clc;
[X,t] = readData('data\iris.csv');
X = normalizeData(X);
%showData(X,t);
[X,t] = noisifyData(X, t, 'WhiteNoise', 0.2);
%showData(X,t);
bestC = findBestSVMConstant(X, t);
bestR = findBestSLOConstant(X, t, bestC);

[N, D] = size(X);
Nt = floor(0.2*N);  % # points in test set

N_runs = 10;        %number of restarts
err_svm = zeros(1,N_runs);
err_slo = zeros(1,N_runs);
loss_svm = zeros(1,N_runs);
loss_slo = zeros(1,N_runs);

for i=1:N_runs
    
    %extract training set & test set
    ids = randperm(N);
    ids1 = ids(1:(N-Nt));
    ids2 = ids((N-Nt+1):N);
    X0 = X(ids1,:);
    t0 = t(ids1);
    Xt = X(ids2,:);
    tt = t(ids2);
    
    %find liblinear SVM solution
    w_svm = getWeightsByLinearSVM(X0, t0, bestC);
    
    %find (approximated) optimal 01 lost solution
    w_slo = smoothLossOptimizer(X0, t0, w_svm, bestR);
    
    loss_svm(i) = cal01Loss(X0, t0, w_svm);
    loss_slo(i) = cal01Loss(X0, t0, w_slo);
    err_svm(i) = getPredictionErrorRate(Xt, tt, w_svm);
    err_slo(i) = getPredictionErrorRate(Xt, tt, w_slo);

end

fprintf('SVM: [MeanLoss, ErrorRate, STD] = %s\n', ...
    mat2str([mean(loss_svm), mean(err_svm), std(err_svm)],4));

fprintf('SLO: [MeanLoss, ErrorRate, STD] = %s\n', ...
    mat2str([mean(loss_slo), mean(err_slo), std(err_slo)],4));


end

