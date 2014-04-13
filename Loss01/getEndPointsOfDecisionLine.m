%get end points of the decision line w^T x + w0 = 0
%which match the range of data in X for the purpose 
%of drawing the decision line using function plot()
function [X1,X2] = getEndPointsOfDecisionLine(X, w)

if w(2) == 0
    w(2) = 1e-7;
end
if w(3) == 0
    w(3) = 1e-7; 
end

minX1 = min(X(:,2));
maxX1 = max(X(:,2));
minX2 = min(X(:,3));
maxX2 = max(X(:,3));

X2_minX1 = (-w(2)/w(3)) * minX1 - w(1)/w(3);
X2_maxX1 = (-w(2)/w(3)) * maxX1 - w(1)/w(3);
X1_minX2 = (-w(3)/w(2)) * minX2 - w(1)/w(2);
X1_maxX2 = (-w(3)/w(2)) * maxX2 - w(1)/w(2);

X1 = [minX1, maxX1]';
X2 = [X2_minX1, X2_maxX1]';

if X2_minX1 > maxX2 
    X2(1) = maxX2;
    X1(1) = X1_maxX2;
end

if X2_minX1 < minX2 
    X2(1) = minX2;
    X1(1) = X1_minX2;
end

if X2_maxX1 > maxX2 
    X2(2) = maxX2;
    X1(2) = X1_maxX2;
end

if X2_maxX1 < minX2 
    X2(2) = minX2;
    X1(2) = X1_minX2;
end


    
end

