
function convertDataSonar()

Data = csvread('data\bupa.data');
[N,D] = size(Data);
t = Data(:,D);
t(t ~= 1) = -1;
X = Data(:,1:D-1);

D = [t, X];
csvwrite('data\bupa.csv', D);


end

