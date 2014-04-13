% feature selection test
% EP evidence is more stable than R^2/M^2 and span bound
% and EP does better on test data for same features

if 1
  % Weston et al dataset
  % pre-normalization makes it much easier, so they must not have used it
  n = 600;
  Y = 2*(rand(n,1) < 0.5)-1;
  X = randn(n,100)*sqrt(20);
  X(:,1:3) = repmat(Y,1,3).*(randn(n,3)+repmat(1:3,n,1));
  X(:,4:6) = randn(n,3);
  % swap 1:3 with 4:6 in some samples
  i = find(rand(n,1) > 0.7);
  x = X(i,1:3);
  X(i,1:3) = X(i,4:6);
  X(i,4:6) = x;
else
  load thyroid.mat
  % add noise dimensions
  X = [X randn(rows(X),15)];
end
% train/test split
i = randperm(length(Y));
i = i(1:50);
xt = X;
yt = Y;
xt(i,:) = [];
yt(i) = [];
X = X(i,:);
Y = Y(i);
if 1
  % normalize (using only training set stats)
  m = mean(X);
  X = X - repmat(m,rows(X),1);
  xt = xt - repmat(m,rows(xt),1);
  v = var(X);
  v(v == 0) = 1;
  X = scale_cols(X, 1./sqrt(v));
  xt = scale_cols(xt, 1./sqrt(v));
end
if 1
  % add bias term
  xt = [xt ones(rows(xt),1)];
  X = [X ones(rows(X),1)];
end

if 1
  % SVM curve
  % addpath('/u/tpminka/tex/phd/matlab/svm')
  ker = 'linear';
  C = Inf;
  svm_err = [];
  svm_crit = [];
  svm_err(1:4) = nan;
  svm_crit(1:4) = nan;
  svm_crit2(1:4) = nan;
  for f = 5:20
    Xf = X(:,1:f);
    xtf = xt(:,1:f);
    % solve the SVM problem to get margin
    [alpha,bias,K,margin] = svc(Xf,Y,ker,C);
    m = ((alpha.*Y)'*Xf)';
    svm_err(f) = sum(sign(xtf*m) ~= yt)/length(yt);

    % SRM bound
    r = radius(Xf,K);
    % this doesn't work in nonseparable case
    %margin = 2/sqrt(m'*m);
    svm_crit(f) = r^2/margin^2;

    % span bound
    epsilon = svtol(C);
    svii = find( alpha > epsilon & alpha < (C - epsilon));
    Ksv = K(svii,svii);
    q = alpha(svii)./diag(inv(Ksv)) - 1;
    svm_crit2(f) = sum(q > 0);
  end
end
if 1
  % EP curve
  d = cols(X);
  ep_err = [];
  ep_crit = [];
  ep_err(1:4) = nan;
  ep_crit(1:4) = nan;
  for f = 5:20
    % must include bias term
    fs = [1:f, d];
    Xf = X(:,fs);
    xtf = xt(:,fs);
    x = (Xf.*repmat(Y,1,cols(Xf)))';
    [s,m] = ep_step(x);
    ep_err(f) = sum(sign(xtf*m) ~= yt)/length(yt);
    ep_crit(f) = s;
  end  
end
plot(1:length(svm_err), svm_err, 1:length(ep_err), ep_err)
plot(svm_crit)
plot(ep_crit)
%ylabel('EP evidence')
ylabel('Span bound')
ylabel('Margin bound')
xlabel('Number of features')
set(gcf,'PaperPosition',[0.25 2.5 4 3])

if 0
  x = (X.*repmat(Y,1,cols(X)))';
  [d,n] = size(x);
  sa = ones(d,1);
  for i = 1:5
    [s,m,v] = ep_step(x);
    a = diag(v) + m.^2;
    x = diag(a)*x;
    sa = sa.*a;
    figure(1)
    bar(sa)
    drawnow
  end
end
