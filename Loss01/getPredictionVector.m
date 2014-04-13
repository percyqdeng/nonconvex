function predictionVector = getPredictionVector(X, w)

predictionVector = X * w;
predictionVector(predictionVector >=0 ) = 1;
predictionVector(predictionVector ~= 1) = -1;


end
