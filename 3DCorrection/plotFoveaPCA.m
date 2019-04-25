figure(10)
clf
title('All ILM Surf')
savePath = fullfile(outDir,'allData_view1.gif');
savePath2 = fullfile(outDir,'allData_view2.gif');

setDisplayViews

view(-60,10)
startGifRecording(10, savePath);
view(120,0);
startGifRecording(10, savePath2);

N = size(Y_All,1);
for n = 1:N
    im_in = reshape(Y_All(n,1:length(X(:))),size(X));
%    im_out = reshape(Y_All(n,length(X(:))+1:end),size(X));

    hold on
    surf(X,Z,im_in)
%    hold on
%    surf(X,Z,im_out)
    
    title('All ILM Surf')
    setDisplayViews
    view(-60,10)
    appendGifRecording(10, savePath)
    view(120,0);
    appendGifRecording(10, savePath2);
end



fig=figure(1)
bar(100*latent/sum(latent))
xlabel('PCs')
ylabel('% Variance Explained by PC')
ylim([0 100])
saveas(fig,fullfile(outDir,'percentVar.png'))

figure(2)
bar(100*cumsum(latent)/sum(latent))
xlabel('PCs')
ylabel('Cumulative % Variance Explained by PC')

P = size(coeff1,2);
pc_in = zeros(size(X,1),size(X,2),P);
pc_out = zeros(size(X,1),size(X,2),P);

mu_in = reshape(mu1(1:length(X(:))),size(X));
%mu_out = reshape(mu1(length(X(:))+1:end),size(X));



for p = 1:P
    pc_in(:,:,p) = reshape(coeff1(1:length(X(:)),p),size(X));
  %  pc_out(:,:,p) = reshape(coeff1(length(X(:))+1:end,p),size(X));

end

figure(3)
surf(X,Z,mu_in)
%hold on
%surf(X,Z,mu_out)
setDisplayViews
view(-60,10)
title('Mean Shape')

for p = 1:5
figure(4+p)
surf(X,Z,pc_in(:,:,p))
%hold on
%surf(X,Z,pc_out(:,:,p))
setDisplayViews
view(-60,10)
title(['PC' num2str(p)])


figure(4)
clf
surf(X,Z,mu_in)
%hold on
%surf(X,Z,mu_out)
title('Mean')
savePath1 = fullfile(outDir,['pcsweep' num2str(p) 'view1.gif']);
savePath2 = fullfile(outDir,['pcsweep' num2str(p) 'view2.gif']);
setDisplayViews
view(-60,10)
startGifRecording(4, savePath1);
view(120,0);
startGifRecording(4, savePath2);

stillshotRange = [-2 -1 0 1 2];

for q_pct = [0:.1:2, 2:-.1:-2, -2:.1:-.1]
q= double(q_pct)*sqrt(latent(p));
fig = figure(4)
clf
surf(X,Z,mu_in+q*pc_in(:,:,p))
%hold on
%surf(X,Z,mu_out+q*pc_out(:,:,p))
title(['Mean +' num2str(q_pct) '*Sigma*PC' num2str(p)])
setDisplayViews
view(-60,10)
appendGifRecording(4, savePath1)
view(120,0);
appendGifRecording(4, savePath2)

ind = find(q_pct==stillshotRange);
if(ind)
fig = figure(4)
savePath3 = fullfile(outDir,['pcstillsweep' num2str(p) '_' num2str(ind) 'view1.png']);
view(-60,10)
saveas(fig,savePath3)
savePath3 = fullfile(outDir,['pcstillsweep' num2str(p) '_' num2str(ind) 'view2.png']);
view(120,0);
saveas(fig,savePath3)
fig = figure(15)
subplot(1,5,ind)
surf(X,Z,mu_in+q*pc_in(:,:,p))
setDisplayViews
view(-60,10)
end
end
savePath3 = fullfile(outDir,['pcstillsweep' num2str(p) '_all.png']);
fig = figure(15)
saveas(fig,savePath3)

end