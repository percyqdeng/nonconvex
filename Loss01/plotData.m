function plotData(X,t,w)

if nargin < 3
    c_lgr = findBestLRConstant(X,t);
    c_svm = findBestSVMConstant(X,t);
    w_lgr = getWeightsByLogisticRegression(X,t,c_lgr);
    w_svm = getWeightsByLinearSVM(X,t,c_svm);
    w_bpm = getWeightsByBPM(X,t);
    w_ala = getWeightsByALA(X,t);
    w_lsq = getWeightsByLeastSquare(X,t);
end

c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2
 
[X1_lgr, X2_lgr] = getEndPointsOfDecisionLine(X, w_lgr);
[X1_svm, X2_svm] = getEndPointsOfDecisionLine(X, w_svm);
[X1_bpm, X2_bpm] = getEndPointsOfDecisionLine(X, w_bpm);
[X1_ala, X2_ala] = getEndPointsOfDecisionLine(X, w_ala);
[X1_lsq, X2_lsq] = getEndPointsOfDecisionLine(X, w_lsq);

plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_lsq, X2_lsq, 'b-', ...
    X1_bpm, X2_bpm, 'c-', ...
    X1_svm, X2_svm, 'g-', ...
    X1_lgr, X2_lgr, 'r-', ...
    X1_ala, X2_ala, 'k-' ...
    );
    

legend('Class 1', 'Class 2', 'Least Square', 'BPM', ...
    'SVM', 'LR', 'SLA');


end
