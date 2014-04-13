function main_test2()

clc;
[X,t] = generateTestData(249, 10, [1 20]);
X = normalizeData(X);

D = [t,X(:,2:end)];
csvwrite('data\data_small.csv',D);

[N,D] = size(X);
fprintf('Training data: N = %d, D = %d. \n', N, D-1);

%find (minimal loss) solution by Points Selection method,
tic
w_psl = getWeightsByPointsSelection2(X,t,30);
printSolution('PS solution', X, t, w_psl);
toc

%find (minimal loss) solution by Points Selection method,
tic
w_lpr = getWeightsByLP(X,t);
printSolution('LP solution', X, t, w_lpr);
toc

%show all solutions on one graph
c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2
 
[X1_psl, X2_psl] = getEndPointsOfDecisionLine(X, w_psl);
[X1_lpr, X2_lpr] = getEndPointsOfDecisionLine(X, w_lpr);

figure(1);
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_psl, X2_psl, 'b-', ...
    X1_lpr, X2_lpr, 'm-');

legend('Class 0', 'Class 1', ...
    'Points Selection', ...
    'Linear Programming');


end

