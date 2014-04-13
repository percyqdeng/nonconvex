%normalize the data points X feature wise to zero mean & unit variance
%1st column is dummy col of values 1 for bias term => no normalization
function [normalizedX, means, stds] = normalizeData(X, b)

%low bias so that separation hyperplane doesnt goes through the origin
if nargin == 1, b = 0.0; end 

[N, D] = size(X);
means = zeros(1,D);
stds = zeros(1,D);
normalizedX = ones(N,D);
for i=2:D
    means(i) = mean(X(:,i)) - b;
    stds(i) = std(X(:,i));
    normalizedX(:,i) = (X(:,i) - means(i)) / stds(i);
end


end
