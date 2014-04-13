function y = scale_cols(x, s)
% y(:,i) = x(:,i)*s(i)
% This is more efficient than x*diag(s)

y = x.*repmat(s(:)', rows(x), 1);
