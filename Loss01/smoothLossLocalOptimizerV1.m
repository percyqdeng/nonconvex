%This version doesn't take into account the local gradient
%and uses minimal step = resolution to update => can be slow
function w = smoothLossLocalOptimizerV1(X, t, w, resolution)

K = 100;
min_loss = calSmoothLoss(X, t, K, w);
steps = resolution * [2 -2 1 -1];

for d = length(w):-1:1
    for s=1:length(steps)
        wt = w;
        wt(d) = w(d) + steps(s);
        loss = calSmoothLoss(X, t, K, wt);
        if loss < min_loss
            step = sign(steps(s)) * resolution;
            while loss < min_loss
                min_loss = loss;
                w = wt;
                wt(d) = wt(d) + step;
                loss = calSmoothLoss(X, t, K, wt);
            end            
            break;
        end
    end
end

w = w / norm(w);

end