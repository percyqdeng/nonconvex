% Copyright 2013, Gurobi Optimization, Inc.

%[X,t] = readData('data\data_small.csv');
[X,t] = generateTestData(50, 2, [3 20]);
[N, D] = size(X);
fprintf('Training data: N = %d, D = %d. \n', N, D);

M = 1.00e2;
%try
    clear model;
    model.lb = [zeros(1,N) -1e6*ones(1,D)];
    model.ub = [ones(1,N) 1e6*ones(1,D)];
    model.vtype = [char(66*ones(1,N)) char(67*ones(1,D))];
    model.modelsense = 'max';
    model.obj = [ones(1,N) zeros(1,D)];
    
    model.rhs = zeros(N*2+1,1);
    A = zeros(2*N+1, N+D);
    model.sense = char(62*ones(1,2*N+1));
    for i=1:N
        A(2*i-1,i) = M;
        A(2*i,i) = M;
        for j=1:D
            if t(i) == 1
                A(2*i-1,j+N) = -X(i,j);
                A(2*i,j+N) = -X(i,j);
            else
                A(2*i-1,j+N) = X(i,j);
                A(2*i,j+N) = X(i,j);
            end
        end
        model.rhs(2*i-1) = M - 1e-4; 
        model.rhs(2*i) = -1e-4;
        model.sense(2*i-1) = '<';
    end
    A(2*N+1,N+1:N+D) = ones(1, D);
    model.rhs(N*2+1) = 1;
    
    model.A = sparse(A);
    
    clear params;
    params.outputflag = 0;
    params.resultfile = 'mip1.lp';

    result = gurobi(model, params);

    disp(result);
    
    if exist('result.objval')
        fprintf('Obj: %e\n', result.objval);
    end

%catch gurobiError
%    fprintf('Error reported\n');
%end

w_lp = result.x(N+1:N+D);
w_lp = w_lp ./ w_lp(1);

%show all solutions on one graph
c1Idx = ( t(:) == 1 );  %indices of class 1
c2Idx = ( t(:) == -1);  %indices of class 2
 
[X1_lp, X2_lp] = getEndPointsOfDecisionLine(X, w_lp);

figure;
plot(X(c1Idx,2), X(c1Idx,3), 'r+', X(c2Idx,2), X(c2Idx,3), 'bo', ...
    X1_lp, X2_lp, 'g-');


legend('Class 0', 'Class 1', 'Linear Programming');



