% path(path, '/u/tpminka/matlab/density')
% path(path, '/u/tpminka/tex/phd/matlab')

global show_progress
d = 2;
prior = normal_density(zeros(d,1),eye(d));

% true integral is 2^(-d)
% true mean is 0.7979
x = eye(d);
%x(1) = 2;
%x = [1 0; 1 0; 0 1]';
% answer is 1/4+1/8
%x = [1 0; 1/sqrt(2) 1/sqrt(2)]';
%x(1) = 2;
% duplicate constraints mess it up
%x = [1 0; 1 0; 1/sqrt(2) 1/sqrt(2)]';
%x = [1 0; 1 0; 1/sqrt(2) 1/sqrt(2); 1/sqrt(2) 1/sqrt(2)]';
% so do redundant constraints
% best accuracy is at pi/8 which has least overlap
theta = pi/10;
%x = [1 0; cos(theta) sin(theta); 1/sqrt(2) 1/sqrt(2)]';
% answer is 1/4 + 1/4*(1 - theta/(pi/2))
%x = [1 0; cos(theta) sin(theta)]';

% answer is 1/8
%x = [1 0; 0 1; 1/sqrt(2) -1/sqrt(2)]';

if 1
  % compare integrals
  s = bg_step(x);
  disp(['BG = ' num2str(exp(s))])
  s = bg2_step(x);
  disp(['BG2 = ' num2str(exp(s))])
  
  s = tm_step(x);
  disp(['TM = ' num2str(exp(s))])
  show_progress = 1;
  s = tm3_step(x);
  show_progress = 0;
  disp(['TM2 = ' num2str(exp(s))])
  
  s = opper_mf(x);
  disp(['OpperMF = ' num2str(exp(s))])
  %s = opper_vb(x, prior);
  %disp(['OpperVB = ' num2str(exp(s))])
  s = opper_tap(x);
  disp(['OpperTAP = ' num2str(exp(s))])
else
  % compare means
  [s,m] = bg_step(x,prior);
  disp(['BG = ' num2str(m')])
  [s,m] = bg2_step(x,prior);
  disp(['BG2 = ' num2str(m')])
  
  [s,m] = tm_step(x, prior);
  disp(['TM = ' num2str(m')])
  show_progress = 1;
  [s,m] = tm3_step(x, prior);
  show_progress = 0;
  disp(['TM2 = ' num2str(m')])
  
  [s,m] = opper_mf(x, prior);
  disp(['OpperMF = ' num2str(m')])
  %[s,m] = opper_vb(x, prior);
  %disp(['OpperVB = ' num2str(m')])
  [s,m] = opper_tap(x,prior);
  disp(['OpperTAP = ' num2str(m')])
end
