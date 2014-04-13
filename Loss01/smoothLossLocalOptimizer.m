%INPUT: samples [X,t], given weights w, 
%       smoothness K of sigmoid loss, regul. coeff. R
%OUTPUT: w corresponding to local minimal of loss using modif. grad descent
function w = smoothLossLocalOptimizer(X, t, w, K, R)

loss = calSmoothLoss(X, t, w, K, R);
grad = calSmoothLossGradient(X, t, w, K, R);
while max(abs(grad)) > 0.01
    loss2 = 1e9;
    rate = 0.1;
    w2 = w - rate * grad;
    while (rate >= 1e-6) && (loss - loss2 < 0.1)
        loss2 = calSmoothLoss(X, t, w2, K, R);
        if loss - loss2 < 0.1
            rate = rate / 10;       %reduce rate = reduce change in w
            w2 = w - rate * grad;   %try smaller change see if loss reduced
        end
    end
    
    if rate >= 1e-6                 %exists w2 with lower loss
        w = w2;
        loss = loss2;
        grad = calSmoothLossGradient(X, t, w, K, R);
    else
        break;
    end
    
end


end