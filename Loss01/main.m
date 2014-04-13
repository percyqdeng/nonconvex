function main()

clc;
[X,t] = readData('data\data6.csv');
%X = normalizeData(X);
%showData(X,t);
%[X,t] = noisifyData(X, t, 'Outliers', 0.1);
%[X,t] = noisifyData(X, t, 'WhiteNoise', 0.1);
%showData(X,t);
X = normalizeData(X);

[N,D] = size(X);
fprintf('Training data: N = %d, D = %d. \n', N, D-1);

%find least square solution
 w_lsq = getWeightsByLeastSquare(X,t);
 printSolution('Least Square solution', X, t, w_lsq);

%find logistic regression solution
bestC = findBestLogisticRegressionConstant(X, t);
w_lrg = getWeightsByLogisticRegression(X,t,bestC);
printSolution('Logistic Regression solution', X, t, w_lrg);

%find liblinear SVM solution
bestC = findBestSVMConstant(X, t);
w_svm = getWeightsByLinearSVM(X,t,bestC);
printSolution('Linear SVM solution', X, t, w_svm);

%find solution by smooth lost SGD
w_sgd = smoothLossSGD(X, t);
printSolution('Smooth Loss SGD solution', X, t, w_sgd);

%find optimize smooth lost solution
bestR = 1;%findBestSLOConstant(X, t, bestC);
w_slo = smoothLossOptimizer(X, t, w_svm, bestR);
printSolution('Smooth Loss Optimizer', X, t, w_slo);

%find BPM solution
w_bpm = getWeightsByBPM(X,t);
printSolution('Bayes Point Machine solution', X, t, w_svm);

%find perceptron solution
%w_pct = getWeightsByPerceptron(X,t);
%printSolution('Perceptron solution', X, t, w_pct);

%find (minimal loss) solution by points selection method,
%searches all possible combination => slow, but min loss guaranteed
w_psl = getWeightsByPointsSelection(X,t);
printSolution('Points Selection solution', X, t, w_psl);


%show all solutions on one graph
c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2
 
[X1_lrg, X2_lrg] = getEndPointsOfDecisionLine(X, w_lrg);
[X1_svm, X2_svm] = getEndPointsOfDecisionLine(X, w_svm);
[X1_sgd, X2_sgd] = getEndPointsOfDecisionLine(X, w_sgd);
[X1_slo, X2_slo] = getEndPointsOfDecisionLine(X, w_slo);
[X1_lsq, X2_lsq] = getEndPointsOfDecisionLine(X, w_lsq);
[X1_bpm, X2_bpm] = getEndPointsOfDecisionLine(X, w_bpm);
%[X1_pct, X2_pct] = getEndPointsOfDecisionLine(X, w_pct);
%[X1_psl, X2_psl] = getEndPointsOfDecisionLine(X, w_psl);

figure(1);
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_lsq, X2_lsq, 'g-', ...
    X1_lrg, X2_lrg, 'c-', ...
    X1_svm, X2_svm, 'm-', ...
    X1_bpm, X2_bpm, 'b-', ...
    X1_slo, X2_slo, 'k-');
    %X1_pct, X2_pct, 'c-', ...
    %X1_psl, X2_psl, 'm-');

   legend('Class 0', 'Class 1', ...
    'Least Square', 'Logistic Regression', 'Support Vector Machines',  ...  
    'Bayes Point Machines', 'Solution of Optimal 0-1 Loss');
    %'Least Square', 'Perceptron', 'Points Select');

%plot01Loss(X,t,w_slo);
% smoothLossViz(X, t, w_slo, 1, bestR);
% 
% params.X = X; params.t = t; 
% params.w = w_slo; 
% params.smoothness = 1000000; 
% params.range0 = -4; params.range1 = 4;
% params.step = .01; 
% 
% params.figId = 10;
% params.axisId = 2;
% plotSmoothLoss3D(params);


end

