%INPUT: data [X,t], weights w, linear loss approximation slope K, 
%regularisation coefficient R. OUTPUT: total linearly approximated loss 
function loss = calLinearLoss(X, t, K, w, R)

L = t .* (X*w);     %eval t_n w^T x_n at each point
L = -K * L + 0.5;   %eval l(x) = K * x + 1/2 at each point
L(L<0) = 0;         %equivalent to l(x)=0 for x <= -1/2K
L(L>1) = 1;         %equivalent to l(x)=1 for x >=  1/2K
loss = sum(L) + 0.5 * R * (w' * w);


end