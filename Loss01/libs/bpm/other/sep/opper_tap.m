function [e,m,run] = opper_tap(x)

global show_progress
[d,n] = size(x);

if 0
  mp = get_mean(prior);
  vp = get_cov(prior);
  vp = vp(1,1);
else
  mp = zeros(d,1);
  vp = 1;
end

alpha = zeros(n,1);
c = vp*(x'*x);
dc = diag(c);
lambda = dc;
blambda = zeros(n,1);

run.m = [];
run.flops = [];

step = 0.5;
old_activity = 0;
delta = zeros(size(alpha));

niters = 500;
for iter = 1:niters
  old_alpha = alpha;
  h = c*alpha;
  for i = 1:n
    xm = h(i) - lambda(i)*alpha(i);
    xvx = sqrt(lambda(i));
    z = xm/xvx;
    delta(i) = exp(gauss_logProb(z,0,1) - gauss_logcdf(z))/xvx - alpha(i);
  end
  activity = sum(delta.^2);
  if activity < old_activity
    step = step*1.1;
  else
    step = step/2;
  end
  if step < 1e-4
    step = 1e-4;
  end
  old_activity = activity;
  
  alpha = old_alpha + step*delta;

  flops_here = flops;
  run.m(:,iter) = x*alpha;
  run.flops(iter) = flops;
  flops(flops_here);
  
  if show_progress
    disp(max(abs(delta)))
  end
  if max(abs(delta)) < 1e-8
    break
  end

  if rem(iter,20) == 10
    h = (c*alpha).*alpha;
    i = find(alpha > 0);
    blambda(i) = lambda(i).*(1./h(i) - 1);
    i = find(alpha == 0);
    blambda(i) = 1e8;

    lambda = 1./diag(inv(diag(blambda) + c)) - blambda;
    i = find(blambda >= 1e8);
    lambda(i) = dc(i);
    if any(lambda < 0)
      error('lambda < 0')
    end
  end
end
if iter == niters
  disp('not enough iters')
end

m = x*alpha;
% negative of Winther's TAP Gibbs free energy (3.88 in thesis)
e = -1/2*(m'*m)*vp - 1/2*logdet(diag(blambda)+c);
% this cancels the redundant lambda/(lambda+blambda) terms
e = e - n/2;
for i = 1:n
  xm = vp*x(:,i)'*(m - x(:,i)*alpha(i));
  xx = vp*x(:,i)'*x(:,i);
  xvx = sqrt(xx);

  e = e + 1/2*blambda(i)/(blambda(i)+lambda(i));
  e = e + 1/2*log(lambda(i) + blambda(i));

  % entropy term
  e = e + gauss_logcdf(xm/xvx) + 1/2*alpha(i)^2*lambda(i);
  e = e + 1/2*lambda(i)/(blambda(i)+lambda(i));
end

