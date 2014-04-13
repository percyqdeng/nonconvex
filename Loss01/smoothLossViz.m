function smoothLossViz(X, t, w, K, R)

params.X = X; params.t = t; 
params.w = w; 
params.K = K; params.R = R; 
params.range0 = -4; params.range1 = 4;
params.step = .001; 

for d=1:length(X(1,:)) %find(w>0.1)' 
    params.figId = 300 + d; 
    params.axisId = d;
    plotSmoothLossCuttingPlane(params);
end


end