
clc;
N_runs = 200;
N_tests = 100;
R = zeros(N_tests,8);

for k = 1:N_tests
    tic 
    
    accepted = 0;
    while ~accepted
        N = 10*randi(40) + 400;
        D = randi(5) + 3;
        [X,t] = generateTestData(N, D, 0); 
        [X,t] = noisifyData(X,t,'WhiteNoise1',0.10);
        X = normalizeData(X);
        w = getWeightsByLinearSVM(X,t);
        w = smoothLossOptimizer(X, t, w, 0);
        loss = cal01Loss(X, t, w);
        [N, D] = size(X);
        accepted = loss > N/8 && loss < N/3;
    end
    
    fprintf('TESTING DATASET: N = %d, D = %d. \n', N, D-1);
    
    [R(k,1), R(k,2)] = getBestPredictionRatesByBPM(X,t,N_runs);
    [R(k,3), R(k,4)] = getBestPredictionRatesBySVM(X,t,N_runs); 
    [R(k,5), R(k,6)] = getBestPredictionRatesByLR(X,t,N_runs); 
    [R(k,7), R(k,8)] = getBestPredictionRatesByALA(X,t,N_runs);
    fprintf('***PredictionErrors [BPM, SVM, LR, ALA] =\n %s.\n', ...
        mat2str(R(k,:),4));
    
    fprintf('TEST CASE #%d/%d FINISHED IN %f SECONDS.\n', ...
        k, N_tests, toc);
end

R


