function main_method_tester()

clc;
[X,t] = readData('data\data_small.csv');
%X = normalizeData(X);
%showData(X,t);
%[X,t] = noisifyData(X, t, 'Outliers', 0.1);
%[X,t] = noisifyData(X, t, 'WhiteNoise', 0.1);
X = normalizeData(X);
%showData(X,t);

[N,D] = size(X);
fprintf('Training data: N = %d, D = %d. \n', N, D-1);

%find liblinear SVM solution
bestC = findBestSVMConstant(X, t);
w_svm = getWeightsByLinearSVM(X,t,bestC);
printSolution('Linear SVM solution', X, t, w_svm);
w_slo = smoothLossOptimizer(X, t, w_svm, 1);
printSolution('Smooth Loss Optimizer', X, t, w_slo);

%find (minimal loss) solution by Points Selection method,
%searches all possible combination => slow, but min loss guaranteed
w_psl = getWeightsByPointsSelection(X,t);
printSolution('Points Selection solution', X, t, w_psl);


%find solution by Branch and Bound
tic
w_bnb = getWeightsByBranchAndBound4(X, t);
toc
printSolution('Branch and Bound solution', X, t, w_bnb);

%find solution by Branch and Bound
w_bpm = getWeightsByBPM(X, t);
printSolution('Bayesian Point Machine solution', X, t, w_bpm);

%show all solutions on one graph
c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2
 
[X1_svm, X2_svm] = getEndPointsOfDecisionLine(X, w_svm);
[X1_slo, X2_slo] = getEndPointsOfDecisionLine(X, w_slo);
[X1_psl, X2_psl] = getEndPointsOfDecisionLine(X, w_psl);
[X1_bnb, X2_bnb] = getEndPointsOfDecisionLine(X, w_bnb);
[X1_bpm, X2_bpm] = getEndPointsOfDecisionLine(X, w_bpm);

figure(1);
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_psl, X2_psl, 'b-', ...
    X1_svm, X2_svm, 'm-', ...
    X1_slo, X2_slo, 'c-', ...
    X1_bnb, X2_bnb, 'k-', ...
    X1_bpm, X2_bpm, 'r-');

legend('Class 0', 'Class 1', ...
    'Points Selection', ...
    'Linear SVM', ...
    'SmoothLoss Opt', ... 
    'Branch and Bound', ...
    'Bayes Point Machine');


end

