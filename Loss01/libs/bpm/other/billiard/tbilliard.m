function [m,run] = tbilliard(x, w0, nbounces)
% x is prescaled columns
% w0 is starting guess

[d,n] = size(x);
w0 = w0(:)/norm(w0)/2;
m = zeros(d,1);
s = 0;
run.m = zeros(d,nbounces);
run.hits = [];
run.flops = zeros(1,nbounces);
nskip = 0;

% loop trajectories
count = 0;
last_hit = -1;
while(count < nbounces)
  if last_hit > 0
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
  % only pursue for 100 bounces
  for nhit = 1:100
    % compute flight times
    wn = w'*x;
    vn = v'*x;
    flight = ones(1,n)*Inf;
    i = find(vn < 0);
    flight(i) = -wn(i)./vn(i);
    % flight time to the sphere
    % assumes norm(v) = 1
    flight(n+1) = sqrt((w'*v)^2 - w'*w + 1) - (w'*v);
    if last_hit > 0
      flight(last_hit) = Inf;
    end
    [flight,hit] = min(flight);
    w2 = w + flight*v;
    count = count + 1;
    if nargout > 1
      %run.hits(:,count) = w2;
    end
    if nhit > nskip
      len = norm(w2 - w);
      s = s + len/2;
      m = m + (0.5*len/s)*(w - m);
      s = s + len/2;
      m = m + (0.5*len/s)*(w2 - m);
      if nargout > 1
	run.m(:,count) = m/norm(m);
	run.flops(count) = flops;
      end
    end
    % new position
    %disp(flight^2 + 2*(w'*v)*flight + w'*w)
    %disp((w + flight*v)'*(w + flight*v))
    w = w2;
    % new direction
    if hit == n+1
      % hit the sphere
      v = v - 2*w*(w'*v);
      last_hit = -1;
    else
      v = v - 2*vn(hit)*x(:,hit)/(x(:,hit)'*x(:,hit));
      last_hit = hit;
    end
    % v does not need to be normalized
    % it will retain the length it had before
  end
end
  
m = m/norm(m);
