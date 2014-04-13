%returns the weights w0, w = [w_1 ... w_D] 
%of the decision boundary using logistic regression
function w = getWeightsByLogisticRegressionOld(X, t)

t( (t(:)==-1) ) = 0;    %change target encoding {-1,1} to {0,1}
[N,D] = size(X);
w = 0.001 * ones(D,1);  %init w to small number
learningRate = 0.15;    %learning rate

for n=1:N
    w = w - learningRate * ((logsig(X(n,:) * w) - t(n)) * X(n,:)');
end

w = w / norm(w);

end

