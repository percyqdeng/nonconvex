%returns the weights w0, w = [w_1 ... w_D] 
%of the decision boundary using ALA 
function w = getWeightsByALA(X, t)

w = getBestWeightsByLR(X,t);
w = smoothLossOptimizer(X, t, w, 0);
w = Loss01Explorer(X,t,w);

end

