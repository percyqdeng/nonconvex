function main_usps_reg()

clc;
[X0,t0] = readData('data\usps89.trn');
[Xt,tt] = readData('data\usps89.tst');

noise = 0.4;
regCoeff = 0.1:0.2:3;
L = length(regCoeff);
sr_slo = zeros(1, L);
loss_slo = zeros(1, L);
[X, t] = noisify(X0, t0, noise);
[N, D] = size(X);

%find liblinear SVM solution
model = train(t,sparse(X),'-s 3 -c 1 -e 0.001');
w_svm = model.w';
if calLoss(X,t,w_svm) > N/2
    w_svm = -1 * w_svm;
end
[pt_svm, sr_svm] = predictByWeights(tt, Xt, w_svm);
loss_svm = calLoss(X,t,w_svm);

for i = 1:L
    w_slo = smoothLossOptimizer(X, t, w_svm, regCoeff(i));
    [pt_slo, sr_slo(i)] = predictByWeights(tt, Xt, w_slo);
    loss_slo(i) = calLoss(X,t,w_slo);
end

figure(1);
plot(regCoeff, sr_svm * ones(1,L), 'ro-', regCoeff, sr_slo, 'bs-');
xlabel('Regularization Coefficient');
ylabel('Accuracy');
legend('SVM', 'Regularized 01-Loss');

figure(2);
plot(regCoeff, loss_svm * ones(1,L), 'ro-', regCoeff, loss_slo, 'bs-');
xlabel('Regularization Coefficient');
ylabel('Training Loss');
legend('SVM', 'Regularized 01-Loss');

end

