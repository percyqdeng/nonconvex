%read 01 loss input data from data.csv
function convertDataUSPS()

class1 = 8;
class2 = 9;

[t, X] = libsvmread('data\usps');
X = full(X);
ids = find(t==class1 | t==class2);
t = t(ids);
X = X(ids,:);
t( t==class1 ) = 1;
t( t==class2 ) = -1;
D = [t, X];
csvwrite('data\usps89.trn', D);


[t, X] = libsvmread('data\usps.t');
X = full(X);
ids = find(t==class1 | t==class2);
t = t(ids);
X = X(ids,:);
t( t==class1 ) = 1;
t( t==class2 ) = -1;
D = [t, X];
csvwrite('data\usps89.tst', D);


end

