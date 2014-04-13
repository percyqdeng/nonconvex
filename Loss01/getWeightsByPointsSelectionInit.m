%returns the initial combination 
%of the decision boundary using points selection method
%(with priority in increasing distance to SVM hyperplane) 
function ps = getWeightsByPointsSelection2(X,t)

[N,D] = size(X);
D = D - 1;
w_svm = getWeightsByLinearSVM(X,t);
loss_min = cal01Loss(X,t,w_svm);
sum_min = 0; %sum of targets in ps of current solution
d = abs(X * w_svm);
[d2, id] = sort(d);
ps = 1:D;

i = D;
while i >= 1
    A = X(id(ps),2:D+1);
    b = ones(D,1);
    w2 =  [-1; A \ b];
    if norm(w2) < 1e6
        loss = cal01Loss(X,t,w2);
        loss2 = cal01Loss(X,t,-w2);
        if loss2 < loss
            loss = loss2;
            w2 = -w2;
        end
        if (loss < loss_min) || (loss == loss_min && sum_min < abs(sum(t(id(ps)))))
            loss_min = loss;
            sum_min = abs(sum(t(id(ps)))); %if same loss, prefer hyperplane through points in a same class
            w = w2;
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

