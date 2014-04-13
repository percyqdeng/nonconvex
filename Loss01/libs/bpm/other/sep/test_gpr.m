n = 4;
x = rand(1,n);
y = rand(1,n);
r = 0:0.01:1;

% compute interpolant
b = 20;
[m,v] = gpr(x,y,r,b);
s = sqrt(v);

plot(x, y, 'o', r, m, '-', r, m+s, '--', r, m-s, '--')
set(gca,'xtick',[],'ytick',[])
set(gcf,'Paperpos',[0.25 2.5 4 2])
print -dpng gpr.png
