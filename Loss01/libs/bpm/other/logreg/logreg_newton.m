function [w,run] = train_newton(x,w,iv)
% Newton
% x is premultiplied by y
% if it fails, try initializing with smaller magnitude

% Written by Thomas P Minka

if nargin < 3
  iv = 0;
elseif length(iv) == 1
  iv = eye(length(w))*iv;
end

niters = 100;
for iter = 1:niters
  old_w = w;
  % s1 = 1-sigma
  s1 = 1./(1+exp(w'*x));
  a = s1.*(1-s1);
  h = scale_cols(x,a)*x';
  h = h + iv;
  g = x*s1' - iv*w;
  w = w + h\g;
  
  if max(abs(w - old_w)) < 1e-4
    break
  end
end
if iter == niters
  %warning('not enough iters')
end
