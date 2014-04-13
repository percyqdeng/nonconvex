% Given training set X, t
% Return minimal 01 loss by logistic regression
function minw = getBestWeightsByLR(X, t)

minLoss = 1e10;

for C = 2 .^ [0 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0.5 1 2 4 6 8 10]

    model = train(t,sparse(X),['-s 0 -c ', num2str(C), ' -e 0.0001']);
    w = model.w';
    l = cal01Loss(X,t,w);
    l1 = cal01Loss(X,t,-w);
    if (l < minLoss)
        minLoss = l;
        minw = w;
    elseif (l1 < minLoss)
        minLoss = l1;
        minw = -w;
    end
end


end
