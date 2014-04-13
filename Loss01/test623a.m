
clc;
% ds = {'dataUCI\breast-cancer-wisconsin.csv', ...
%     'dataUCI\bupa.csv', 'data\data6.csv', 'dataUCI\heart.csv', ...
%     'dataUCI\indian_liver.csv', 'dataUCI\pima-indians-diabetes.csv', ...
%     'dataUCI\sonar.csv'};
ds = {'dataUCI\cmc.csv'};

L0 = zeros(7, length(ds));
L1 = zeros(7, length(ds));
T0 = zeros(7, length(ds));
T1 = zeros(7, length(ds));

timeLimit = 300.0;

warning off;

set(0,'RecursionLimit',1900)

for k = 1:length(ds)
    [X,t] = readData(char(ds(k)));
    [N,D] = size(X); 
    fprintf('TESTING DATASET: %s. N = %d, D = %d. \n', char(ds(k)),N,D-1);

    X = normalizeData(X);
%     [L0(1,k) T0(1,k)] = getMinimal01LossByBnB(X, t, timeLimit);
    [L0(2,k) T0(2,k)] = getMinimal01LossByPCS(X, t, timeLimit);
    [L0(3,k) T0(3,k)] = getMinimal01LossByCSA(X, t, timeLimit);
%     [L0(4,k) T0(4,k)] = getMinimal01LossBySLA(X, t);
%     [L0(5,k) T0(5,k)] = getMinimal01LossByBPM(X, t);
%     [L0(6,k) T0(6,k)] = getMinimal01LossBySVM(X, t);
%     [L0(7,k) T0(7,k)] = getMinimal01LossByLR(X, t);
    fprintf('***0NoiseLosses [BnB,PCS,CSA,SLA,BPM,SVM,LR] = %s\n',...
         mat2str(L0(:,k)',4));
    fprintf('***0NoiseTimes = %s\n',...
         mat2str(T0(:,k)',4));
    
    [X,t] = readData(char(ds(k)));
    [X,t] = noisifyData(X,t,'WhiteNoise',0.10);
    X = normalizeData(X);
    %[L1(1,k) T1(1,k)] = getMinimal01LossByBnB(X, t, timeLimit);
    [L1(2,k) T1(2,k)] = getMinimal01LossByPCS(X, t, timeLimit);
    [L1(3,k) T1(3,k)] = getMinimal01LossByCSA(X, t, timeLimit);
    [L1(4,k) T1(4,k)] = getMinimal01LossBySLA(X, t);
    [L1(5,k) T1(5,k)] = getMinimal01LossByBPM(X, t);
    [L1(6,k) T1(6,k)] = getMinimal01LossBySVM(X, t);
    [L1(7,k) T1(7,k)] = getMinimal01LossByLR(X, t);
    fprintf('***1NoiseLosses [BnB,PCS,CSA,SLA,BPM,SVM,LR] = %s\n',...
        mat2str(L1(:,k)',4));
    fprintf('***1NoiseTimes = %s\n',...
        mat2str(T1(:,k)',4));
end

set(0,'RecursionLimit',500)
warning on;

L0
L1
T0
T1



