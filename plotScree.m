function wss = plotScree(X, n)

wss = zeros(1, n);
wss(1) = (size(X, 1)-1) * sum(var(X, [], 1));
for i=2:n
    T = clusterdata(X,'maxclust',i);
    wss(i) = sum((grpstats(T, T, 'numel')-1) .* sum(grpstats(X, T, 'var'), 2));
end
hold on
plot(wss)
plot(wss, '.')
xlabel('Number of clusters')
ylabel('Within-cluster sum-of-squares')