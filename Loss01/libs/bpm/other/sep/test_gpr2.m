n = 6;
if 0
x = rand(1,n);
y = rand(1,n);
end
r = 0:0.01:1;

%[x,i] = sort(x);
i = randperm(n);
x = x(i);
y = y(i);

x1 = x(1:3);
y1 = y(1:3);
x2 = x(4:6);
y2 = y(4:6);
b = 100;
[m1,v1] = gpr(x1,y1,r,b);
[m2,v2] = gpr(x2,y2,r,b);
w = v2./(v1+v2);
m = w.*m1 + (1-w).*m2;

plot(x, y, 'o', r, m, '-')
if 1
  drawnow
  axis manual
  hold on
  [mf,vf] = gpr(x,y,r,b);
  plot(r, mf, '--')
  hold off
end
axis([0 1 -0.5 1.5])
if 0
  c = get(gca,'children');
  for i = c
    set(i,'linewidth',1)
  end
end
set(gca,'xtick',[],'ytick',[])
set(gcf,'Paperpos',[0.25 2.5 4 2])
print -dpng gpr2.png
