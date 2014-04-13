%INPUT: samples [X,t], given weights w, regul. coeff. R
%OUTPUT: best approx. w corresponding to global min loss
function w = smoothLossOptimizer(X, t, w, R)

K = [2 20 200]; %[1 10 100 1000];
Radius = [8 4 2]; %[10 5 2.5 1.25];
StepSize = [0.2 0.1 0.05]; %[0.2 0.1 0.05 0.025];
updated = 1;
i = 1;
while updated == 1 || i <= length(K)
    w = smoothLossLocalOptimizer(X, t, w, K(i), R);
    [w, updated] = smoothLossExplorer(X,t,w,K(i),R,Radius(i),StepSize(i));
    if updated == 0, i=i+1; end
end


end