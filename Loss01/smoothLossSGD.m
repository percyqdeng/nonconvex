% use stochastic gradient descent on the smooth loss function
% and return weights (w0 normalised to 1 or -1)
function w = smoothLossSGD(X,t)

[N,D] = size(X);
w = 0.001*ones(D,1);    %init w to small number
learningRate = 0.1;    %learning rate
K = 2;                  %high smoothness, eliminate local min => approximate 
                        %global min by general trend of the function
for n=1:N
    s = logsig(-K * t(n) * (X(n,:) * w)); %value of smooth loss at x_n 
    w = w + learningRate * s * (1 - s) * (K * t(n)) * X(n,:)';
end

w = w / norm(w);

end

