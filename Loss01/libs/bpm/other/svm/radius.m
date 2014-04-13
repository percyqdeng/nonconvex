function r = radius(X,ker)
% Returns the radius of row vectors in X
% ker can be a string or a precomputed kernel matrix
% This alg is from "Dynamically Adapting Kernels in Support Vector Machines"
% http://lara.enm.bris.ac.uk/cig/gzipped/1999/nips98.ps.gz

% 11/3/00 Thomas P. Minka tpminka@media.mit.edu

if nargin < 2
  ker = 'linear';
end
C = Inf;
n = size(X,1);

if isa(ker, 'char')
  % Construct the Kernel matrix
  H = svkernelmtx(ker,X);
else
  % X is not needed at all if kernel matrix is provided
  H = ker;
end
c = -diag(H);

% Add small amount of zero order regularisation to 
% avoid problems when Hessian is badly conditioned. 
H = H+1e-10*eye(size(H));

% Set up the parameters for the Optimisation problem

vlb = zeros(n,1);      % Set the bounds: alphas >= 0
vub = C*ones(n,1);     %                 alphas <= C
x0 = zeros(n,1);       % The starting point is [0 0 0   0]
% Set the constraint Ax = b
% in this case, sum alphas = 1
A = ones(1,n);
b = 1;

% Solve the Optimisation Problem
options = optimset('LargeScale','off','Display','off');
alpha = quadprog(2*H, c, [], [], A, b, vlb, vub, x0, options);

% the mean is now alpha'*phi(X)

if 0
  % this actually computes the variance
  % the paper forgot the "n" here
  r = n*alpha'*H*alpha - 2*alpha'*H*ones(n,1) + trace(H);
  r = r/n;
  % in linear case, above is equivalent to:
  %m = alpha'*X;
  %r = sum(sum((repmat(m, n, 1) - X).^2))
  % sum_i (x_i - m)^2
else
  % this is the radius
  r = alpha'*H*alpha -2*H*alpha + diag(H);
  r = max(r);
end
r = sqrt(r);
