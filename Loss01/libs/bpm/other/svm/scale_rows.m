function y = scale_rows(x,s)
% y(i,:) = s(i)*x(i,:)
% this is more efficient than diag(s)*x

y = repmat(s(:), 1, cols(x)).*x;
%y = (s(:)*ones(1,cols(x))).*x;
