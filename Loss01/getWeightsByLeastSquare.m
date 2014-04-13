%returns the weights , w = [w_1, ..., w_D, w0] 
%of the decision boundary using least square method
function w = getWeightsByLeastSquare(X,t)

w = (X' * X) \ (X' * t);    %solve the normal equation
w(isnan(w))=0;
w = w / norm(w);            %normalize weights

end

