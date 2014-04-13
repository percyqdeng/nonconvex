%returns the (optimal!) weights w = [w0, w_1 ... w_D] 
%of the decision boundary using branch and bound method
%with selection strategy to maximize the convex hull
function [w, t0] = getWeightsByBranchAndBound3(X, t)

[N,D] = size(X);
uBounds = 1e4 * ones(1, D-1);   %upper bounds for w 
lBounds = -1e4 * ones(1,D-1);   %lower bounds for w

t0 = 0;
min_loss = N+1;        
w=zeros(D,1);
pred = zeros(N,1);     %prediction vector of current search path

ticId = tic;
bnb(1, pred, 0);


% Branch and Bound functions
% ==========================

    function bnb(i, pred, loss)
        
        if toc(ticId) > 200.0, return; end
        
        if i > N            %all assigned, pred completed  	
            w2 = getBestWeights(pred);
            if w2(1) ~= 0
				min_loss = loss;
				w = w2;
                t0 = toc(ticId);
                fprintf('*** Loss = %d, w=%s, found after %f sec\n', ...
                    min_loss, mat2str(w',3), t0);
            end
        else
            [pred2, loss2] = addPoint(i, t(i), pred, loss); 
            if (loss2 < min_loss)
                bnb(i+1, pred2, loss2);
            end
            [pred2, loss2] = addPoint(i, -t(i), pred, loss); 
            if (loss2 < min_loss)
                bnb(i+1, pred2, loss2);
            end
        end
    end

    function [newpred, newloss] = addPoint(i, val, pred, loss)
        newpred = pred;
        newloss = loss;
        newpred(i) = val;
        if newpred(i) ~= t(i), newloss = newloss + 1; end
        A = X(newpred == val,2:D)';
        
        %if any point of opposite class lie inside this class => infeasible
        for j=1:N
            if newpred(j) == -val && isInteriorPointOfA(X(j,2:D)')
                newloss = N+1;
                return;
            end
        end
        
        %check points unassigned
        for j=1:N
            if newpred(j) == 0 && isInteriorPointOfA(X(j,2:D)')
                newpred(j) = val;
                if newpred(j) ~= t(j), newloss = newloss + 1; end
            end
        end
            
        function res = isInteriorPointOfA(p)
            Np = length(A(1,:));
            lp=mxlpsolve('make_lp', 0, Np);
            mxlpsolve('set_verbose', lp, 0);
            mxlpsolve('set_lowbo', lp, -1e6 * ones(1, Np));
            mxlpsolve('set_upbo', lp, 1e6 * ones(1, Np));
            
            %sum(x) = 1
            mxlpsolve('add_constraint', lp, ones(1, Np) , 'EQ', 1);
            
            %x >= 0
            for k=1:Np
                k1 = zeros(1,Np);
                k1(k) = 1;
                mxlpsolve('add_constraint', lp, k1 , 'GE', 0);
            end
            
            %Ax = p
            for k=1:length(A(:,1))
                mxlpsolve('add_constraint', lp, A(k,:) , 'EQ', p(k));
            end
            
            solvestat = mxlpsolve('solve', lp);
            if solvestat == 0
                res = 1;
            else
                res = 0;
            end
            mxlpsolve('delete_lp', lp);
        end
        
    end

    function bestW = getBestWeights(pred)
        lp=mxlpsolve('make_lp', 0, D-1);
        mxlpsolve('set_verbose', lp, 0);
        mxlpsolve('set_lowbo', lp, lBounds);
        mxlpsolve('set_upbo', lp, uBounds);
        bias = 1.0;
        for i=1:N
            if pred(i) == 1
                mxlpsolve('add_constraint', lp, X(i,2:D) , 'GE', -bias);
            else
                mxlpsolve('add_constraint', lp, -1*X(i,2:D) , 'GE', bias);
            end
        end
		solvestat = mxlpsolve('solve', lp);
        if solvestat == 0
            bestW = mxlpsolve('get_variables', lp);
            bestW = [bias; bestW];
        else
            bestW = 0;
        end
        mxlpsolve('delete_lp', lp);
        
        if bestW == 0
            lp=mxlpsolve('make_lp', 0, D-1);
            mxlpsolve('set_verbose', lp, 0);
            mxlpsolve('set_lowbo', lp, lBounds);
            mxlpsolve('set_upbo', lp, uBounds);
            bias = -1.0;
            for i=1:N
                if pred(i) == 1
                    mxlpsolve('add_constraint', lp, X(i,2:D) , 'GE', -bias);
                else
                    mxlpsolve('add_constraint', lp, -1*X(i,2:D) , 'GE', bias);
                end
            end
            solvestat = mxlpsolve('solve', lp);
            if solvestat == 0
                bestW = mxlpsolve('get_variables', lp);
                bestW = [bias; bestW];
            else
                bestW = 0;
            end
            mxlpsolve('delete_lp', lp);
        end
        
    end


end

