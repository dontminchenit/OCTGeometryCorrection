figure(20)
scatter(axialLength,score1(:,1))
lsline
xlabel('Axial Length')
ylabel('PC1 Score')

corr(score1(:,1),axialLength)