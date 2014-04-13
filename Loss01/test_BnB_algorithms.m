
clc;

D = 2; % dimension of data
NRange = [100 15 20 25 30 40 50];
Times = zeros(length(NRange), 6);
for n = 1:length(NRange) %number of data points
    NTests = 3; % number of test per each N to get average result
    TestTimes = zeros(1, 6);
    N = NRange(n);
    for k = 1:NTests %number of tests
        fprintf('N = %d. Test #%f of %f \n', N, k, NTests);
        [X,t] = generateTestData(N, 0.25);
        
        tic;    fprintf('Testing Final algorithm \n');
        [w, t0] = getWeightsByBranchAndBound4(X, t);
        fprintf('T0 = %d. T1 = %d \n', t0, toc);
        return;
        loss1 = cal01Loss(X,t,w);
        if t1>=200, t0 = 200; t1 = 200; end
        if t0 <= 0, t0 = t1; end
        TestTimes(5:6) = TestTimes(1,5:6) + [t0 t1];
        
        tic;    fprintf('Testing BFS algorithm \n');
        [w, t0] = getWeightsByBranchAndBound2(X, t);
        t1 = toc;
        loss2 = cal01Loss(X,t,w);
        if t1>=200
            t1 = 200; 
            if loss2 > loss1, t0 = 200; end
        end
        if t0 <= 0, t0 = t1; end
        TestTimes(1:2) = TestTimes(1,1:2) + [t0 t1];

        tic;    fprintf('Testing LP algorithm \n');
        [w, t0] = getWeightsByBranchAndBound3(X, t);
        t1 = toc;
        loss3 = cal01Loss(X,t,w);
        if t1>=200
            t1 = 200; 
            if loss2 > loss1, t0 = 200; end
        end
        if t0 <= 0, t0 = t1; end
        TestTimes(3:4) = TestTimes(1,3:4) + [t0 t1];


    end
    Times(n,1:6) = TestTimes(1:6) / NTests;
end 

B = bar(NRange, Times);
legend('BFS - T0', 'BFS - T1', 'LP - T0', 'LP - T1', 'FINAL - T0', 'FINAL - T1');
xlabel('Training Dataset Size (# points)');
ylabel('Time (seconds)');
set(B(1),'FaceColor',[1 0.7 0.4]);
set(B(2),'FaceColor',[0.87 0.49 0]);
set(B(3),'FaceColor',[0 1 1]);
set(B(4),'FaceColor',[0.043 0.52 0.78]);
set(B(5),'FaceColor',[0 1 0]);
set(B(6),'FaceColor',[0.17 0.5 0.34]);
