
clc;
clear;

NTests = 4;
Ns = 120:20:140;
D = 10;

slaT = zeros(1,length(Ns));
ilpT = zeros(1,length(Ns));
slaL = zeros(length(Ns),NTests);
ilpL = zeros(length(Ns),NTests);

for i = 1:length(Ns)
    for k = 1:NTests
        fprintf('D = %d. Test #%d of %d \n', D, k, NTests);
        [X,t] = generateTestData(Ns(i), D, [3 60]);
        fprintf('Training data: N = %d, D = %d. \n', Ns(i), D);

        tic; 
        w = getWeightsByALA(X, t);
        slaT(i) = slaT(i) + toc;
        slaL(i,k) = cal01Loss(X,t,w);

        tic; 
        w = getWeightsByLP(X, t);
        ilpT(i) = ilpT(i) + toc;
        ilpL(i,k) = cal01Loss(X,t,w);
        
        if (slaL(i,k) ~= ilpL(i,k))
            fprintf('***Loss Difference Detected: slaL = %d, ilpL = %d.\n', slaL(i,k), ilpL(i,k));
        end
    end
end

slaT = slaT / NTests;
ilpT = ilpT / NTests;

figure(1);
plot(Ns, slaT, '-b', Ns, ilpT, '-r'); 
legend('SLA', 'ILP');
xlabel('Number of Datapoints');
ylabel('Running Time (sec)');
