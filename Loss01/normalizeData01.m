%normalize the data points X feature wise to be in range [0, 1]
%1st column is dummy col of values 1 for bias term => no normalization
function [normalizedX, mins, maxs] = normalizeData01(X)

[N, D] = size(X);
mins = zeros(1,D);
maxs = zeros(1,D);
normalizedX = ones(N,D);
for i=2:D
    mins(i) = min(X(:,i));
    maxs(i) = max(X(:,i));
    normalizedX(:,i) = (X(:,i) - mins(i)) / (maxs(i)-mins(i));
end


end
