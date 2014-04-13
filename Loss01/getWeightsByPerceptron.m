%returns the weights w = [w_1, ..., w_D, w_0] 
%of the decision boundary using logistic regression
%X has last column = 1 corresp. to bias w0 at end of w
function w = getWeightsByPerceptron(X,t)

[N,D] = size(X);
w = 0.001 * ones(D,1); %init w to small number

for n=1:N
    %update weights by misclassified points
    if (t(n) * (X(n,:) * w) <= 0)
        w = w + t(n) * X(n,:)';
    end
end

w = w / norm(w);

end

