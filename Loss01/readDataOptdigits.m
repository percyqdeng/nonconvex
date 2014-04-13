%read 01 loss input data from data.csv
function [X,t] = readDataOptdigits(filename, class1, class2)

if nargin == 0
    filename = 'data\optdigits.tra';
    class1 = 5;
    class2 = 6;
end



Data = csvread(filename);
[N,D] = size(Data);
t = Data(:,D);
X = Data(:,1:D-1);
ids = find(t==class1 | t==class2);
t = t(ids);
X = X(ids,:);
t( t==class1 ) = 1;
t( t==class2 ) = -1;

%add dummy column of 1 to X for bias w0
[N,D] = size(X);
X = [ones(N,1), X]; 


end

