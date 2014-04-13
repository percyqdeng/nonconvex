% addpath('/u/tpminka/tex/rdm/matlab')
% load /u/tpminka/tex/rdm/matlab/data/energy.mat
n_train = 100;
n_test = 200;
f = 300;
test_energy;
prune_words;

X = [train1;train2];
X = [X ones(rows(X),1)];
Y = [ones(rows(train1),1); -ones(rows(train2),1)];
xt = [test1; test2];
xt = [xt ones(rows(xt),1)];
yt = [ones(rows(test1),1); -ones(rows(test2),1)];

if 0
% addpath('/u/tpminka/tex/phd/matlab/svm')
ker = 'linear';
C = 0.1;
tic
% 28s for C=1
[nsv,alpha,bias] = svc(X,Y,ker,C);
toc
m = (alpha.*Y)'*X;
% 3 training errors for C=1
sum(sign(X*m') ~= Y)
% 57 errors for C=1
sum(sign(xt*m') ~= yt)
end

x = (X.*repmat(Y,1,cols(X)))';

global show_progress
show_progress = 1;
tic
% 26s for e=0.05
[s,m] = tm3_step(x,0.1);
toc
show_progress = 0;
disp(['evidence = ' num2str(s)])
% 3 training errors for e=0.05
sum(sign(X*m) ~= Y)
% 43 errors for e=0.05
sum(sign(xt*m) ~= yt)

if 0
  test_bim
  test_simple
end
