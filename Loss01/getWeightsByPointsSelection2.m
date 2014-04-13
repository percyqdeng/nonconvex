%returns the (optimal!) weights w0, w = [w_1 ... w_D] 
%of the decision boundary using points selection method
%(with priority in increasing distance to SVM hyperplane) 
function [w T0] = getWeightsByPointsSelection2(X, t, timeLimit)

ticId = tic;
T0 = 0;

if nargin < 3, timeLimit = 1e9; end

[N,D] = size(X);
D = D - 1;

w = getBestWeightsByLR(X,t);
loss_min = cal01Loss(X,t,w);

sum_min = 0; %sum of targets in ps of current solution
d = abs(X * w);
[d2, id] = sort(d);
ps = 1:D;

i = D;
while i >= 1 && toc(ticId) < timeLimit
    A = X(id(ps),2:D+1);
    b = ones(D,1);
    w2 = A \ b;
    nrm = norm(w2);
    if nrm < 1e6 && nrm > 1e-9
        [w2 loss] =  getBestCSWeights(X, t, w2);
        if (loss < loss_min) || (loss == loss_min && sum_min < abs(sum(t(id(ps)))))
            loss_min = loss;
            sum_min = abs(sum(t(id(ps)))); %if same loss, prefer hyperplane through points in a same class
            w = w2;
            T0 = toc(ticId);
            %fprintf('*** Loss = %d, found after %f sec\n', loss_min, t0);
        end
    end
    
    %generate next points set combination
    i = D;
    while i >= 1
        if ps(i) < N-D+i 
            ps(i) = ps(i) + 1;
            break;
        else 
            while i >= 1 && ps(i) >= N-D+i 
                i = i - 1;
            end
            if i >= 1 
                ps(i) = ps(i) + 1;
                for j=i+1:D
                    ps(j) = ps(j-1) + 1;
                end
                break;
            end
        end
    end
    %at this point i < 1 means all possible points set have been generated
end

%w = w_min / norm(w_min);


end

