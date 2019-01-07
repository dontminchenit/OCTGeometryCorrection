

 optimizationParams=[0 0 0 0 0 18];
 Angles_V = optimizationParams(1:2);
Center_V = optimizationParams(3:5);
R_V = optimizationParams(6);
 
h=figure(10)
clf;
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
saveName='./demo12.gif';
%imwrite(imind,cm,'./temp.gif','gif', 'DelayTime', 0.2,'Loopcount',inf); 
% fixOCTGeometry(BScansV,Angles_V,Center_V,R_V,'./temp.gif');
%imwrite(imind,cm,saveName,'gif', 'DelayTime', 0.2,'Loopcount',inf); 

saveName='./demo11.gif';
[cost_V,surfPointsX_V,surfPointsY_V,surfPointsZ_V] = OCTGeometryCorrectionCostFunction(OCTEdgesV_outer,Angles_V,Center_V,R_V);
clf
plotOCTGeometry(Angles_V,Center_V,R_V)
scatter3(surfPointsX_V,surfPointsY_V,surfPointsZ_V,3,'r');

view(-65,54)
xlim([-8 8]);
ylim([0 45]);
zlim([-5 5]);
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,saveName,'gif', 'DelayTime', 0.2,'Loopcount',inf); 
hold off
for n = [18:-1:10 10:1:28]
 optimizationParams=[0 0 0 0 0 n];
 lb_v=[-10*pi/180 -10*pi/180 0 0 0 15];
 ub_v=[10*pi/180 10*pi/180 15 15 15 28];
 plb_v=[-5*pi/180 -5*pi/180 0 0 0 17];
 pub_v=[5*pi/180 5*pi/180 5 5 5 20];

 
 Angles_V = optimizationParams(1:2);
Center_V = optimizationParams(3:5);
R_V = optimizationParams(6);
 

 %fixOCTGeometry(BScansV,Angles_V,Center_V,R_V,saveName);
 
  [cost_V,surfPointsX_V,surfPointsY_V,surfPointsZ_V] = OCTGeometryCorrectionCostFunction(OCTEdgesV_outer,Angles_V,Center_V,R_V);
clf
  plotOCTGeometry(Angles_V,Center_V,R_V)
scatter3(surfPointsX_V,surfPointsY_V,surfPointsZ_V,3,'r');

view(-65,54)
xlim([-8 8]);
ylim([0 45]);
zlim([-5 5]);
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append'); 
hold off
end
 

 
 