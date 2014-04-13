%returns the (optimal!) weights w0, w = [w_1 ... w_D] 
%of the decision boundary using linear programming method
%LP lib: Gurobi 
function w = getWeightsByLP(X, t)

[N, D] = size(X);
M = 1.00e2;

clear model;
% N boolean vars D continuous vars
model.vtype = [char(66*ones(1,N)) char(67*ones(1,D))]; 
model.lb = [zeros(1,N) -10*M*ones(1,D)]; % set lower bounds
model.ub = [ones(1,N) 10*M*ones(1,D)]; % set upper bounds
model.modelsense = 'max';
model.obj = [ones(1,N) zeros(1,D)]; % maximize # of correct classification 

model.rhs = zeros(N*2+1,1); %init RHS
A = zeros(2*N+1, N+D); % constraints matrix
model.sense = char(62*ones(1,2*N+1)); % init to all >>>>>>...
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
    model.rhs(2*i-1) = M - 1e-3; % -1e3: small number to enforce >= M
    model.rhs(2*i) = -1e-3; % -1e3: small number to enforce <= 0
    model.sense(2*i-1) = '<'; %change constraint direction to <=
end

%add constraints sum(w_i) >= 1 so that they don't all approach zero
A(2*N+1,N+1:N+D) = ones(1, D);
model.rhs(N*2+1) = 1;

model.A = sparse(A);

clear params;
params.outputflag = 0;
%params.resultfile = 'mip1.lp';

%run the solver
result = gurobi(model, params);

%disp(result);
fprintf('Obj: %d\n', result.objval);

w = result.x(N+1:N+D);

end

