%read 01 loss input data from data.csv
function [X,t] = readDataLibSVM(filename, class1, class2)

if nargin == 0
    filename = 'data\usps';
    class1 = 1;
    class2 = 2;
end

[t, X] = libsvmread(filename);

ids = find(t==class1 | t==class2);
t = t(ids);
X = X(ids,:);
t( t==class1 ) = 1;
t( t==class2 ) = -1;

%add dummy column of 1 to X for bias w0
[N,D] = size(X);
X = [ones(N,1), X]; 


end

