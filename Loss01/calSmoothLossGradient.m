function grad = calSmoothLossGradient(X, t, w, K, R)

S = logsig((-K * t) .* (X*w));
S = -K * (S .* (1 - S));
L = S .* t;
grad = X' * L + R * w;

end