
clc;

N = 30;
DMax = 6;
LMax = 6;
LMin = 2;
NTests = 10;

T1 = zeros(NTests, DMax);
T2 = zeros(NTests, DMax);

for D = 2:DMax
    for k = 1:NTests
        fprintf('Test #%d of %d \n', k, NTests);
        [X,t] = generateTestData(N, D, [LMin LMax]);
        X = normalizeData(X);
        fprintf('Training data: N = %d, D = %d. \n', N, D);

        tic, w = getWeightsByBranchAndBound4(X, t);
        T1(k,D) = toc;
        fprintf('BnB Loss: %d.\n', T1(k,D));

        tic, w = getWeightsByPointsSelection2(X, t);
        T2(k,D) = toc;
        fprintf('CS Loss: %d.\n', T2(k,D));
    end
end

times1 = mean(T1(:,2:DMax),1);
times2 = mean(T2(:,2:DMax),1);
plot(2:DMax, times1, '-r', 2:DMax, times2, '-b');
legend('Branch and Bound','Combinatorial Search');
xlabel('Number of Dimensions');
ylabel('Average Running Time');
