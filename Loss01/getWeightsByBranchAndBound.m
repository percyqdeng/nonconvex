%returns the (optimal!) weights w = [w0, w_1 ... w_D] 
%of the decision boundary using branch and bound method
%with option to use heuristic
function w = getWeightsByBranchAndBound(X, t)

[N,D] = size(X);
uBounds = 1e4 * ones(1, D-1);   %upper bounds for w 
lBounds = -1e4 * ones(1,D-1);   %lower bounds for w

%initialize min_loss to solution given by SVM
w = getWeightsByLinearSVM(X,t);
min_loss = cal01Loss(X,t,w);        
loss = 0;                   %loss value of current search path 
pred = zeros(size(t));     %prediction vector of current search path

%initialize index vector id to reference points in descending distance
d = abs(X * w);
[sorted,id] = sort(d,'descend');

min_loss = 10000;

bnb(1);


% Branch and Bound functions
% ==========================

    function bnb(r)
        if r > N  	
            w2 = getBestWeights(pred);
            if w2(1) ~= 0
				min_loss = loss;
				w = w2;
            end
        else
			pred(id(r)) = t(id(r));
            bnb(r+1);
			
			pred(id(r)) = -t(id(r));
			loss = loss + 1; 
            if (loss < min_loss)
				bnb(r+1); 
            end
			loss = loss -1; 
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

