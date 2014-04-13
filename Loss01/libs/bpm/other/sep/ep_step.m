function [s,m,v,run] = ep_step(x, e)
% x is a matrix of columns
% e is the label error rate
% s is the log evidence
% m is the posterior mean
% v is the posterior variance

global show_progress

if nargin < 2
  e = 0;
end

[d,n] = size(x);
% normalize columns (not needed)
%x = normalize_cols(x);

mp = zeros(d,1);
vp = eye(d);

% a(i) is scale for term i
% m(i) is x(:,i)'*m(:,i)
% v(i) is variance for term i
a = zeros(1,n);
m = ones(1,n);
% this makes the first pass equal to ADF
v = ones(1,n)*Inf;

run.m = [];
run.flops = [];

vw = vp;
mw = mp;

niters = 30;
for iter = 1:niters
  old_m = m;
  old_v = v;
  for i = 1:n
    vwx = vw*x(:,i);
    xvwx = x(:,i)'*vwx;
    if finite(v(i))
      v0 = vw + vwx*inv(v(i) - xvwx)*vwx';
      v0x = vwx*(v(i)/(v(i) - xvwx));
      xv0x = 1/(1/xvwx - 1/v(i));
      m0 = mw + v0x/v(i)*(x(:,i)'*mw - m(i));
    else
      v0 = vw;
      v0x = vwx;
      xv0x = xvwx;
      m0 = mw;
    end
    %norm(v0x - v0*x(:,i))
    %norm(xv0x - x(:,i)'*v0*x(:,i))

    xm = x(:,i)'*m0;
    z = xm/sqrt(xv0x);
    if e == 0
      alpha = exp(gauss_logProb(z,0,1) - gauss_logcdf(z))/sqrt(xv0x);
    else
      alpha = (1-2*e)*exp(gauss_logProb(z,0,1)) / ...
	  (e + (1-2*e)*exp(gauss_logcdf(z)))/sqrt(xv0x);
    end
    mw = m0 + v0x*alpha;
    xmw = x(:,i)'*mw;

    prev_v = v(i);
    v(i) = xv0x*(1/(xmw*alpha) - 1);
    %delta = 1/v(i) - 1/prev_v;
    %ivw = ivw + delta*x(:,i)*x(:,i)';
    if 0
      % incremental inverse of ivw
      % can avoid computing v0 this way
      vw = vw - (vw*x(:,i))*(delta/(1 + xvwx*delta))*(x(:,i)'*vw);
    else
      % ADF update for vw
      vw = v0 - v0x*(alpha*xmw/xv0x)*v0x';
    end

    m(i) = xm + (xv0x + v(i))*alpha;

    % this part only needs to be done on the last iter
    % p = -0.5*(mi - m0)'*inv(Vi + V0)*(mi - m0)
    %p = -0.5*(m(i) - xm)^2*(x(:,i)'*mw)/xv0x*alpha;
    % identical to above
    p = -0.5*alpha*xv0x/xmw;
    p = p - 0.5*log(1 + xv0x/v(i));
    if e == 0
      true = gauss_logcdf(z);
    else
      true = log(e + (1-2*e)*exp(gauss_logcdf(z)));
    end
    a(i) = true - p;
  end

  run.m(:,iter) = mw;
  run.flops(iter) = flops;
  
  if show_progress
    s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
    for i = 1:n
      s = s + m(i)^2/v(i);
    end
    ev(iter) = 0.5*logdet(2*pi*vw) - 1/2*s + sum(a) - 0.5*logdet(2*pi*vp);
  end

  if max(abs(m - old_m)) < 1e-4 & max(abs(v - old_v)) < 1e-4
    break
  end
  if e == 0 & min(v) < 1e-10
    error('data is not separable')
  end
end
if iter == niters
  warning('not enough iters')
end

if show_progress
  figure(2)
  plot(ev)
end

% v should be identical to TAP blambda

s = mp'*inv(vp)*mp - mw'*inv(vw)*mw;
for i = 1:n
  s = s + m(i)^2/v(i);
end
s = 0.5*logdet(2*pi*vw) - 1/2*s + sum(a) - 0.5*logdet(2*pi*vp);
m = mw;
v = vw;
