function [ cost ] =  OCTGeometryCorrectionCostFunctionWrapper( OCTEdges,optimizationParams,saveName)


Angles = optimizationParams(1:2);
Center = optimizationParams(3:5);
R = optimizationParams(6);

[cost,surfPointsX,surfPointsY,surfPointsZ] = OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R,saveName);


h=figure(12)
clf
%objCenter = [0 250 0];
%objSideLength =[250 50 300]; 
%objExt = [(objCenter-objSideLength/2);(objCenter+objSideLength/2)];
%plotcube(objSideLength,objExt(1,:),.5,[211/255 211/255 211/255]);
worldExt = [-15 0 -15;15 50 15];
worldLength = [(worldExt(2,1)-worldExt(1,1)) (worldExt(2,2)-worldExt(1,2)) (worldExt(2,3)-worldExt(1,3)) ];
xlim([worldExt(1,1) worldExt(2,1)])
ylim([worldExt(1,2) worldExt(2,2)])
zlim([worldExt(1,3) worldExt(2,3)])
hold on

%draw_plane(0,1,0,-225,'g',0.5,150);

[x,y,z] = ellipsoid(0,0,0,11.541,10.474,11.545,100);
y= y+7.5*ones(size(y));

x(y<7.5) = nan;
z(y<7.5) = nan;
y(y<7.5) = nan;

surf(x,y,z)
plotOCTGeometry(Angles,Center,R)
scatter3(surfPointsX,surfPointsY,surfPointsZ,3,'r');
hold off
view(-56,66)
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append'); 


end

