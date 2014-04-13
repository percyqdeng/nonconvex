%plot 2D cutting plane of the smooth loss function. 
%params.figId : #figure 
%params.X, params.t : input data 
%params.w, params.w0 : weights w, w0 
%params.smoothness : smoothness coeff. K of loss function; 
%params.axisId : w axis defining the cutting plane
%params.range0 = -60; params.range1 = 10; from w(i)-60 to w(i)+10
%params.step = .1; 
function plotSmoothLoss3D(params)

figure(params.figId);

[W1,W2,Z] = meshSmoothLossGrid(params);
mesh(W1,W2,Z);
hold on;
i0 = int64(floor(length(Z(1,:)) / 2)) + 1;
plot3(W1(i0,i0), W2(i0,i0), Z(i0,i0), 'sk', 'markerfacecolor',[0,0,0]);
view(140,30);
hold off;


end
