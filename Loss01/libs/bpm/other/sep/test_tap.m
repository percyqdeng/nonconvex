% path(path, '/u/tpminka/matlab/density')

load /u/tpminka/tex/phd/matlab/svm/iris2v13.mat
if 1
  % support vectors only
  i = [11 36 107];
  X = X(i, :);
  Y = Y(i);
end

x = [X ones(rows(X),1)];
x = x.*repmat(Y,1,cols(x));
x = x';

[d,n] = size(x);

% TAP
%    -0.8112    0.1408    0.1240
%    -1.3011    0.1546    0.1405
% TM
%    -0.8112    0.1407    0.1243
%    -1.9307    0.1577    0.1425  (same vs)
%    -1.3010    0.1546    0.1406  (matched vs)

prior = normal_density(zeros(d,1),eye(d));
if 1
  %tap_v = [    0.6225;    0.1248;    0.1454];
  %m = opper_tap(x, prior, tap_v);
  [e,m] = opper_tap(x, prior);
else
  tap_v = [0.0442 0.1087 0.1281];
  % this makes estimated dw almost exactly zero
  % but the real dw is larger than for above
  %tap_v = [0.0142    0.0153    0.1146];
  %[e,m,v] = tm_step(x, prior, tap_v);
  [e,m,v] = tm_step(x, prior);
  if 0
    tap_v = fmins('tm_fcn', tap_v, [], [], x, prior)
    tm_fcn(tap_v, x, prior)
  end
end
return

xm = [];
for i = 1:cols(x)
  x2 = x;
  x2(:,i) = [];
  if 1
    v2 = tap_v;
    v2(i) = [];
  else
    switch i
    case 1, v2 = [0.0314 0.0329];
    case 2, v2 = [0.0314 0.0588];
    case 3, v2 = [0.0329 0.0588];
    end
  end
  %m = opper_tap(x2, prior, v2);
  [e,m,v] = tm_step(x2, prior, v2);
  xm(i) = x(:,i)'*m;
end
xm
