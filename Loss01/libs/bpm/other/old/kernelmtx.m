function K = kernelmtx(ker,X,Y)
% X is matrix of rows
% ker is string

if nargin < 3
  Y = X;
end

global p1

nx = size(X,1);
ny = size(Y,1);
switch lower(ker)
  case 'discrete'
    if 1
      K = ones(nx,ny);
      for j = 1:cols(X)
	if rem(j,1000) == 0
	  disp(j)
	end
	% z is nx by ny equality matrix for attribute j
	z = (repmat(X(:,j), 1, ny) == repmat(Y(:,j)', nx, 1));
	K = K .* (1 + p1*z)/(1+p1);
      end
    else
      % faster for large cols(X) but it takes too much memory
      K = zeros(nx,ny);
      for j = 1:ny
	z = (X == repmat(Y(j,:),nx,1));
	K(:,j) = prod((1 + p1*z)/(1+p1),2);
      end
    end
  case 'linear'
    K = X*Y';
  case 'poly'
    K = (X*Y' + ones(nx,ny)).^p1;
  case 'rbf'
    X2 = repmat(sum(X.^2,2), 1, ny);
    Y2 = repmat(sum(Y.^2,2), 1, nx);
    K = X2+Y2'-2*X*Y';
    K = exp(-K/(2*p1^2));
  otherwise
    K = zeros(nx,ny);  
    for i=1:nx
      for j=1:ny
	K(i,j) = kernel(ker,X(i,:),Y(j,:));
      end
    end
end
