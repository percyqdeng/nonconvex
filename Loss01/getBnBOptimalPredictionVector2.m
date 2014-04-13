
function [min_pred min_loss T0] = getBnBOptimalPredictionVector2(X, t, timeLimit)

if nargin < 3, timeLimit = 1e9; end

[N,D] = size(X);
uBounds = 1e2 * ones(1, D-1);   %upper bounds for w 
lBounds = -1e2 * ones(1,D-1);   %lower bounds for w

%initialize min_loss to solution given by SVM
T0 = 0;
w = getBestWeightsByLR(X,t);
y = getPredictionVector(X,w);
min_loss = cal01Loss(X,t,w); 
min_pred = y;
loss = 0;                  %loss value of current search path 
pred = zeros(size(t));     %prediction vector of current search path

%initialize index vector id to reference points in descending distance
d = abs(X * w);
[sorted,id] = sort(d,'descend');

ticId = tic;

bnb(1);


% Branch and Bound functions
% ==========================

    function bnb(r)
        
        if toc(ticId) > timeLimit, return; end
        
        if r > N  	
            w2 = getBestWeights(pred);
            if w2(1) ~= 0
				min_loss = loss;
                min_pred = pred;
                w = w2;                
                T0 = toc(ticId);
                %fprintf('*** Loss = %d, w=%s, found after %f sec\n', ...
                %    min_loss, mat2str(w',3), t0);
            end
        else
            
			pred(id(r)) = y(id(r));
            if pred(id(r)) ~= t(id(r)), loss = loss + 1; end
            if (loss < min_loss)
                bnb(r+1);
            end
            if pred(id(r)) ~= t(id(r)), loss = loss - 1; end
            
			pred(id(r)) = -y(id(r));
			if pred(id(r)) ~= t(id(r)), loss = loss + 1; end
            if (loss < min_loss)
				bnb(r+1); 
            end
            if pred(id(r)) ~= t(id(r)), loss = loss - 1; end
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

