function [W1,W2,Z] = mesh01LossGrid(params)

M = int64(2*params.range1 / params.step + 1);
W1 = zeros(M,M);
W2 = zeros(M,M);
Z = zeros(M,M);
for i=1:M
    W1(i,:) = params.w(2)-params.range1:params.step:params.w(2)+params.range1;
    W2(:,i) = params.w(3)-params.range1:params.step:params.w(3)+params.range1;
    for j=1:M
        wt = params.w;
        wt(2) = W1(1,i);
        wt(3) = W2(j,1);
        Z(i,j)=cal01Loss(params.X, params.t, wt);
    end
end


end
