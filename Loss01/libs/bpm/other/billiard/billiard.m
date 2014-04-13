function [m,run] = billiard(x, w0, nbounces)
% Rujan's Billiard alg
% x is prescaled columns
% w0 is starting guess (from SVM)

tmax = 1e5;

[d,n] = size(x);
w0 = w0(:)/norm(w0);
m = zeros(d,1);
s = 0;
run.m = zeros(d,nbounces);
run.hits = [];
run.flops = zeros(1,nbounces);

% loop trajectories
count = 0;
restart_count = 0;
last_hit = -1;
while(count < nbounces)
  if 0 & last_hit > 0
    % Herbrich restart
    while(1)
      v = randn(d,1);
      v = v/norm(v);
      % going in right direction?
      if v'*x(:,last_hit) > 0
	% yes
	break
      end
    end
  else
    % Rujan restart
    %v = sign(2*rand(d,1)-1);
    v = randn(d,1);
    v = v/norm(v);
    w = w0;
    last_hit = -1;
  end
  
  % one trajectory
  while(count < nbounces)
    % compute flight times
    wn = w'*x;
    vn = v'*x;
    flight = ones(1,n)*Inf;
    i = find(vn < 0);
    flight(i) = -wn(i)./vn(i);
    if last_hit > 0
      flight(last_hit) = Inf;
    end
    [flight,hit] = min(flight);
    if flight > tmax
      restart_count = restart_count + 1;
      break
    end
    w2 = w + flight*v;
    w2 = w2/norm(w2);
    count = count + 1;
    if nargout > 1
      %run.hits(:,count) = w2;
    end
    len = norm(w2 - w);
    s = s + len/2;
    m = m + (0.5*len/s)*(w - m);
    s = s + len/2;
    m = m + (0.5*len/s)*(w2 - m);
    % Rujan projects each time
    m = m/norm(m);
    if nargout > 1
      run.m(:,count) = m;
      run.flops(count) = flops;
    end
    % new position
    w = w2;
    last_hit = hit;
    % new direction
    v = v - 2*vn(hit)*x(:,hit)/(x(:,hit)'*x(:,hit));
    v = v/norm(v);
  end
end
fprintf('bounces:%d restarts:%d\n', count, restart_count);
