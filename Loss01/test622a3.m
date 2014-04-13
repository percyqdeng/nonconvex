
clc;
clear;

NTests = 50;
N = 200;
D = 10;

ilpT = zeros(1,length(NTests));
ilpL = zeros(1,length(NTests));

for k = 1:NTests
    fprintf('D = %d. Test #%d of %d \n', D, k, NTests);
    [X,t] = generateTestData(N, D, [6 60]);
    fprintf('Training data: N = %d, D = %d. \n', N, D);

    tic; 
    w = getWeightsByLP(X, t);
    ilpT(k) = toc;
    ilpL(k) = cal01Loss(X,t,w);
    fprintf('Time: %f; Loss: %d. \n', ilpT(k), ilpL(k));
end

