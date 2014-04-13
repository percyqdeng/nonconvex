
clc;

D = 2; % dimension of data
NRange = [200];
NTests = 5;
Times = zeros(NTests, length(NRange)*2);
for n = 1:length(NRange) %number of data points
    N = NRange(n);
    for k = 1:NTests %number of tests
        fprintf('N = %d. Test #%f of %f \n', N, k, NTests);
        [X,t] = generateTestData(N, 0.25);        
        tic;    fprintf('Testing Final algorithm \n');
        [w, t0] = getWeightsByBranchAndBound4(X, t);
        t1 = toc;
        fprintf('T0 = %d. T1 = %d \n', t0, t1);
        Times(k,2*n-1:2*n) = [t0 t1];
    end
end 
Times
mean(Times,1)