
function convertDataSonar()

Data = csvread('data\sonar.all-data');
[N,D] = size(Data);
t = Data(:,D);
X = Data(:,1:D-1);

D = [t, X];
csvwrite('data\sonar.csv', D);


end

