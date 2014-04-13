
clc;

D = 8; % dimension of data
N = 5000;
NTests = 30;
T = zeros(2,NTests);
L = zeros(2,NTests);

for k = 1:NTests
    fprintf('Test #%d of %d \n', k, NTests);
    [X,t] = generateTestData(N, D, 0);
    X = normalizeData(X);
    fprintf('Training data: N = %d, D = %d. \n', N, D);
    
    tic, w = getWeightsByPointsSelection3(X, t);
    T(1,k) = toc;
    L(1,k) = cal01Loss(X,t,w);
    fprintf('CS Approx Loss: %d. Time: %f\n', L(1,k) , T(1,k));

    tic, w = getWeightsByALA(X, t);
    T(2,k) = toc;
    L(2,k) = cal01Loss(X,t,w);
    fprintf('ALA Approx Loss: %d. Time: %f\n', L(2,k) , T(2,k));
    
    tic, w = getWeightsByLinearSVM(X,t);
    fprintf('Linear SVM Loss: %d. Time: %f\n', cal01Loss(X,t,w), toc);
end

figure(1);
subplot(1,2,1);
errorbar([mean(T(1,:)) mean(T(2,:))], [std(T(1,:)) std(T(2,:))], 'xb');
set(gca,'XTickLabel',{'','CSA','','ALA',''});
xlabel('Algorithms');
ylabel('Average Running Time');
subplot(1,2,2);
errorbar([mean(L(1,:)) mean(L(2,:))], [std(L(1,:)) std(L(2,:))], 'xb');
set(gca,'XTickLabel',{'','CSA','', 'ALA',''});
xlabel('Algorithms');
ylabel('Average 0-1 Loss Returned');
