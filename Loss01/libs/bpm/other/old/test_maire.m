% Maire
cd('maire')
addpath('c:\cygwin\home\default\matlab\toolbox\optim\')
[alpha,K] = buildBPM(X',Y,@kfLinear,0);
w = [X ones(rows(X),1)]'*alpha;
cd('..')
figure(1)
bpm_draw(task,w,'r');

if 0
  cd('maire')
  addpath('c:\cygwin\home\default\matlab\toolbox\optim\')
  [alpha,K] = buildBPM(X',Y,@kfRBF,0);
  cd('..')
  figure(1)
  bpm_draw(task,alpha,'r');
end
