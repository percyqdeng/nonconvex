function m = svm_linear(X,Y,has1)

[n,d] = size(X);
ker = 'linear';
if nargin > 2 & strcmp(has1, 'has1')
  X1 = X;
else
  X1 = [X ones(n,1)];
end
C = Inf;
[alpha,bias] = svc(X1,Y,ker,C,0);
m = ((alpha.*Y)'*X1)';
