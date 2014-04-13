
clc;

N = 500;
D = 5;
LMin = 30;
LMax = 100;
NTests = 200;

L = zeros(4, NTests);

for k = 1:NTests
    fprintf('Test #%d of %d \n', k, NTests);
    [X,t] = generateTestData(N, D, [LMin LMax]);
    X = normalizeData(X);
    fprintf('Training data: N = %d, D = %d. \n', N, D);

    L(1,k) = getMinimal01LossByBPM(X,t);
    L(2,k) = getMinimal01LossBySVM(X,t);
    L(3,k) = getMinimal01LossByLR(X,t);
    L(4,k) = getMinimal01LossByALA(X,t);
    
    fprintf('Loss [LR, SVM, BPM, ALA] = %s.\n', mat2str(L(:,k)',4));
end

[lsvm, ids] = sort(L(3,:));
L = L(:,ids);
pl = plot(1:NTests, L(1,:), '-c', 1:NTests, L(2,:), '-b', ...
    1:NTests, L(3,:), '-r', 1:NTests, L(4,:), '-g');
set(pl,'LineWidth',1);
legend('Bayes Point Machine', 'Support Vector Machine', ...
    'Logistic Regression', 'ALA Algorithm');
xlabel('Test No.');
ylabel('0-1 Loss');
fprintf('Average Loss [LR, SVM, BPM, ALA] = %s.\n', mat2str(mean(L,2)',4));

