% addpath('/u/tpminka/matlab/density')


train_err = {};
test_err = {};
for i = 1:3
  train_err{i} = [];
  test_err{i} = [];
end
clear ep

for iter = 1:1

if 0
  % sonar is boring unless you use poly2 kernel
  %load sonar.mat
  %X = [X; Xt];
  %Y = [Y; Yt];
  % this dataset is too trivial - only need two prototypes
  %load breast_cancer_wisconsin.mat
  % fake kernel for heart is 2
  % width 2 is best for heart (normalized)
  % but width 3 gives nicest difference
  %load heart.mat
  % kernel for pima (normalized) is 1
  % need fast SVM toolkit for pima
  % pima doesn't work without slack, even though it can be classified perfectly
  %load pima.mat
  % kernel for ion is 2
  %load ionosphere.mat
  % width 2 for thyroid (normalized)
  % but width 3 gives nicest diff
  %load thyroid.mat

  % arrythmia - classify normal from diseased
  % results are pretty bad - all get 30% error
  %load arrythmia.mat
  % delete features 11-14 and case 5
  %gawk -F, '{for(i=1;i<=NF;i++)if($i=="?")printf "123456 ";else printf "%g ",$i;print ""}' arrhythmia.data > qq
  % Y = 2*(Y==1)-1;
  % X(:,11:14) = [];
  % X(5,:) = [];
  % Y(5) = [];
  
  % spectrometer

  % resample the data
  i = randperm(rows(Y));
  %n = ceil(0.6*length(Y));
  %n = ceil(rand*length(Y))
  %i = i(1:n);
  Xt = X(i,:);
  Yt = Y(i);
  X(i,:) = [];
  Y(i) = [];
end
if 1
  % normalize (using only training set stats)
  m = mean(X);
  X = X - repmat(m,rows(X),1);
  Xt = Xt - repmat(m,rows(Xt),1);
  v = var(X);
  v(v == 0) = 1;
  X = scale_cols(X, 1./sqrt(v));
  Xt = scale_cols(Xt, 1./sqrt(v));
end
if 0
  % fake kernel
  if 1
    % noise dimensions have no effect when using this kernel
    kernel_width = 5;
    xt = exp(-distance(xt', X')/(2*kernel_width^2));
    X = exp(-distance(X', X')/(2*kernel_width^2));
  else
    % add bias term
    xt = [xt ones(rows(xt),1)];
    X = [X ones(rows(X),1)];
  end
end
if 0
  i1 = find(yt == 1);
  i0 = find(yt == -1);
  plot(xt(i1,1), xt(i1,2), 'o', xt(i0,1), xt(i0,2), 'x')
  i1 = find(Y == 1);
  i0 = find(Y == -1);
  plot(X(i1,1), X(i1,2), 'o', X(i0,1), X(i0,2), 'x')
  draw_line_clip(svm.m(1), 0, -svm.m(2))
end

global p1
p1 = 5;
ker = 'poly';
K = svkernelmtx(ker,X);
Kt = scale_cols(svkernelmtx(ker,Xt,X),Y);

if 1
  % addpath('/u/tpminka/tex/phd/matlab/svm')
  flops(0);
  [alpha,bias] = svc(X,Y,K,Inf,0);
  %m = ((alpha.*Y)'*X)';
  %svm.m = m/norm(m);
  svm.flops = flops;

  %err = sum(sign(X*m) ~= Y)/length(Y);
  err = sum(sign(K*(Y.*alpha)) ~= Y)/length(Y);
  disp(['train = ' num2str(err)])
  e = train_err{2};
  e(iter) = err;
  train_err{2} = e;
  %err = sum(sign(xt*m) ~= yt)/length(yt);
  err = sum(sign(Kt*alpha) ~= Yt)/length(Yt);
  disp(['test = ' num2str(err)])
  e = test_err{2};
  e(iter) = err;
  test_err{2} = e;
end
if 0
  load /u/tpminka/papers/billiard/sonar/pms.1
  pms(61) = -0.5*(pms(61)+pms(62));
  pms(62) = [];
  svm.m = pms;
  svm.flops = 1e5;
  m = svm.m;
end

if 0
  % addpath('/u/tpminka/tex/phd/matlab')
  flops(0);
  if 0
    [rujan.m,rujan.run] = billiard(x, svm.m);
    m = rujan.m;
  else
    alpha = kbilliard(X,Y,ker,alpha,500);
    %[alpha,kb.run] = kbilliard(X,Y,ker,alpha,2000);
    %m = ((alpha.*Y)'*X)';
  end
  kb.flops = flops;

  %err = sum(sign(X*m) ~= Y);
  err = sum(sign(K*(Y.*alpha)) ~= Y)/length(Y);
  disp(['train = ' num2str(err)])
  e = train_err{3};
  e(iter) = err;
  train_err{3} = e;
  %err = sum(sign(xt*m) ~= yt);
  err = sum(sign(Kt*alpha) ~= Yt)/length(Yt);
  disp(['test = ' num2str(err)])
  e = test_err{3};
  e(iter) = err;
  test_err{3} = e;
end

if 0
  x = (X.*repmat(Y, 1, cols(X)))';
  [d,n] = size(x);
  if 0
    % randomly reorder
    i = randperm(n);
    x = x(:,i);
  end
  flops(0);
  [s,ep.m,ep.v,ep.run] = ep_step(x);
  m = ep.m;
else
  C = scale_rows(scale_cols(K,Y),Y);
  flops(0);
  [s,alpha] = ep_kernel(C,0);
  %[s,alpha,ep.run] = ep_kernel(C);
  ep.flops = flops;
  alpha = alpha';
end
disp(['evidence = ' num2str(s)])

%err = sum(sign(X*m) ~= Y)/length(Y);
err = sum(sign(K*(Y.*alpha)) ~= Y)/length(Y);
disp(['train = ' num2str(err)])
e = train_err{1};
e(iter) = err;
train_err{1} = e;
%err = sum(sign(xt*m) ~= yt)/length(yt);
err = sum(sign(Kt*alpha) ~= Yt)/length(Yt);
disp(['test = ' num2str(err)])
e = test_err{1};
e(iter) = err;
test_err{1} = e;

if 0
  % plot test_err over the run
  kb.err = sum(sign(Kt*kb.run.alpha) ~= repmat(Yt,1,cols(kb.run.alpha)))/length(Yt);
  ep.err = sum(sign(Kt*ep.run.alpha) ~= repmat(Yt,1,cols(ep.run.alpha)))/length(Yt);
  semilogx(kb.run.flops+svm.flops, kb.err, '-', ep.run.flops, ep.err, 'x-', ...
      svm.flops, test_err{2}, 'o')
  xlabel('FLOPS')
  ylabel('Test error')
  mobile_text('SVM','EP','Billiard')
  return
end

end % for iter

fprintf('EP beats SVM: %d\n', sum(test_err{1} < test_err{2}))
fprintf('EP beats Billiard: %d\n', sum(test_err{1} < test_err{3}))

if 0
  i = 1;
  j = 2;
  r1 = min(min(test_err{i}), min(test_err{j}));
  r2 = max(max(test_err{i}), max(test_err{j}));
  a = (r2-r1)*0.1;
  r1 = r1 - a;
  r2 = r2 + a;
  plot(test_err{j}, test_err{i},'.')
  axis([r1 r2 r1 r2])
  draw_line_clip(1,0,1);
  if j == 3
    xlabel('Billiard')
  else
    xlabel('SVM')
  end
  ylabel('EP')
  title('Test errors')
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
end

if 0
  % plot running time
  [x,i] = sort(ep.n);
  y = ep.toc(i);
  %x0 = [x; x.^2];
  x0 = [x; x.^2; x.^3];
  a = y/x0;
  plot(ep.n, ep.toc, '.', x, a*x0, '-')
  xlabel('Training set size')
  ylabel('Training time (mins)')
end

if 0
  % unlabeled data example
  x = rand(2,100);
  x = [gauss_sample([3;0], eye(2), 50) gauss_sample([-3;0], eye(2), 50)];
  plot(x(1,:), x(2,:), '.')
  xlabel('x1')
  ylabel('x2')
  set(gca,'xtick',[],'ytick',[])
  axis([-6 6 -6 6])
end

if 0
  %m = bayes_brute(x, 1000000);
  % this is only accurate to within 0.6
  m = bayes_brute2(x, 1000000, ep.m, ep.v/2);
  m = m/norm(m);
  brute.m = m;
end

if 0
  figure(2)
  ep.run.m = normalize_cols(ep.run.m);
  ep.acc = sqrt(distance(brute.m, ep.run.m));
  svm.acc = sqrt(distance(brute.m, svm.m));
  rujan.acc = sqrt(distance(brute.m, rujan.run.m));
  loglog(ep.run.flops, ep.acc, '-', rujan.run.flops, rujan.acc, '-', ...
      svm.flops, svm.acc, 'o')
  legend('EP','Billiard','SVM',4)
  xlabel('FLOPS')
  ylabel('Error')
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
end
