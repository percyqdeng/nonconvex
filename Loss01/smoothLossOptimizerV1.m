function w = smoothLossOptimizer(X, t, w)

K=10;
radius = 2;
step = 0.1;
min_loss = calSmoothLoss(X,t,K,w,w0)
updated = 1;
runs = 0;

if min_loss < 2
    return;
end

while updated == 1
    updated = 0;
    s = step;
    while s <= radius
        d = 1;
        while updated == 0 && d <= D
            runs = runs + 1;
            wt = w;
            wt(d) = w(d) + s;
            loss = calSmoothLoss(X,t,K,wt,w0);
            if (loss < min_loss)
                min_loss = loss;
                w = wt;
                done = 0;
                while done == 0
                    wt(d) = wt(d) + step;
                    loss = calSmoothLoss(X,t,K,wt,w0);
                    if loss < min_loss
                        min_loss = loss;
                        w = wt;
                    else
                        done = 1;
                    end
                end
                updated = 1;
                break;
            end
            wt(d) = w(d) - s;
            loss = calSmoothLoss(X,t,K,wt,w0);
            if (loss < min_loss)
                min_loss = loss;
                w = wt;
                done = 0;
                while done == 0
                    wt(d) = wt(d) - step;
                    loss = calSmoothLoss(X,t,K,wt,w0);
                    if loss < min_loss
                        min_loss = loss;
                        w = wt;
                    else
                        done = 1;
                    end
                end
                updated = 1;
                break;
            end
            d = d + 1;
        end

        if updated == 1
            break;
        else
            s = s + step;
        end
    end
end

end