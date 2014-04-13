%add different types of noise to the data set X,t
function [X, t] = noisifyData(X, t, noiseType, noiseLevel)

[N, D] = size(X);
k = floor(N * noiseLevel);

if strcmp(noiseType, 'FlipLabels')      %flip labels of data points
    ids = randperm(N);
    ids = ids(1:k);
    t(ids) = -1 * t(ids);
    
elseif strcmp(noiseType, 'WhiteNoise')  %uniform random noise
    tnoise = random('binomial', 1, 0.5, k, 1);
    tnoise(tnoise ~= 1) = -1;
    Xnoise = ones(k, D);
    for j=2:D
        minX = min(X(:,j));
        maxX = max(X(:,j));
        minNoise = minX - 0.5 * (maxX-minX);
        maxNoise = maxX + 0.5 * (maxX-minX);
        Xnoise(:,j) = random('uniform', minNoise, maxNoise, k, 1);
    end
    X = [X; Xnoise];
    t = [t; tnoise];
    
elseif strcmp(noiseType, 'WhiteNoise1')  %uniform random noise for 1 class
    tnoise = ones(k, 1);
    Xnoise = ones(k, D);
    for j=2:D
        minX = min(X(:,j));
        maxX = max(X(:,j));
        minNoise = minX - 0.5 * (maxX-minX);
        maxNoise = maxX + 0.5 * (maxX-minX);
        Xnoise(:,j) = random('uniform', minNoise, maxNoise, k, 1);
    end
    X = [X; Xnoise];
    t = [t; tnoise];
    
elseif strcmp(noiseType, 'Outliers')    %add outliers to data set
    w_svm = getWeightsByLinearSVM(X, t);
    minDist = 0.9 * max(abs(X*w_svm));  %min distance to boudary of outliers
    t2 = ones(k,1);
    if sum(t==1) > sum(t==-1)   
        t2 = -1*t2;     %add outliers to class with less count
    end
    X2 = zeros(k,D);
    minX = min(X);
    maxX = max(X);
    diff = maxX - minX;
    %determine the data range of outliers
    minO = minX - 0.75 * diff;
    maxO = maxX + 0.75 * diff;
    for i=1:k
        while X2(i,1) == 0
            for j=2:D
                X2(i,j) = random('uniform', minO(j), maxO(j), 1, 1);
            end
            X2(i,1) = 1;
            if t2(i) * (X2(i,:) * w_svm) >= -minDist
                %X2(i) not an outlier: correct class or close to boundary
                X2(i,1) = 0;    
            end
            
        end
    end
    X = [X; X2];
    t = [t; t2];
    
else 
    error(['Unknown noiseType = "', noiseType, '"']);
    
end


end
