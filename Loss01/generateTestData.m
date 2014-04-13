%generate 01 loss data points and write to data.csv
function [X, t] = generateTestData(N, D, lossRange)

NC = 2;     %number of clusters
StdDev = 6; %Max standard deviation of points in each clusters
%range of all points +/- R ~ dis c1 c2
R = random('Uniform', StdDev-3, StdDev+3, 1, 1);     

if length(lossRange) > 1
    minLoss = lossRange(1);
    maxLoss = lossRange(2);
else
    minLoss = N * (lossRange - 0.05);
    maxLoss = N * (lossRange + 0.10);
    if minLoss <= 0, minLoss = 1; end
    if maxLoss <= 0, maxLoss = 5; end
    if lossRange == 0, minLoss = 2; maxLoss = N/3; end
end

loss = 0;

while (loss < minLoss || loss > maxLoss)

    c = zeros(NC, D);
    sd = zeros(NC, D);
    for i=1:NC
        %generate center of cluster i
        if (mod(i,4) == 1)
            c(i,:) = random('Uniform', 0, R/2, 1, D);   
        elseif (mod(i,4) == 2)
            c(i,:) = random('Uniform', -R/2, 0, 1, D);  
        elseif (mod(i,4) == 3)
            c(i,:) = R/2 * ones(1,D);
            c(i,1) = - c(i,1);
        else
            c(i,:) = R/2 * ones(1,D);
            c(i,2) = - c(i,2);
        end
        sd(i,:) = random('Uniform', 1, StdDev, 1, D); %std dev in each direction from c(i)
    end

    X = ones(N,D+1);
    t = ones(N,1);

    for i=1:N
        k = mod(i,NC) + 1; %k = idx of the cluster to use

        %determine class (1 or -1)
        if (mod(k,2) == 1)
            t(i) = 1;
        else
            t(i) = -1;
        end

        %generate data point
        for j=1:D
            X(i,j+1) = random('Normal',c(k,j),sd(k,j),1,1);
        end
    end

    X2 = normalizeData(X);
    w = getWeightsByLogisticRegression(X2,t);
    w = smoothLossOptimizer(X, t, w, 0);
    loss = cal01Loss(X, t, w);
    %fprintf('Generated data with N = %d, D = %d, Loss = %d \n', N, D, loss);
end

% c1Idx = ( t(:) == 1 );  %indices of class 1
% c2Idx = ( t(:) == -1);  %indices of class 2
% plot(X(c1Idx,2),X(c1Idx,3), 'm+', X(c2Idx,2),X(c2Idx,3),'co');
    
end

