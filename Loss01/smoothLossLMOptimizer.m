%Levenberg-Marquardt optimization, 
%K = initial smoothness, R = initial radius
function w = smoothLossLMOptimizer(X, t, w)


for K = [2 20 200 2000]
    stop = 0;
    lambda = 0.1;
    while stop == 0
        wt = w - (H + lambda * diag(H))-1 d;
        lt = calSmoothLoss(X, t, K, wt);
        if loss - lt > epsilon
            w = wt;
            loss = lt;
            lambda = lambda / 10;
        else
            lambda = lambda * 10;
        end
    end
end

end