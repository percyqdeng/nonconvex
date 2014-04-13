
function convertDataIris()

Data = csvread('datatmp\iris2.data');
[N,D] = size(Data);
t = Data(:,D);
t(t ~= 2) = -1;
t(t ~= -1) = 1;
X = Data(:,1:D-1);

D = [t, X];
csvwrite('data\iris.csv', D);


end

