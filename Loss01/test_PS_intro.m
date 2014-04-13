
D = 2; % dimension of data
N = 40;
[X,t] = generateTestData(N, 0.2);
bestC = findBestSVMConstant(X, t);
w_svm = getWeightsByLinearSVM(X,t,bestC);
w_slo = smoothLossOptimizer(X, t, w_svm, 1);

c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2

[X1_svm, X2_svm] = getEndPointsOfDecisionLine(X, w_slo);
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_slo, X2_slo, 'm-');

legend('Class 1', 'Class 2', 'Optimal decision hyperplane');