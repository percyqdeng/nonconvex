
clc;

D = 4; % dimension of data
NRange = [50];
Times = zeros(length(NRange), 2);
for n = 1:length(NRange) %number of data points
    NTests = 10; % number of test per each N to get average result
    TestTimes = zeros(1, 2);
    N = NRange(n);
    for k = 1:NTests %number of tests
        fprintf('N = %d. Test #%f of %f \n', N, k, NTests);
        [X,t] = generateTestData(N, D, 0.2);
        
        tic;    fprintf('Testing PS1 algorithm \n');
        w = getWeightsByPointsSelection2(X, t);
        TestTimes(1) = TestTimes(1) + toc;
        
        tic;    fprintf('Testing PS2 algorithm \n');
        w = getWeightsByPointsSelection3(X, t);
        TestTimes(2) = TestTimes(2) + toc;
    end
    Times(n,1:2) = TestTimes(1:2) / NTests;
end 

B = bar(NRange, Times);
legend('Basic Algorithm', 'Prioritized Algorithm');
xlabel('Training Dataset Size (# points)');
ylabel('Time Reaching Optimal Solution (seconds)');
set(B(1),'FaceColor',[1 0.7 0.4]);
set(B(2),'FaceColor',[0 1 1]);
