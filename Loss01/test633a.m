
clc;

N = 300;
D = 2;
LMin = 60;
LMax = 100;
NTests = 200;
r_max = 0;

for k = 1:NTests
    fprintf('Test #%d of %d \n', k, NTests);
    [X,t] = generateTestData(N, D, [LMin LMax]);
    X = normalizeData(X);
    fprintf('Training data: N = %d, D = %d. \n', N, D);
    l1 = getMinimal01LossByLR(X,t);
    l0 = getMinimal01LossByALA(X,t);
    r = (l1 - l0) / l0;

    if r > r_max
        r_max = r;
        X_max = X;
        t_max = t;
        fprintf('LR = %d, ALA = %d. R =%f.\n', l1, l0, r);
    end

    
end

fprintf('r_max = %f.\n', r_max);
