function svcplot(X,Y,ker,alpha,bias,aspect,mag,xaxis,yaxis,input)
%SVCPLOT Support Vector Machine Plotting routine
%
%  Usage: svcplot(X,Y,ker,alpha,bias,zoom,xaxis,yaxis,input)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - kernel function
%              alpha  - Lagrange Multipliers
%              bias   - Bias term 
%              aspect - Aspect Ratio (default: 0 (fixed), 1 (variable))
%              mag    - display magnification 
%              xaxis  - xaxis input (default: 1) 
%              yaxis  - yaxis input (default: 2)
%              input  - vector of input values (default: zeros(no_of_inputs))
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk)

  if (nargin < 5 | nargin > 10) % check correct number of arguments
    help svcplot
  else

    epsilon = 1e-5;  
    if (nargin < 10) input = zeros(1,size(X,2));, end
    if (nargin < 9) yaxis = 2;, end
    if (nargin < 8) xaxis = 1;, end
    if (nargin < 7) mag = 0.1;, end
    if (nargin < 6) aspect = 0;, end
    
    % Scale the axes
    xmin = min(X(:,xaxis));, xmax = max(X(:,xaxis)); 
    ymin = min(X(:,yaxis));, ymax = max(X(:,yaxis)); 
    xa = (xmax - xmin);, ya = (ymax - ymin);
    if (~aspect)
       if (0.75*abs(xa) < abs(ya)) 
          offadd = 0.5*(ya*4/3 - xa);, 
          xmin = xmin - offadd - mag*0.5*ya;, xmax = xmax + offadd + mag*0.5*ya;
          ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
       else
          offadd = 0.5*(xa*3/4 - ya);, 
          xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
          ymin = ymin - offadd - mag*0.5*xa;, ymax = ymax + offadd + mag*0.5*xa;
       end
    else
       xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
       ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
    end
    
    set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);  

    % Plot function value

    [x,y] = meshgrid(xmin:(xmax-xmin)/50:xmax,ymin:(ymax-ymin)/50:ymax); 
    if 1
      Xt = [x(:) y(:)];
      K = svkernelmtx(ker,Xt,X);
      z = K*diag(Y)*alpha + bias;
      z = reshape(z,size(x));
    end
    if 1
      % tpminka: is this really necessary?
      l = (-min(min(z)) + max(max(z)))/2.0;
      sp = pcolor(x,y,z);
      shading interp  
      set(sp,'LineStyle','none');
      set(gca,'Clim',[-l  l],'Position',[0 0 1 1])
      axis off
      load cmap
      colormap(colmap)
      hold on
    end
  
    % Plot Training points
    i1 = find(Y == 1);
    i0 = find(Y == -1);
    plot(X(i1,xaxis), X(i1,yaxis), 'b+','LineWidth',4) % Class A
    hold on
    plot(X(i0,xaxis), X(i0,yaxis), 'r+','LineWidth',4) % Class B
    sv = find(abs(alpha) > epsilon);
    plot(X(sv,xaxis),X(sv,yaxis),'wo') % Support Vector

    % Plot Boundary contour

    hold on
    contour(x,y,z,[0 0],'w')
    contour(x,y,z,[-1 -1],'w:')
    contour(x,y,z,[1 1],'w:')
    hold off

  end    
