g2 = axialLength > mean(axialLength);
g1 = axialLength < mean(axialLength);

%scatter(axialLength,score1(:,1))


for i = 1:5
figure(i)
    clf
scatter(axialLength(g1),score1(g1,i),'r')
hold on
scatter(axialLength(g2),score1(g2,i),'b')

scatter(mean(axialLength(g1)),mean(score1(g1,i)),'r','filled')
scatter(mean(axialLength(g2)),mean(score1(g2,i)),'b','filled')
quiver(mean(axialLength(g1)),mean(score1(g1,i)),mean(axialLength(g2))-mean(axialLength(g1)),mean(score1(g2,i))-mean(score1(g1,i)),0,'k')

xlabel('axialLength')
ylabel(['PC' num2str(i)])
end

meang1 = mean(score1(g1,1:5))
meang2 = mean(score1(g2,1:5))
meanVec = meang2 - meang1


setDisplayViews

savePath = fullfile(outDir,'axialSweep.gif');
view(-60,10)
startGifRecording(6, savePath);

for q = 0:.05:1
q
    for i = 1:5
currFovea = mu_in+pc_in(:,:,i)*(meang1(i)+q*meanVec(i));
end
surf(X,Z,currFovea)
setDisplayViews
view(-60,10)
appendGifRecording(6, savePath)
end