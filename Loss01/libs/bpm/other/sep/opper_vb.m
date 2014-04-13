function [e,m] = opper_vb(x, prior)

global show_progress

[d,n] = size(x);

mp = get_mean(prior);
vp = get_cov(prior);
vp = vp(1,1);

alpha = zeros(n,1);
c = vp*(x'*x);
c = c + eye(n)*10;
ic = inv(c);
lambda = 1./diag(ic);

step = 0.01;
delta = zeros(size(alpha));
old_activity = 0;

for iter = 1:100
  old_alpha = alpha;
  for i = 1:n
    xm = c(i,:)*alpha - lambda(i)*alpha(i);
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
  old_activity = activity;

  alpha = alpha + step*delta;

  max_delta = max(abs(alpha-old_alpha));
  if show_progress
    disp(max_delta)
  end
  if max_delta < 1e-4
    break
  end
end
if iter == 100
  disp('opper_vb: Not enough iterations')
end

m = x*alpha;
e = -1/2*(alpha'*c*alpha) -1/2*logdet(c) + 1/2*sum(log(lambda));
for i = 1:n
  xm = c(i,:)*alpha - lambda(i)*alpha(i);
  xvx = sqrt(lambda(i));
  e = e + gauss_logcdf(xm/xvx) + 1/2*alpha(i)^2*lambda(i);
end
