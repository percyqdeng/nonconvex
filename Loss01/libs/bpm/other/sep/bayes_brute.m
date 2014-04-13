function [w,v] = bayes_brute(x, nsamples, e)
% compute mean and variance of version space

if nargin < 3
  e = 0;
end

[d,n] = size(x);
groupsize = 10000;
total = zeros(d,1);
total2 = zeros(d*d,1);
total_ok = 0;

while(nsamples > 0)
  howmany = min([nsamples groupsize]);
  %disp(['sampling ' num2str(howmany)])
  % sample from N(0,I)
  ws = randn(d, howmany);
  % sample from Laplace(0,I)
  %ws = exprnd(1, 2*d, howmany);
  %ws = ws(1:d, :) - ws(d+(1:d), :);
  nsamples = nsamples - howmany;

  if e == 0
    ok = all(ws'*x > 0,2);
    i = find(ok);
    ws = ws(:,i);
    total = total + row_sum(ws);
    if nargout > 1
      total2 = total2 + row_sum(pkron(ws,ws));
    end
    total_ok = total_ok + length(i);
  else
    q = row_sum(ws'*x > 0);
    q = (1-e).^q .* e.^(n - q);
    total = total + ws*q;
    total_ok = total_ok + sum(q);
  end
  %disp(['total_ok = ' num2str(total_ok)])
end
w = total/total_ok;
v = reshape(total2/total_ok, d, d);
v = v - w*w';
