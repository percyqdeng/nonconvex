function [s,m,v] = adf_step(x, prior)

[d,N] = size(x);

if nargin < 2
  m = zeros(d,1);
  v = eye(d);
else
  m = get_mean(prior);
  v = get_cov(prior);
end

s = 0;
for i = 1:N
  vx = v*x(:,i);
  xvx = x(:,i)'*vx;
  sxvx = sqrt(xvx);
  xm = x(:,i)'*m;
  z = xm/sxvx;
  s = s + gauss_logcdf(z);
  alpha = exp(gauss_logProb(z,0,1) - gauss_logcdf(z))/sxvx;
  m = m + vx*alpha;
  v = v - vx*(alpha*(x(:,i)'*m)/xvx)*vx';
end
