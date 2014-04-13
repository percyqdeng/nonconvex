%calculate & return loss for the data given weights. 
%X has last column = 1 corresp. to bias w0 at end of w
function loss = cal01Loss(X, t, w)

Y = t .* (X * w);
loss = sum(Y < -1e-30);

%loss = sum(Y < -1e-9);


end
