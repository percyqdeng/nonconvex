%returns the approximation to optimal weights w0, w = [w_1 ... w_D] 
%of the decision boundary using points selection method
function [w T0] = getWeightsByPointsSelection3(X, t, timeLimit )

ticId = tic;
T0 = 0;
if nargin < 3, timeLimit = 1e9; end
timeLimit0 = 0.4*timeLimit; %initial PS time limit
timeLimit1 = 0.6*timeLimit; %swapping time limit


[N,D] = size(X);
D = D - 1;
w_lr = getBestWeightsByLR(X,t);
d = abs(X * w_lr);
[d2, id] = sort(d);
[ps, w, loss_min, sum_min] = getInitialPS();

updated = 1;
while updated %&& toc(ticId) < timeLimit1
    updated = 0;
    for k=1:N
        for m=1:D
            if isempty(find(ps==id(k),1,'first'))
                tmp = ps(m);
                ps(m) = id(k);
                [w2, l2] = getSolution(ps);
                if (l2 < loss_min) || (l2 == loss_min && sum_min < abs(sum(t(ps))))
                    w = w2;
                    loss_min = l2;
                    sum_min = abs(sum(t(ps)));
                    updated = 1;
                    T0 = toc(ticId);
                    %fprintf('*** Loss = %d, found \n', loss_min);
                    break;
                else
                    ps(m) = tmp;
                end
            end
        end
        if updated == 1 
            break; 
        end
    end
end

    function [rw, rloss] = getSolution(indices)
        A = X(indices,2:D+1);
        b = ones(D,1);
        rw =  A \ b;
        nrm = norm(rw);
        if nrm < 1e6 && nrm > 1e-6
            [rw rloss] = getBestCSWeights(X, t, rw);
        else
            rloss = 10e9;
        end
    end

    function [p, w, l, s] = getInitialPS()  
        N2 = min(D+10,N); %number of points to check for initial ps
        ps = 1:D;
        l = 10e9;
        s = 0;
        i = D;
        while i >= 1 && toc(ticId) < timeLimit0
            psIds = id(ps);
            [w2, l2] = getSolution(psIds);
            if (l2 < l) || (l2 == l && s < abs(sum(t(psIds))))
                l = l2;
                w = w2;
                p = psIds;
                s = abs(sum(t(psIds)));
                T0 = toc(ticId);
                %fprintf('*** Initial Loss = %d, found \n', l);
            end    

            %generate next points set combination
            i = D;
            while i >= 1
                if ps(i) < N2-D+i 
                    ps(i) = ps(i) + 1;
                    break;
                else 
                    while i >= 1 && ps(i) >= N2-D+i 
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
    end

end

