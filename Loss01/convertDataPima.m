
function convertDataCmc()

Data = csvread('data\pima-indians-diabetes.data');
[N,D] = size(Data);
t = Data(:,D);
t(t ~= 1) = -1;
X = Data(:,1:D-1);

D = [t, X];
csvwrite('data\pima.csv', D);


end

