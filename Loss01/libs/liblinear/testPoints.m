function testPoints()

    function result = compareOK(X)
        d1 = 0;
        d2 = 0;
        for i=2:length(X(:,1))
            d1 = d1 + norm(X(1,:) - X(i,:));
            if i>2, d2 = d2 + norm(X(i,:) - X(i-1,:)); end
        end
        result = (d1 > d2 +2);
        fprintf('(d1,d2) = %s\n', mat2str([d1,d2],3));
    end

N = 4;
X = random('uniform', 0, 10, N, 2);

while compareOK(X)
    X = random('uniform', 0, 10, N, 2);
end

figure(1);
plot(X(:,1), X(:,2), 'or', X(1,1), X(1,2), 'og');
X

end