data = [1 0; 1/sqrt(2) 1/sqrt(2)]';
show_vs(data)

w = [1;1]/2;
[m,ms,hits] = tbilliard(data, w);
hold on
plot(hits(1,:), hits(2,:))
hold off

