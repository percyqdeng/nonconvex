function K = kerneldiag(ker,X)
% Returns the diagonal of the kernel matrix, i.e. K(i) = kernel(X(i,:),X(i,:))
% X is matrix of rows
% ker is string

global p1

switch lower(ker)
  case 'linear'
    K = sum(X.^2,2);
  case 'poly'
    K = (sum(X.^2,2)+1).^p1;
  case 'discrete'
  case 'rbf'
    K = ones(rows(X),1);
  otherwise
    for i = 1:rows(X)
      K(i) = kernel(obj.kernel, X(i,:), X(i,:));
    end
end
