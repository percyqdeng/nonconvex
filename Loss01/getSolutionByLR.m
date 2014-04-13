%returns the weights w0, w = [w_1 ... w_D] 
%of the decision boundary using logistic regression
function [w loss] = getSolutionByLR(X, t, C)

if nargin < 3, C = 1; end

model = train(t,sparse(X),['-s 0 -c ', num2str(C), ' -e 0.0001']);
w = model.w';
loss = cal01Loss(X,t,w);
loss2 = cal01Loss(X,t,-w);
if loss2 < loss
    w = -w;
    loss = loss2;
end


end

