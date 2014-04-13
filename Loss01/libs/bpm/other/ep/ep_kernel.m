function [s,alpha,run] = ep_kernel(C, e)
% C is the n by n kernel matrix, prescaled by Y.
% e is the label error rate.
% s is the evidence.
% alpha is the sample weighting vector for classification.
% run gives information about the run.

if nargin < 2
  e = 0;
end

n = rows(C);

% a(i) is scale for term i
% m(i) is x(:,i)'*m(:,i)
% v(i) is variance for term i
a = zeros(1,n);
m = ones(1,n);
% this makes the first pass equal to ADF
% matlab 6 doesn't like inf here
v = ones(1,n)*1e8;

% alpha represents the final mw,vw
alpha = zeros(1,n);
h = zeros(1,n);
lambda = diag(C);
A = C;

run.alpha = [];
run.flops = [];
count = 0;

niters = 20;
for iter = 1:niters
  old_m = m;
  old_v = v;
  for i = 1:n
    h(i) = (m./v)*A(:,i);
    lambda(i) = inv(inv(A(i,i)) - inv(v(i)));
    if lambda(i) < 0
      error('lambda(i) < 0')
    end
    h0 = h(i) + lambda(i)/v(i)*(h(i) - m(i));

    z = h0/sqrt(lambda(i));
    if e == 0
      % logcdf is expensive, so reuse it
      true = gauss_logcdf(z);
      alpha(i) = exp(gauss_logProb(z,0,1) - true)/sqrt(lambda(i));
    else
      true = e + (1-2*e)*exp(gauss_logcdf(z));
      alpha(i) = (1-2*e)*exp(gauss_logProb(z,0,1))/true/sqrt(lambda(i));
      true = log(true);
    end
    h(i) = h0 + lambda(i)*alpha(i);
    
    v(i) = lambda(i)*(1/(alpha(i)*h(i)) - 1);
    m(i) = h(i) + v(i)*alpha(i);
    a(i) = true + 0.5*alpha(i)*lambda(i)/h(i) + 0.5*log(1+lambda(i)/v(i));
  
    if inv(v(i)) ~= inv(old_v(i))
      delta = inv(inv(v(i)) - inv(old_v(i)));
      A = A - A(:,i)*(A(i,:)/(delta + A(i,i)));
      %dv = diag(v);
      %A = dv - dv*inv(C + dv)*dv;
      %A = inv(inv(C) + inv(dv));
    end
  end
  
  if nargout > 2
    count = count + 1;
    run.alpha(:,count) = alpha';
    run.flops(count) = flops;
  end
  
  if max(abs(m - old_m)) < 1e-4
    break
  end
  if e == 0 & min(v) < 1e-10
    error('data is not separable')
  end
end
if iter == niters
  disp('not enough iters')
end

if any(v < 0)
  warning('some v(i) < 0')
end

s = m./v;
s = s*A*s' - sum(m.^2./v);
s = s/2 + sum(a);
dv = diag(v);
s = s + 0.5*sum(log(v)) - 0.5*logdet(C + dv);
% this is equivalent to the above
%s = s + 0.5*logdet(A) - 0.5*logdet(C);
