function w = smoothLossLocalOptimizer(X, t, w, smoothness, resolution)

K = smoothness;
min_loss = calSmoothLoss(X, t, K, w);
steps = resolution * [2 -2 1 -1];

for d = length(w):-1:1
    for s=1:length(steps)
        wt = w;
        step = steps(s);
        wt(d) = w(d) + step;
        loss = calSmoothLoss(X, t, K, wt);
        if min_loss - loss > 2 * step
            while min_loss - loss > 2 * step
                while min_loss - loss > 2 * step
                    min_loss = loss;
                    w = wt;
                    step = 2 * step;
                    wt(d) = wt(d) + step;
                    loss = calSmoothLoss(X, t, K, wt);
                end
                
                step = steps(s);
                
                wt = w;
                wt(d) = wt(d) + step;
                loss = calSmoothLoss(X, t, K, wt);
                wtt = w;
                wtt(d) = wtt(d) - step;
                loss2 = calSmoothLoss(X, t, K, wtt);
                if loss2 < loss
                    step = -step;
                    wt = wtt;
                    loss = loss2;
                end
            end
            break;
        end
    end
end

w = w / norm(w);

end