% Given the training set X, t
% Returns best SVM weights for the seperating hyperplane
function w = getWeightsByLinearSVM(X,t,C)

if nargin < 3, C = 1; end

model = train(t,sparse(X),['-s 2 -c ', num2str(C), ' -e 0.0001']);
w = model.w';
if cal01Loss(X,t,w) > cal01Loss(X,t,-w)
    w = -1 * w;
end


end

