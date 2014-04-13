
clc;

D = 4; % dimension of data
N = 80;
NTests = 20;
T1 = zeros(1,NTests);
T2 = zeros(1,NTests);
L1 = zeros(1,NTests);
L2 = zeros(1,NTests);

for k = 1:NTests %number of tests
    fprintf('N = %d. Test #%d of %d \n', N, k, NTests);
    [X,t] = generateTestData(N, D, 0.25);
    
    tic;    fprintf('Testing PS2 algorithm \n');
    w = getWeightsByPointsSelection2(X, t);
    T1(k) = toc;
    L1(k) = cal01Loss(X,t,w);
    
    tic;    fprintf('Testing PS3 algorithm \n');
    w = getWeightsByPointsSelection3(X, t);
    T2(k) = toc;
    L2(k) = cal01Loss(X,t,w);

end

figure(1);
subplot(1,2,1);
errorbar([mean(T1) mean(T2)], [std(T1) std(T2)], 'xb');
set(gca,'XTickLabel',{'','Prioritized CS','','CS Approximation',''});
xlabel('Algorithms');
ylabel('Average Running Time');
subplot(1,2,2);
errorbar([mean(L1) mean(L2)], [std(L1) std(L2)], 'xb');
set(gca,'XTickLabel',{'','Prioritized CS','','CS Approximation',''});
xlabel('Algorithms');
ylabel('Average 0-1 Loss Returned');

