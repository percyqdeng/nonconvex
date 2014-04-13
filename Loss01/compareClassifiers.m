function compareClassifiers()

clc;
N = 5;
count = zeros(1,N);
sum_loss = zeros(1,N);
diff = 0;

for k = 1:100
    
    %generateData();
    [X,t] = readData();
    
    loss = zeros(1,N);

    tic, w = getWeightsByLeastSquare(X,t); toc
    loss(1) = calLoss(X,t,w);

    tic, w = getWeightsByLogisticRegression(X,t); toc
    loss(2) = calLoss(X,t,w);
    
    tic, w = getWeightsByPerceptron(X,t); toc
    loss(3) = calLoss(X,t,w);
    
    tic, w = getWeightsByLinearSVM(X,t); toc
    loss(4) = calLoss(X,t,w);
        
    %tic, w = smoothLossSGD(X,t); toc
    loss(5) = calLoss(X,t,w);
        
    min_loss = min(loss(:));
    ids = find(loss(:) == min_loss);
    
    count(ids) = count(ids) + 1;
    sum_loss = sum_loss + loss;
    
    break;
    %if (loss(4) > min_loss+1)
    %    loss
    %    break;
    %end
    
end

sum_loss
count
diff

end

