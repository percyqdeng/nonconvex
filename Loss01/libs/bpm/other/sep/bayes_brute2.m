function m = bayes_brute2(x, nsamples, m, v)

d = rows(x);
groupsize = 10000;
total = zeros(d,1);
total_ok = 0;

c = chol(v)';
% same as 0.5*logdet(v)
dc = logdet(c);  

while(nsamples > 0)
  howmany = min([nsamples groupsize]);
  disp(['sampling ' num2str(howmany)])
  ws = randn(d, howmany);
  nsamples = nsamples - howmany;

  z = sum(ws.^2);
  % make it a sample from the proposal
  ws = c*ws + repmat(m, 1, howmany);
  ok = all(ws'*x > 0,2);
  disp(['ok = ' num2str(sum(ok))])
  i = find(ok);
  ws = ws(:,i);
  z = z(i);
  % q = true/proposal
  q = exp(-0.5*sum(ws.^2) + 0.5*z + dc);
  total = total + ws*q';
  total_ok = total_ok + sum(q);

  if 0
    % adapt the proposal
    v = cov_t(ws);
    c = chol(v)';
    dc = logdet(c);
  end
end
m = total/total_ok;
