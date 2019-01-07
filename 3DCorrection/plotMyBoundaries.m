h=figure(11);
clf
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
saveName = './demo5.gif';
imwrite(imind,cm,saveName,'gif', 'DelayTime', 0.75,'Loopcount',1); 
      


for n = 1:12
    
    currSurf = myBoundaries{n};
    
    [X_V,Z_V] = meshgridOCT(header,BScanHeader);
    
    vmap=currSurf*header.ScaleZ;
    
h=figure(11)
mesh(X_V,Z_V,vmap(:,:,1),'edgecolor', [rand(1) rand(1) rand(1)])
set(gca, 'ZDir','reverse')

az=-140;
el=40;
view(az,el)
%colormap(spring)
colormap([1 0 0;0 0 1]) %red and blue
ylim([0 10])
xlim([0 10])
zlim([0 1])
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
    imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append');
hold on
    
end