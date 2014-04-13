%returns the weights w0, w = [w_1 ... w_D] 
%of the decision boundary using modified gradient descent 
function w = getWeightsBySmoothLoss(X, t)

%First use SGD to approximate global minimum
w = smoothLossSGD(X,t);

%show result after SGD
%smoothLossViz(X,t,200,w); 

%Then fine tune by hill climbing
w = smoothLossRangeOptimizer(X, t, w, 10, 0.1);

%show result after fine tuning
%smoothLossViz(X,t,100,w,w0); 

end

