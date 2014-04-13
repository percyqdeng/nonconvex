function compareClassifiers()

totalTime = zeros(1,2);
totalRuns = zeros(1,2);

for k = 1:100
    
    generateData();
    [X,t] = readData();
    
    w = smoothLossSGD(X,t);
    tic; 
    [w1,runs1] = smoothLossLocalOptimizerV1(X, t, w, 0.05); 
    totalTime(1) = totalTime(1) + toc;
    totalRuns(1) = totalRuns(1) + runs1;
    tic;
    [w2,runs2] = smoothLossLocalOptimizer(X, t, w, 0.05); 
    totalTime(2) = totalTime(2) + toc;
    totalRuns(2) = totalRuns(2) + runs2;
    
end

totalTime
totalRuns

end

