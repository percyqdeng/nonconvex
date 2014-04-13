% Given training set X, t
% find a constant C which give the lowest loss for training set
function bestC = findLeastLossLibLinearConstant(X, t, methodId)

bestC = 0.0;
minLoss = 100000;

for C = 2 .^ [0 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0.5 1 2 4 6 8 10]
    model = train(t,sparse(X),['-s ', num2str(methodId), ...
        ' -c ', num2str(C), ' -e 0.0001']);
    loss = cal01Loss(X, t, model.w');
    if loss < minLoss
        bestC = C;
        minLoss = loss;
    end
    
end

end
