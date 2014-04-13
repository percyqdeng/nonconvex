function [s,m,v,run] = tm_step(x, e, prior)
% EP with diagonal Gaussian approximation
% x is a matrix of columns
% prior is a normal_density

global show_progress

[d,n] = size(x);

if nargin < 2
  e = 0;
end

if nargin < 3
  mp = zeros(d,1);
  vp = 1;
else
  mp = get_mean(prior);
  vp = get_cov(prior);
  vp = vp(1,1);
end

% a(i) is scale for term i
% m(:,i) is mean for term i
% v(i) is variance for term i
a = zeros(1,n);
m = zeros(d,n);
% this makes the first pass equal to ADF
v = ones(1,n)*Inf;

run.m = [];
run.flops = [];

vw = vp;
mw = mp;

niters = 20;
for iter = 1:niters
  old_m = m;
  for i = 1:n
    v0 = inv(inv(vw) - inv(v(i)));
    if v0 < 0
      error('v0 < 0')
    end
    m0 = mw + v0/v(i)*(mw - m(:,i));
    
    xm = x(:,i)'*m0;
    xv0x = v0*(x(:,i)'*x(:,i));
    z = xm/sqrt(xv0x);
    alpha = exp(gauss_logProb(z,0,1) - gauss_logcdf(z))/sqrt(xv0x);
    mw = m0 + v0*alpha*x(:,i);
    xmw = xm + xv0x*alpha;
    vw = v0*(1 - alpha*xmw/d);
    
    if alpha == 0
      v(i) = 1e10;
    else
      v(i) = v0*(d/(alpha*xmw) - 1);
    end
    if v(i) < 0
      error('v < 0')
    end
    % this works for any v(i)
    m(:,i) = m0 + (v(i) + v0)*alpha*x(:,i);

    p = gauss_logProb(m(:,i), m0, (v(i)+v0)*eye(d));
    p = p + d/2*log(2*pi*v(i));
    if e == 0
      true = gauss_logcdf(z);
    else
      true = log(e + (1-2*e)*exp(gauss_logcdf(z)));
    end
    a(i) = true - p;
    
    if 0
      % check gradient constraint for m0
      old_m0 = m0(1);
      ms = (-1:0.1:1) + m0(1);
      exact = [];
      approx = [];
      for j = 1:length(ms)
	m0(1) = ms(j);
	exact(j) = gauss_logcdf(x(:,i)'*m0/sqrt(xv0x));
	approx(j) = a(i) + d/2*log(2*pi*v(i)) + ...
	    gauss_logProb(m(:,i), m0, (v(i)+v0)*eye(d));
      end
      figure(3)
      plot(ms, exact, ms, approx)
      ax = axis;
      line([old_m0 old_m0], [ax(3) ax(4)], 'Color', 'red');
      m0(1) = old_m0;
      pause
    end
    if 0
      % check gradient constraint for v0
      %gv = -1/2*alpha*xm/v0
      %hv = -d/2/(v(i)+v0) + (m(:,i)-m0)'*(m(:,i)-m0)/(v(i)+v0)^2/2
      old_v0 = v0;
      vs = (0.1:0.1:2);
      vs = exp((log(old_v0)-1):0.1:(log(old_v0)+1));
      exact = [];
      approx = [];
      for j = 1:length(vs)
	v0 = vs(j);
	xv0x = v0*(x(:,i)'*x(:,i));
	exact(j) = gauss_logcdf(xm/sqrt(xv0x));
	approx(j) = a(i) + d/2*log(2*pi*v(i)) + ...
	    gauss_logProb(m(:,i), m0, (v(i)+v0)*eye(d));
      end
      figure(3)
      plot(vs, exact, vs, approx)
      ax = axis;
      line([old_v0 old_v0], [ax(3) ax(4)], 'Color', 'red');
      v0 = old_v0;
      pause
    end
  end
  
  run.m(:,iter) = mw;
  run.flops(iter) = flops;
  
  if show_progress
    s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
    for i = 1:n
      s = s + m(:,i)'*m(:,i)/v(i);
    end
    ev(iter) = d/2*log(2*pi*vw) -1/2*s + sum(a) - d/2*log(2*pi*vp);
  end

  if max(max(abs(m - old_m))) < 1e-4
    break
  end
end
if iter == niters
  disp('not enough iterations')
end

if show_progress
  figure(2)
  plot(ev)
end

s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
for i = 1:n
  s = s + m(:,i)'*m(:,i)/v(i);
end
s = d/2*log(2*pi*vw) -1/2*s + sum(a) - d/2*log(2*pi*vp);
m = mw;
v = vw;
