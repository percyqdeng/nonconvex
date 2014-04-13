
clc;

ds = {'dataUCI\breast-cancer-wisconsin.csv', ...
    'dataUCI\bupa.csv', 'dataUCI\cmc.csv', 'dataUCI\heart.csv', ...
    'dataUCI\indian_liver.csv', 'dataUCI\pima-indians-diabetes.csv', ...
    'dataUCI\sonar.csv'};

L0 = zeros(5, length(ds));
L1 = zeros(5, length(ds));

for k = 1:length(ds)
    [X,t] = readData(char(ds(k)));
    [N,D] = size(X); 
    fprintf('TESTING DATASET: %s. N = %d, D = %d. \n', char(ds(k)), N, D-1);

    X = normalizeData(X);
    L0(1,k) = getMinimal01LossByBPM(X,t);
    L0(2,k) = getMinimal01LossBySVM(X,t); 
    L0(3,k) = getMinimal01LossByLR(X,t); 
    L0(4,k) = getMinimal01LossByALA(X,t);
    min3 = min(L0(1:3,k));
    if min3 > 0
        L0(5,k) = round(100*(min3 - L0(4,k))/min3);
    end
    fprintf('***0NoiseLosses [BPM, SVM, LR, ALA] = %s. Impr: %d%%\n', ...
        mat2str(L0(1:4,k)',5), L0(5,k));
    [X,t] = readData(char(ds(k)));
    [X,t] = noisifyData(X,t,'WhiteNoise',0.10);
    X = normalizeData(X);
    L1(1,k) = getMinimal01LossByBPM(X,t);
    L1(2,k) = getMinimal01LossBySVM(X,t);
    L1(3,k) = getMinimal01LossByLR(X,t);
    L1(4,k) = getMinimal01LossByALA(X,t);
    min3 = min(L1(1:3,k));
    if min3 > 0
        L1(5,k) = round(100*(min3 - L1(4,k))/min3);
    end
    fprintf('***1NoiseLosses [BPM, SVM, LR, ALA] = %s. Impr: %d%%\n', ...
        mat2str(L1(1:4,k)',5), L1(5,k));
end

L0

L1


