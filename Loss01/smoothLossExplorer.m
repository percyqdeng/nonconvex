function [w, updated] = smoothLossExplorer(X, t, w, K, R, radius, stepSize)

updated = 0;
%determine set of steps to explore for lower loss
Ns = floor(radius/stepSize);
steps = zeros(1, 2*Ns);
for i=1:Ns
    steps(2*i-1) = i*stepSize;
    steps(2*i) = -i*stepSize;
end

for d = 1:length(w)
    
    %determine subset of samples that actually affect loss along axis d
    wt = w;
    wt(d) = w(d) + radius;
    L1 = logsig((-K * t) .* (X*wt));
    wt(d) = w(d) - 2*radius;
    L2 = logsig((-K * t) .* (X*wt));
    dL = abs(L1 - L2);
    ids = (dL > 1e-3);  %indices of samples affecting loss along axis d
    Xd = X(ids,:);
    td = t(ids);
 
    %find a new w along axis d that have lower loss (=better valey of loss)
    min_loss = calSmoothLoss(Xd, td, w, K, R);   
    for step = steps 
        wt = w;
        wt(d) = w(d) +  step;
        loss = calSmoothLoss(Xd, td, wt, K, R);
        if (min_loss - loss) > 0.1
            w = wt;
            updated = 1;
            return;
        end
    end
end

end