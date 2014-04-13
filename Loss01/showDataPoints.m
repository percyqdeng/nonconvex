function showDataPoints(X,t,A)
    c1Idx = ( t(:) == 1 );  %indices of class 1
    c2Idx = ( t(:) == -1);  %indices of class 2

    figure(10);
    plot(X(c1Idx,2),X(c1Idx,3), 'm+', X(c2Idx,2),X(c2Idx,3),'co', A(1,:), A(2,:), 'bx');
end