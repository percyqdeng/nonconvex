%returns the weights w0, w = [w_1 ... w_D] 
%of the decision boundary using logistic regression
function w = getWeightsByLogisticRegression(X, t, C)

if nargin < 3, C = 1; end

model = train(t,sparse(X),['-s 0 -c ', num2str(C), ' -e 0.0001']);
w = model.w';
if cal01Loss(X,t,w) > cal01Loss(X,t,-w)
    w = -w;
end


end

