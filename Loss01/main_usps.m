function main_usps()

clc;
[X0,t0] = readData('data\usps89.trn');
[Xt,tt] = readData('data\usps89.tst');

noise = 0.4:0.05:0.4;
sr_svm = zeros(1, length(noise));
sr_slo = zeros(1, length(noise));
loss_svm = zeros(1, length(noise));
loss_slo = zeros(1, length(noise));

for i = 1:1:length(noise)
    
[X, t] = noisify(X0, t0, noise(i));
[N, D] = size(X);

%find liblinear SVM solution
model = train(t,sparse(X),'-s 3 -c 1 -e 0.001');
w_svm = model.w';
if calLoss(X,t,w_svm) > N/2
    w_svm = -1 * w_svm;
end
[pt_svm, sr_svm(i)] = predictByWeights(tt, Xt, w_svm);
loss_svm(i) = calLoss(X,t,w_svm);

%find optimize smooth lost SGD solution
w_slo = smoothLossOptimizer(X, t, w_svm);
[pt_slo, sr_slo(i)] = predictByWeights(tt, Xt, w_slo);
loss_slo(i) = calLoss(X,t,w_slo);

end

figure(1);
plot(noise, sr_svm, 'ro-', noise, sr_slo, 'bs-');
xlabel('Noise level');
ylabel('Accuracy');
legend('SVM', 'Optimal 01Loss');

figure(2);
plot(noise, loss_svm, 'ro-', noise, loss_slo, 'bs-');
xlabel('Noise Level');
ylabel('Training Loss');
legend('SVM', 'Optimal 01Loss');

end

