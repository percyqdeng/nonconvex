function [alpha, run] = kbilliard(trnX,trnY, ker,alpha_in,maxiters)
% function [alpha, svmdist, lambda_max, avg_alphanormchange, alphanormchanges] = kbilliard(trnX,trnY,ker,alpha,maxiters)
%
%
% given a solution that separates the data using kernel ker and Lagrange
% multipliers alpha_in, this function implements Herbrich's billiard
% algorithm.  This algorithm bounces a billiard around the version space and
% builds up an estimate of its center of mass (assuming a uniform mass
% distribution), which approximates the "bayes point."  The function returns a
% new set of alphas such that the new classification function is f(x) =
% \sum_i{y_i\alpha_i K(x,x_i)} in the SVM style (i.e., all the alphas are put
% into this positive, canonical form, though in the algorithm, the alphas do
% not have this constraint).
%
% other outputs:
%   svm_dist: distance (in F space) between SVM solution and final billiard 
%   solution
%   lambda_max: size (in F space) of longest bounce - gives a sense of the 
%   polyhedra's size
%   avg_alphnormchange: average abs() of change in alpha's l1 norm at the
%   end of the trial
% 
% implemented by Sumit Basu, MIT Media Lab, December 1999

% debug flags
checkalphaeverystep = 0; % if 1, checks that alpha is valid at every iteration

% globals
global C;

% the below line should be svtol(C) 
epsilon = svtol(Inf);

numdatapoints = size(trnX)*[1 0]';
svecmap = (alpha_in > 1e-4);
numsvec = length(find(alpha_in > 1e-4));
svec = trnX(find(alpha_in > 1e-4));
%alphanormchanges = zeros(maxiters, 1);

l = size(trnX,1);

if nargout > 1
  run.alpha = zeros(length(alpha_in),maxiters);
  run.flops = zeros(1,maxiters);
  run.count = 0;
end

% require
tau_max = 1e10;
tau_tol = 1e-12;  % tau is only accurate to this amount
rho2val = 1;
alphanorm = 0;
alphanorm_old = 0;
avg_alphanormchange = 0;

% form kernel matrix
if isa(ker, 'char')
  fprintf('constructing kernel matrix...');
  K = svkernelmtx(ker, trnX);
  fprintf('done\n');
else
  K = ker;
end

% allocate
gamma = trnY.*alpha_in;
% normalize gamma
gamma = gamma/sqrt(gamma'*K*gamma);
svmalpha = gamma;
gamma_p = zeros(l,1);
beta = rand(l,1);
% DO: normalize beta
beta = beta/sqrt(beta'*K*beta);
alpha = zeros(l,1);
alpha_old = zeros(l,1);
LAMBDA = 0;
lambda = zeros(l,1);
lambda_max = 0;
p_max = 0;
tau = zeros(l,1);
d = zeros(l,1);
v = zeros(l,1);
m = -1;


% ensure
fprintf('checking to make sure solution alpha is valid...');
num_invalid = 0;
for j = 1:l
   if ( trnY(j)*(K(:,j)'*gamma) < 0)
      num_invalid = num_invalid + 1;
   end
end
if (num_invalid > 0)
   fprintf('invalid initial solution...exiting\n');
   return;
end
fprintf('ok\n');

random_count = 0;
numiters = 0;
while (numiters < maxiters)
  while(1) % we'll break out when we find a finite length path to a hyperplane
    for i = 1:l
      d(i) = trnY(i)* (gamma'*K(:,i));
      v(i) = trnY(i)* (beta'*K(:,i));
      tau(i) = -d(i)/v(i);
    end
    % hack - make tau(m) really large 
    % (it's the boundary we just reflected from)
    % since we might have passed through it by a smidgen.
    if(m > 0) % i.e., if after first iteration
      tau(m) = tau_max+1e5;
    end
   
    % find smallest positive tau 
    % by making negative ones really large, then taking min
    tau(tau<=tau_tol) = tau_max+1e5;
    [tau_m_p, m_p] = min(tau);
    if (tau_m_p > tau_max)
      %fprintf('randomizing beta\n');
      random_count = random_count + 1;
      while (1)
	beta = -1 + 2*rand(l,1);
	if (m > 0) % after first bounce
	  if (trnY(m)*(beta'*K(:,m)) >0)
	    % beta is ok
	    break;
	  end
	end
      end
      beta = beta/sqrt(beta'*K*beta);
    else
      m = m_p;
      % hit a hyperplane
      break;
    end
  end
   
  % gamma_p is position of billiard upon reaching hyperplane m
  gamma_p = gamma + tau_m_p*beta;
  gamma_p = gamma_p/sqrt(gamma_p'*K*gamma_p);
   
  % update velocity vector due to bounce
  beta(m) = beta(m) - 2*v(m)*trnY(m)/K(m,m);
  beta = beta/sqrt(beta'*K*beta);
   
  % zsi = components for this hop's midpoint, b+b'/||b + b'||
  zsi = gamma + gamma_p;
  zsi = zsi/sqrt(zsi'*K*zsi);
   
  % compute path length
  lambda = sqrt( (gamma-gamma_p)'*K*(gamma-gamma_p));
   
  % p = <zsi*phi(x_i),alpha*phi(x_i)> = <local midpoint, global midpoint>
  p = zsi'*K*alpha;
   
  % update centroid (alpha) with old alpha and zsi (midpoint) fractions
  rho1val = rho1(p,LAMBDA/(LAMBDA+lambda));
  rho2val = rho2(p,LAMBDA/(LAMBDA+lambda));
  % fprintf('rho1val: %f rho2val: %f lambda: %f LAMBDA: %f\n',rho1val,rho2val, lambda, LAMBDA);
  alpha_old = alpha;
  alpha = rho1val*alpha + rho2val*zsi;
  % alpha should be of mag 1
  p_max = max(p,p_max);
  lambda_max = max(lambda,lambda_max);

  % get measures of change in alpha
  alphanorm_old = alphanorm;
  if (numiters == 0)
    alphanorm_old = norm(alpha_old,1);
  end
  alphanorm = norm(alpha,1);
  avg_alphanormchange = 0.99*avg_alphanormchange + 0.01*abs(alphanorm-alphanorm_old);
   
  % put entry in changes vector
  %alphanormchanges(numiters+1) = avg_alphanormchange;
  
  % update total path length
  LAMBDA = LAMBDA+lambda;
  gamma_old= gamma;
  gamma = gamma_p;

  if nargout > 1
    run.count = run.count + 1;
    run.alpha(:,run.count) = alpha./trnY;
    run.flops(run.count) = flops;
  end
   
  % we've done a bounce
  % fprintf('bounce...\n');
   
  % check to see if alpha is still within solution polyhedra
  if (checkalphaeverystep)
    fprintf('checking to make sure solution alpha is valid...');
    num_invalid = 0;
    for j = 1:l
      if ( trnY(j) * (K(:,j)'*alpha) < 0)
	num_invalid = num_invalid + 1;
      end
    end
    if (num_invalid > 0)
      fprintf('\ntau=\n');
      fprintf('%f\n',tau');
      fprintf('tau_m_p = %f\n', tau_m_p);
      fprintf('invalid iterated solution..num_invalid = %d...exiting\n',num_invalid);
      return;
    end
    fprintf('ok\n');
  end
  
  numiters = numiters+1;
  
  if (mod(numiters,100) == 0)
    fprintf('iter:%d random:%d avgalphachange:%f\n',numiters,random_count,avg_alphanormchange);
    %fprintf('(mu)*||zsi-alpha_old||=%f\n', (LAMBDA/LAMBDA+lambda)*sqrt((zsi-alpha_old)'*K*(zsi-alpha_old)));
    %fprintf('||zsi-alpha||=%f\n', sqrt((zsi-alpha)'*K*(zsi-alpha)));
    %fprintf('mu=%f lambda=%f LAMBDA=%f\n', LAMBDA/(LAMBDA+lambda),lambda,LAMBDA);
  end
  
  %g = (alpha - svmalpha);
  %svmdist = sqrt(g'*K*g);
  %fprintf('svmdist: %f  lambdamax: %f  lambda: %f m: %d\n', svmdist, lambda_max, lambda, m);
   
  
end

% also return svmdist, the F-distance between the svm solution and the BPM
g = (alpha - svmalpha);
svmdist = sqrt(g'*K*g);

% divide the alphas by trnY so that it's in standard form for testing with svcoutput, etc.
alpha = alpha./trnY;


fprintf('\ndone in %d iterations\n',numiters);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = rho1(ip,mu)
% ip is the inner product of s and t in F
y = mu*sqrt(-(mu^2 - (mu^2)*ip - 2)/(ip + 1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = rho2(ip,mu)
% ip is the inner product of s and t in F
ybase = -rho1(ip,mu)*ip;
yp = ybase + (mu^2*(1-ip) -1);
ym = ybase - (mu^2*(1-ip) -1);
if ((yp > 0) & (ym > 0))
   fprintf('rho2: problem - both solutions are positive - returning larger\n');
end
if (yp > 0)
   y = yp;
elseif (ym > 0)
   y = ym;
else
   fprintf('rho2: problem - both solutions are negative - returning 0\n');
   y = 0;
end


