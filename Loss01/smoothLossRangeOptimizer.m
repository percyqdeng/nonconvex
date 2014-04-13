function w = smoothLossRangeOptimizer(X, t, w, radius, step_size)

K = 200;
w_min = w;
min_loss = calSmoothLoss(X, t, K, w);

updated = 1;
while updated == 1
    updated = 0;
    for d = 1:length(w)
        for step = -radius:step_size:radius
            wt = w;
            wt(d) = w(d) +  step;
            loss = calSmoothLoss(X, t, K, wt);
            if loss < min_loss
                w = wt;
                min_loss = loss;
                updated = 1;
            end
        end
    end
end

end