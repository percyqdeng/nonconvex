% Test EP vs billiard on a data set with errors
% but the kind of slack is different
% must use kernel EP with same kernel matrix, and use kernel_brute

if 0
  load digit.mat
  xt = [xt ones(rows(xt),1)];
  X = [X ones(rows(X),1)];
else
  load breast_cancer_wisconsin.mat
  xt = [];
  yt = [];
end

train_svm = [];
test_svm = [];
train_ep = [];
test_ep = [];
train_kb = [];
test_kb = [];
%Cs = [0 0.1 1 10];
Cs = [10 20 30 40];
Cs = 0;
es = [0 0.1 0.2 0.3];
es = 0;
for ip = 1:length(Cs)
C = 1/Cs(ip);
e = es(ip);
for iter = 1:20
  
if 1
  % resample the data
  xt = [X; xt];
  yt = [Y; yt];
  i = randperm(rows(xt));
  i = i(1:30);
  X = xt(i,:);
  Y = yt(i);
  xt(i,:) = [];
  yt(i) = [];
end
%load task3.mat

if 1
  % addpath('/u/tpminka/tex/phd/matlab/svm')
  ker = 'linear';
  % works fine with 1/C=0 .. 50
  [alpha,bias] = svc(X,Y,ker,C,0);
  m = ((alpha.*Y)'*X)';
  err = sum(sign(X*m) ~= Y);
  disp(['train = ' num2str(err)])
  train_svm(ip, iter) = err;
  err = sum(sign(xt*m) ~= yt);
  disp(['test = ' num2str(err)])
  test_svm(ip, iter) = err;
  
  if 1
    % addpath('/u/tpminka/tex/phd/matlab')
    [alpha,kb.run] = kbilliard(X,Y,ker,alpha,2000);
    m = ((alpha.*Y)'*X)';
    err = sum(sign(X*m) ~= Y);
    disp(['train = ' num2str(err)])
    train_kb(ip, iter) = err;
    err = sum(sign(xt*m) ~= yt);
    disp(['test = ' num2str(err)])
    test_kb(ip, iter) = err;
  end
end

x = (X.*repmat(Y,1,cols(X)))';
[d,n] = size(x);

if 1
  disp('EP')
  % addpath('/u/tpminka/matlab/density')
  global show_progress
  %a = ones(d,1);
  %while 1
  show_progress = 0;
  % EP works fine with e=0 .. 0.3
  [s,m,v] = ep_step(x,e);
  show_progress = 0;
  disp(['evidence = ' num2str(s)])
  %m = diag(a)*m;
  %v = diag(a)*v*diag(a);
  err = sum(sign(X*m) ~= Y);
  disp(['train = ' num2str(err)])
  train_ep(ip, iter) = err;
  err = sum(sign(xt*m) ~= yt);
  disp(['test = ' num2str(err)])
  test_ep(ip, iter) = err;
end

end % for iter
end % for ip
if 0
  clf
  for i = 1:4
    r = i*ones(1,20);
    plot(r, test_svm(i,:), 'o', r, test_ep(i,:), 'x')
    hold on
  end
  hold off
end
if 0
  plot(1:4, mean(train_svm,2), 1:4, mean(train_ep,2))
  plot(1:4, mean(test_svm,2), 1:4, mean(test_ep,2))
  plot(mean(train_svm,2), mean(test_svm,2), mean(train_ep,2), mean(test_ep,2))
end
plot(1:length(test_svm), test_svm, 1:length(test_ep), test_ep, ...
    1:length(test_kb), test_kb)
legend('SVM','EP','Billiard')

% save digit_compare2.mat train_svm test_svm train_ep test_ep train_kb test_kb

disp(['SVM = ' num2str(mean(test_svm)) ' +-' num2str(std(test_svm))])
disp(['EP = ' num2str(mean(test_ep)) ' +-' num2str(std(test_ep))])
disp(['Billiard = ' num2str(mean(test_kb)) ' +-' num2str(std(test_kb))])

if 0
  test_svm = test_svm/length(yt);
  test_ep = test_ep/length(yt);
  test_kb = test_kb/length(yt);
end
if 0
  test_svm2 = test_svm;
  test_ep2 = test_ep;
  test_kb2 = test_kb;
  load digit_compare.mat
  test_svm = [test_svm test_svm2];
  test_ep = [test_ep test_ep2];
  test_kb = [test_kb test_kb2];
end

plot(test_svm, test_ep, '.')
axis([35 70 35 70])
draw_line_clip(1,0,1)
xlabel('SVM')
ylabel('EP')
title('Test errors')
set(gcf,'PaperPosition',[0.25 2.5 4 4])

plot(test_kb, test_ep, '.')
axis([35 70 35 70])
draw_line_clip(1,0,1)
xlabel('Billiard')
ylabel('EP')
title('Test errors')

if 0
  a = diag(v) + m.^2;
  figure(1)
  bar(sort(a))
  drawnow
end
%end

if 0
  save_rujan('digit_train.inp', X(:,1:64)', Y');
  save_rujan('digit_test.inp', xt(:,1:64)', yt');
end

% task1:
% SVM gets 66 
% TM gets 54
% PMS gets 65
% QBAYES gets 59
% on other trials, TM often beats QBAYES (but sometimes not)
% try running QBAYES longer
% the handling of bias is different betw SVM and PMS
% this is why it is good to resample standard benchmarks
% plot the average performance as a fcn of N, with error bars

% task3:
% SVM gets 95
% TM gets 71
% PMS gets 99 (also Martin)
% QBAYES gets 89

% test error of TM using error rate parameter:
% e = [0 0.05 0.1 0.15 0.17 0.2];
% y = [71 68  67   67   72   77];



% task4:
% SVM 53
% TM 40
% PMS 50
% QBAYES 45

