function main_mean_error_plot()

clc;
[data_X, data_t] = readData('data\bupa.csv');
percents = 0.01:0.02:0.2;
mean_err_svm = zeros(1,length(percents));
mean_err_slo = zeros(1,length(percents));

for k=1:length(percents)
    
    [X0,t0] = addOutliers(data_X, data_t, percents(k), -1);
    [N, D] = size(X0);
    Nt = floor(0.2*N);  % # points in test set
    
    %shuffle the data
    ids = randperm(N);
    X0 = X0(ids,:);
    t0 = t0(ids);
    
    N_runs = 40;    %number of restarts
    err_svm = zeros(1,N_runs);
    err_slo = zeros(1,N_runs);
    loss_svm = zeros(1,N_runs);
    loss_slo = zeros(1,N_runs);
    
    for i=1:N_runs
        
        %extract training set & test set
        ids = randperm(N);
        ids1 = ids(1:(N-Nt));
        ids2 = ids((N-Nt+1):N);
        X = X0(ids1,:);
        t = t0(ids1);
        Xt = X0(ids2,:);
        tt = t0(ids2);
        
        %normalize X, use its normalization params to normalize Xt
        [X, means, stds] = normalizeData(X);
        for j=2:D
            Xt(:,j) = (Xt(:,j) - means(j)) / stds(j);
        end
        
        %find liblinear SVM solution
        w_svm = getWeightsByLinearSVM(X, t);
        
        %find smooth loss solution
        w_slo = smoothLossOptimizer(X, t, w_svm, 1);
        
        loss_svm(i) = cal01Loss(X,t,w_svm);
        loss_slo(i) = cal01Loss(X,t,w_slo);
        err_svm(i) = getPredictionErrorRate(Xt, tt, w_svm);
        err_slo(i) = getPredictionErrorRate(Xt, tt, w_slo);
        
    end
    
    mean_err_svm(k) = mean(err_svm);
    mean_err_slo(k) = mean(err_slo);
end


figure(1);
plot(percents, mean_err_svm, 'ro-', percents, mean_err_slo, 'bs-');
xlabel('Outliers Percentage');
ylabel('Prediction Error');
legend('SVM', 'Optimal 01Loss');


end

