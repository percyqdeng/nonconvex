load nlinsep.mat
global p1
ker = 'linear';
% try using different kernels, e.g.
%ker='rbf';  % Gaussian kernel
%p1=0.5;  % width of Gaussian kernel
[alpha,bias,K,margin] = svc(X,Y,ker,1000);
svcplot(X,Y,ker,alpha,bias);

b = (radius(X,K)/margin)^2;
% predict generalization error (lower is better)
fprintf('margin bound on generalization error = %g\n', b);

% classify a new data point
Xt = [2 2];
Kt = svkernelmtx(ker,Xt,X);
sign(Kt*diag(Y)*alpha + bias)
