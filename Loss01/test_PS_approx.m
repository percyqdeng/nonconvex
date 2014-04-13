
clc;
D = 3; % dimension of data
N = 100;
[X,t] = generateTestData(N, D, 0.1);

tic 
w2 = getWeightsByPointsSelection(X,t);
fprintf('PS finished after %f sec\n', toc);
tic
w3 = getWeightsByPointsSelection2(X,t);
fprintf('PS2 finished after %f sec\n', toc);

cal01Loss(X,t,w2)
cal01Loss(X,t,w3)
c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2

[X1_ps2, X2_ps2] = getEndPointsOfDecisionLine(X, w2);
[X1_ps3, X2_ps3] = getEndPointsOfDecisionLine(X, w3);
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_ps2, X2_ps2, 'm-', X1_ps3, X2_ps3, 'b-');

legend('Class 1', 'Class 2', 'PS2', 'PS3');