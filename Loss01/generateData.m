%generate 01 loss data points and write to data.csv
function generateData(N, D, R, NC, StdDev)

if (nargin == 0)
    D = 6;      %dimension of data point
    N = 200;    %number of data points
    R = 6;     %range of all points +/- R ~ dis c1 c2
    NC = 2;     %number of clusters
    StdDev = 6; %Max standard deviation of points in each clusters
end

c = zeros(NC, D);
sd = zeros(NC, D);
for i=1:NC
    %generate center of cluster i
    if (mod(i,4) == 1)
        c(i,:) = random('Uniform', 0, R/2, 1, D);   
    elseif (mod(i,4) == 2)
        c(i,:) = random('Uniform', -R/2, 0, 1, D);  
    elseif (mod(i,4) == 3)
        c(i,:) = R/2 * ones(1,D);
        c(i,1) = - c(i,1);
    else
        c(i,:) = R/2 * ones(1,D);
        c(i,2) = - c(i,2);
    end
    sd(i,:) = random('Uniform', 0, StdDev, 1, D); %std dev in each direction from c(i)
end
    
X = zeros(N,D);
t = ones(N,1);

for i=1:N
    k = mod(i,NC) + 1; %k = idx of the cluster to use
    
    %determine class (1 or -1)
    if (mod(k,2) == 1)
        t(i) = 1;
    else
        t(i) = -1;
    end
    
    %generate data point
    for j=1:D
        X(i,j) = random('Normal',c(k,j),sd(k,j),1,1);
    end
end

% for i=N*0.9+1:N
%    t(i) = -1; %mod(i,2);
%    if t(i) == 0, t(i)=-1; end
%    X(i,:) = random('Uniform',-0*R,1*R,1,D);
% end

D = [t,X];
csvwrite('data\data_small.csv',D);


c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2

figure(2);
plot(X(c1Idx,1),X(c1Idx,2), 'r+', X(c2Idx,1),X(c2Idx,2),'bo');


end

