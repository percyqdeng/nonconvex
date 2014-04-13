function w = perceptron(data)

[d,n] = size(data);
w = ones(d,1);
pinvd = pinv(data);

for iter = 1:200
  old_w = w;
  
  s = w'*data;
  % probit regression
  q = s + exp(gauss_logProb(s, 0, 1) - gauss_logcdf(s));
  w = (q*pinvd)';
  delta = w - old_w;
  
  % no change?
  if max(abs(delta)) < 1e-4
    break
  end

end
