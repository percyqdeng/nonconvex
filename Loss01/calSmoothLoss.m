function loss = calSmoothLoss(X, t, w, K, R)

L = logsig((-K * t) .* (X*w));
loss = sum(L) + 0.5 * R * (w' * w);

end