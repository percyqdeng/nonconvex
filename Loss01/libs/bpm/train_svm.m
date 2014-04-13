function alpha = train_svm(task)

if isempty(task.kernel)
  Y = task.data(:,end);
  X = scale_rows(task.data,Y);
  K = X' * X;
else
  X = task.X;
  Y = task.Y;
  K = feval(task.kernel, X, X, task.kernel_args{:});
end
% addpath('other/svm')
Cslack = Inf;
[alpha,bias,K,margin] = svc(X,Y,K,Cslack,0);

b = (radius(X,K)/margin)^2;
fprintf('margin bound = %g\n', b);

% span bound
epsilon = svtol(Cslack);
svii = find( alpha > epsilon & alpha < (Cslack - epsilon));
Ksv = K(svii,svii);
q = alpha(svii)./diag(inv(Ksv)) - 1;
%q = alpha(svii) - diag(inv(Ksv));
b = sum(q > 0);
fprintf('span bound = %g\n', b);

if 0
obj = bpm_ep(task);
obj = set_X(obj,X);
obj = set_Y(obj,Y);
s = struct(obj);
s.alpha = alpha;
end
