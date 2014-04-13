function [e,m,run] = opper_mf(x)

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

run.m = [];
run.flops = [];

alpha = zeros(n,1);
c = vp*(x'*x);
lambda = diag(c);

step = 0.5;
old_activity = 0;

niters = 500;
for iter = 1:niters
  old_alpha = alpha;
  delta = zeros(size(alpha));
  h = c*alpha;
  for i = 1:n
    %m = x*alpha - x(:,i)*alpha(i);
    %xm = vp*x(:,i)'*m;
    xm = h(i) - lambda(i)*alpha(i);
    xvx = sqrt(lambda(i));
    z = xm/xvx;
    delta(i) = exp(gauss_logProb(z,0,1) - gauss_logcdf(z))/xvx - alpha(i);
    %alpha(i) = alpha(i) + step*delta(i);
  end
  activity = sum(delta.^2);
  if show_progress
    disp(activity)
  end
  if activity < old_activity
    step = step*1.1;
  else
    step = step/2;
  end
  old_activity = activity;
  
  alpha = old_alpha + step*delta;

  flops_here = flops;
  run.m(:,iter) = x*alpha;
  run.flops(iter) = flops;
  flops(flops_here);
  
  if max(abs(delta)) < 1e-4
    break
  end
end
if iter == niters
  disp('opper_mf: Not enough iterations')
end

m = x*alpha;
e = -1/2*(m'*m)*vp;
for i = 1:n
  xm = vp*x(:,i)'*(m - x(:,i)*alpha(i));
  xx = vp*x(:,i)'*x(:,i);
  xvx = sqrt(xx);
  e = e + gauss_logcdf(xm/xvx) + 1/2*alpha(i)^2*xx;
end
