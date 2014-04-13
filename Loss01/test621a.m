
clc;

NTests = 500;
T = zeros(2,NTests);
L = zeros(2,NTests);

for k = 1:NTests
    fprintf('Test #%d of %d \n', k, NTests);
    N = randi(10) + 15;
    D = randi(3) + 1;
    [X,t] = generateTestData(N, D, [2 N/3]);
    X = normalizeData(X);
    %fprintf('Training data: N = %d, D = %d. \n', N, D);
    
    tic; 
    [pred, loss] = getBnBOptimalPredictionVector2(X, t);
    T(1,k) = toc;
    L(1,k) = loss;
    %fprintf('BnB Loss: %d. Time: %f\n', L(1,k) , T(1,k));

    tic, w = getWeightsByPointsSelection4(X, t);
    T(2,k) = toc;
    L(2,k) = cal01Loss(X,t,w);
    %fprintf('CS Loss: %d. Time: %f\n', L(2,k) , T(2,k));
    
    if (L(1,k) ~= L(2,k))
        fprintf('Different l1= %d, l2= %d', L(1,k), L(2,k));
    end
    tic, w = getWeightsByLinearSVM(X,t);
    %fprintf('Linear SVM Loss: %d. Time: %f\n', cal01Loss(X,t,w), toc);
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
