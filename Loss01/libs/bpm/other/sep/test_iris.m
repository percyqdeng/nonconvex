addpath('\cygwin\home\default\matlab')
addpath('/u/tpminka/matlab/density')

load /u/tpminka/tex/phd/matlab/svm/iris2v13.mat
% on full dataset, EP is quite bad - even worse than SVM
% while Billiard is very good
% this means we should preprocess by chopping out points before running EP
if 0
  % support vectors only - easy for EP
  % this suggests re-running EP with small alphas removed
  %i = [11 36 107];
  % semi-difficult for EP:
  %i = [10 20 30];
  % these are difficult for EP:
  %i = [10 60 30];
  %i = 1:10;
  % EP and Billiard are in a tie here:
  i = 1:50;
  X = X(i, :);
  Y = Y(i);
end
if 1
  % this example challenges the intuitiveness of the max margin solution
  % and illustrates the nature of Bayes point
  % by moving one point up we can make the Bayes point arbitrarily flat
  % while the max margin is constant
  % for opper_tap and mf, use step=0.5 for fast convergence
  Y = [1 1 -1]';
  X = [0 0; 0 1; 1 0];
  %X = [0 0; -0.5 1.5; 1 0];
  % m = [-1.76512118  0.48800375 -0.40193270]
  % m = [ -1.76512118  0.48800375 0.40193270]
  if 0
    % replicate one point
    X = [X; repmat(X(3,:), 10, 1)];
    Y = [Y; repmat(Y(3), 10, 1)];
  end
  if 0
    X = [X; 0 0.5; 1.5 0; 0.1 1.5];
    Y = [Y; 1; -1; -1];
  end
end
if 0
  Y = [1 1 -1 -1]';
  X = [-1 0; 0 -1; 1 0; 0 1];
end
if 0
  % replicate to demonstrate pathology of EP
  X = repmat(X, 2, 1);
  Y = repmat(Y, 2, 1);
  X = X + randn(size(X))*1e-1;
end
figure(1)
i1 = find(Y > 0);
i0 = find(Y < 0);
plot(X(i1,1), X(i1,2), 'o', X(i0,1), X(i0,2), 'x');
drawnow
axis([-1 2 -1 2])
%axis([-2 3 -2 3])
if 0
  % for poster
  set(gca,'xtick',[],'ytick',[])
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
  mobile_text('SVM','Bayes')
end

x = [X ones(rows(X),1)];
x = x.*repmat(Y,1,cols(x));
x = x';
[d,n] = size(x);

if 0
  % random permutation
  i = randperm(n);
  x = x(:,i);
end

% EP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global show_progress
flops(0);
[e,m,v] = adf_step(x);
adf.m = m/norm(m);
adf.flops = flops;
show_progress = 0;
flops(0);
[ep.e,ep.m,ep.v,ep.run] = ep_step(x);
m = ep.m;
figure(1)
draw_line_clip(m(1), m(3), -m(2), 'color', 'magenta');
drawnow

if 0
  C = x'*x;
  [e,alpha,run] = ep_kernel(C);
  m = x*alpha';
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'magenta');
  drawnow
  return
end

if 0
  flops(0);
  [tm.e,tm.m,tm.v,tm.run] = tm_step(x);
  m = tm.m;
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'green');
  drawnow
end

%[tm.e,tm.m,tm.v] = tm_step_old(x);

if 0
  figure(2)
  inc = 0.05;
  es = 0:inc:0.45;
  score = [];
  for i = 1:length(es)
    [s,m] = ep_step(x,es(i));
    score(i) = s;
  end
  plot(es, score);
  return
end

% TAP/MF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
  show_progress = 0;
  flops(0);
  [tap.e,m,tap.run] = opper_tap(x);
  tap.m = m/norm(m);
  show_progress = 0;
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'red');
  drawnow
  flops(0);
  [mf.e,m,mf.run] = opper_mf(x);
  mf.m = m/norm(m);
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'green');
  drawnow
end
if 0
  [s,m] = opper_vb(x);
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'magenta');
  drawnow
end

if 0
  m = perceptron(x);
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'magenta');
  drawnow
end
%m = buhot_train(x, m);

% SVM/Billiard %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('svm')
  % addpath('/u/tpminka/tex/phd/matlab/svm')
  addpath('\cygwin\home\default\phd\matlab\svm')
  ker = 'linear';
  X1 = [X ones(n,1)];
  if 0
    % normalize vectors
    X1 = scale_rows(X1, 1./sqrt(row_sum(X1.^2)));
  end
  % C=2 gives result similar to Bayes on ex3
  C = 2;
  C = Inf;
  flops(0);
  [alpha,bias] = svc(X1,Y,ker,C,0);
  m = ((alpha.*Y)'*X1)';
  svm.m = m/norm(m);
  svm.flops = flops;
end
m = svm.m;
figure(1)
draw_line_clip(m(1), m(3), -m(2), 'color', 'blue');
drawnow

if 0
  % addpath('/u/tpminka/tex/phd/matlab')
  % this requires svm first
  flops(0);
  [alpha,kb.run] = kbilliard(X1,Y,ker,alpha,2000);
  kb.m = ((alpha.*Y)'*X1)';
  kb.run.m = (scale_rows(kb.run.alpha,Y)'*X1)';
  %rujan = kb;
  m = kb.m;
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'c');
  drawnow
end
if 0
  m = dbpm(X1,Y,'linear');
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'r');
  drawnow
  w_dbpm = m/norm(m);
end
if 0
  flops(0);
  [rujan.m,rujan.run] = billiard(x, svm.m, 2000);
  m = rujan.m;
  if 0
    figure(2)
    %show_vs(x, brute.m, ms);
    show_vs(x, brute.m, svm.m);
    hits = rujan.run.hits;
    hold on, plot3(hits(1,:), hits(2,:), hits(3,:), '.'), hold off
    set(gcf,'PaperPosition',[0.25 2.5 3 3])
  end
  figure(1)
  draw_line_clip(m(1), m(3), -m(2), 'color', 'c');
  drawnow
end
if 0
  flops(0);
  [tb.m,tb.run] = tbilliard(x, svm.m, 2000);
end

% Brute %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('brute')
  % load example1.mat
  %[m,brute.v] = bayes_brute(x, 1e8);
  %m = bayes_brute2(x, 1000000, ep.m, ep.v);
  m = bayes_brute(x, 1e6);
  m = m/norm(m);
  brute.m = m;
else
  m = brute.m;
end
figure(1)
draw_line_clip(m(1), m(3), -m(2), 'color', 'black');
drawnow

% Maire %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if ~exist('maire')
addpath('maire')
[maire.s,maire.m] = bpm_maire(x,brute.m);
m = maire.m;
figure(1)
draw_line_clip(m(1), m(3), -m(2), 'color', 'm');
drawnow
%end

if 1
  % show the version space
  figure(2)
  %show_vs(x, brute.m, svm.m);
  show_vs(x, brute.m, maire.m);
  %draw_ellipsoid(ep.m, ep.v);
  %draw_ellipsoid(brute.m, brute.v);
  return
end
if 0
  r = -1:0.2:2;
  xt = lattice(repmat([-1 0.2 2],2,1));
  xt = [xt; ones(1,cols(xt))];
  prior = normal_density(zeros(3,1), eye(3));
  yt = bayes_predict_brute(xt, x, prior, 1e5);
  yt = reshape(yt,length(r),length(r));
  %imagesc(r,r, yt);
  hold on
  contour(r,r,yt, [0 0]);
  hold off
  % for my test problem, it is pretty straight, along the TAP solution
end
if 0
  text(0.2, 1.8, 'SVM')
  text(1.3, 1.7, 'Bayes')
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
end

if 0
  save_rujan('train2.inp', X', Y');
end

% Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
  figure(2)
  adf.acc = sqrt(distance(brute.m, adf.m));
  ep.run.m = normalize_cols(ep.run.m);
  ep.acc = sqrt(distance(brute.m, ep.run.m));
  %tm.run.m = normalize_cols(tm.run.m);
  %tm.acc = sqrt(distance(brute.m, tm.run.m));
  %rujan.acc = sqrt(distance(brute.m, rujan.run.m));
  %svm.acc = sqrt(distance(brute.m, svm.m));
  mf.run.m = normalize_cols(mf.run.m);
  mf.acc = sqrt(distance(brute.m, mf.run.m));
  tap.run.m = normalize_cols(tap.run.m);
  tap.acc = sqrt(distance(brute.m, tap.run.m));
  loglog(ep.run.flops, ep.acc, 'x-', ...
      mf.run.flops, mf.acc, '*-', tap.run.flops, tap.acc, '--')
%      tm.run.flops, tm.acc, 'o-', ...
%      rujan.run.flops, rujan.acc, '-', ...
%      svm.flops, svm.acc, 'o', ...
%      adf.flops, adf.acc, 'x')
  mobile_text('EP','Billiard','SVM','MF','TAP')
  xlabel('FLOPS')
  ylabel('Error')
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
  %axis([1e2 1e6 1e-2 1e0])
end
if 0
  figure(2)
  rujan.acc = sqrt(distance(brute.m, rujan.run.m));
  kb.acc = sqrt(distance(brute.m, kb.run.m));
  tb.acc = sqrt(distance(brute.m, tb.run.m));
  loglog(rujan.run.flops, rujan.acc, '-', ...
      kb.run.flops, kb.acc, '-', ...
      tb.run.flops, tb.acc, '-')
  axis([1e2 1e7 1e-3 1e0])
  mobile_text('Rujan','Herbrich','New')
  xlabel('FLOPS')
  ylabel('Error')
  set(gcf,'PaperPosition',[0.25 2.5 4 4])
end




