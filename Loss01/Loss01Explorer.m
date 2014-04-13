function w = Loss01Explorer(X, t, w)

radius = 10;
stepSize = 0.05;
min_loss = cal01Loss(X, t, w);   
%determine set of steps to explore for lower loss
Ns = floor(radius/stepSize);
steps = zeros(1, 2*Ns);
for i=1:Ns
    steps(2*i-1) = i*stepSize;
    steps(2*i) = -i*stepSize;
end

for d = 1:length(w)
    %find a new w along axis d that have lower loss (=better valey of loss) 
    for step = steps 
        wt = w;
        wt(d) = w(d) +  step;
        loss = cal01Loss(X, t, wt);
        if (loss < min_loss)
            w = wt;
            min_loss = loss;
        end
    end
end

end