function [alpha, bias, K, margin] = svc(X,Y,ker,C,bias)
%SVC Support Vector Classification
%
%  Usage: [alpha bias K] = svc(X,Y,ker,C)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - kernel function
%              C      - how important it is to separate the data
%                       C=Inf means data must be separated (default)
%              alpha  - weight on each data point
%              bias   - bias term
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk)

if (nargin <2) % check correct number of arguments
  help svc
else

  if nargin < 5
    fixed_bias = 0;
  elseif isempty(bias)
    fixed_bias = 0;
  else
    fixed_bias = 1;
  end

    fprintf('Support Vector Classification\n')
    fprintf('_____________________________\n')
    if (nargin<4) C=Inf;, end
    if (nargin<3) ker='linear';, end

    % tolerance for Support Vector Detection
    epsilon = svtol(C);
    
    if isa(ker, 'char')
      % Construct the Kernel matrix
      fprintf('Constructing kernel matrix ...\n');
      K = svkernelmtx(ker,X);
    else
      K = ker;
    end
    H = scale_cols(scale_rows(K, Y), Y);
    %H = diag(Y)*K*diag(Y);
    n = size(H,1);
    c = -ones(n,1);  
    if fixed_bias
      % tpminka: use fixed bias
      c = c + Y*bias;
    end

    % Add small amount of zero order regularisation to 
    % avoid problems when Hessian is badly conditioned. 
    H = H+1e-10*eye(size(H));
    
    % Set up the parameters for the Optimisation problem

    vlb = zeros(n,1);      % Set the bounds: alphas >= 0
    vub = C*ones(n,1);     %                 alphas <= C
    x0 = zeros(n,1);       % The starting point is [0 0 0   0]
    if ~fixed_bias
      disp('Using equality constraint')
      A = Y';, b = 0;     % Set the constraint Ax = b
    else
      disp('Not using equality constraint')
      A = [];, b = [];
    end

    % Solve the Optimisation Problem
    
    fprintf('Optimising ...\n');
    st = cputime;
    
    %[alpha lambda how] = qp(H, c, A, b, vlb, vub, x0, neqcstr);
    % new qp routine
    options = optimset('LargeScale','off');
    [alpha,fval,how] = quadprog(H, c, [], [], A, b, vlb, vub, x0, options);
    if how > 0
      how = 'ok';
    elseif how == 0
      how = 'not enough iters';
    else
      how = 'failed to converge';
    end
    
    %fprintf('Execution time: %4.1f seconds\n',cputime - st);
    %fprintf('Status : %s\n',how);
    w2 = alpha'*H*alpha;
    %fprintf('|w0|^2    : %f\n',w2);
    margin = 2/sqrt(w2);
    %fprintf('Margin    : %f\n',margin);
    %fprintf('Sum alpha : %f\n',sum(alpha));
    
    % Compute the number of Support Vectors
    svi = find( alpha > epsilon);
    nsv = length(svi);
    fprintf('Support Vectors : %d (%3.1f%%)\n',nsv,100*nsv/n);

    if ~fixed_bias
      %disp('Computing bias...');
      % find bias from average of support vectors on margin
      % SVs on margin have alphas: 0 < alpha < C
      svii = find( alpha > epsilon & alpha < (C - epsilon));
      if length(svii) > 0
        bias =  (1/length(svii))*sum(Y(svii) - H(svii,svi)*alpha(svi).*Y(svii));
      else 
        fprintf('No support vectors on margin - cannot compute bias.\n');
      end
    end
    
  end
 
    
