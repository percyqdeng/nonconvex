
clc;

N=30;
NTests = 20;
DTests = 3:6;

bnbT = zeros(1,10);
pcsT = zeros(1,10);
lpT = zeros(1,10);

L = zeros(3,NTests);

for D = DTests
    for k = 1:NTests
        fprintf('D = %d. Test #%d of %d \n', D, k, NTests);
        [X,t] = generateTestData(N, D, [3 5]);
        fprintf('Training data: N = %d, D = %d. \n', N, D);

        tic; 
        [pred, l1] = getBnBOptimalPredictionVector2(X, t);
        bnbT(D)= bnbT(D) + toc;

        tic; 
        w = getWeightsByPointsSelection2(X, t);
        pcsT(D) = pcsT(D) + toc;
        l2 = cal01Loss(X,t,w);
        
        tic; 
        w = getWeightsByLP(X, t);
        lpT(D) = lpT(D) + toc;
        l3 = cal01Loss(X,t,w);
        L(:,k) = [l1; l2; l3];
        if (l1 ~= l2 || l1 ~= l3)
            fprintf('***Loss Difference Detected: L1 = %d, L2 = %d, L3 = %d.\n', l1, l2, l3);
        end
    end
end

bnbT = bnbT / NTests;
pcsT = pcsT / NTests;
lpT = lpT / NTests;

figure(1);
plot(DTests, bnbT(DTests), '-b', DTests, pcsT(DTests), '-r', DTests, lpT(DTests), '-c'); 
legend('BnB', 'PCS', 'LP');
xlabel('Number of Dimensions');
ylabel('Running Time');
