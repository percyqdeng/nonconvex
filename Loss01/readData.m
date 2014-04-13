%read 01 loss input data from data.csv
function [X,t] = readData(filename)

if nargin == 0
    filename = 'data.csv';
end
Data = csvread(filename);
[N,D] = size(Data);
t = Data(:,1);
X = Data(:,2:D);
%add dummy column of 1 to X for bias w0
X = [ones(N,1), X]; 


end

