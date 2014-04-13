
function convertDataCancer()

Data = csvread('datatmp\breast-cancer-wisconsin.data');
[N,D] = size(Data);
t = Data(:,D);
t(t == 2) = 1;
t(t ~= 1) = -1;
X = Data(:,1:D-1);

D = [t, X];
csvwrite('dataUCI\breast-cancer-wisconsin.csv', D);


end

