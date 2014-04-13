
clc;

ds = {'dataUCI\breast-cancer-wisconsin.csv', ...
    'dataUCI\bupa.csv', 'dataUCI\cmc.csv', 'dataUCI\heart.csv', ...
    'dataUCI\indian_liver.csv', 'dataUCI\pima-indians-diabetes.csv', ...
    'dataUCI\sonar.csv'};

N_runs = 500;
N_tests = length(ds);
R = zeros(N_tests,8);

for k = 1:N_tests
    tic 
    
    [X,t] = readData(char(ds(k)));
    fprintf('TESTING DATASET: %s. \n', char(ds(k)));
    %[X,t] = noisifyData(X,t,'Outliers',0.10);
    X = normalizeData(X);
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


