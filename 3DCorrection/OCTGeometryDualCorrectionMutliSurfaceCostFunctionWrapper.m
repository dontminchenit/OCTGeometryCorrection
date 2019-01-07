%function [ cost ] =  OCTGeometryDualCorrectionCostFunctionWrapper(VScan,HScan,optimizationParams)
function [cost] =  OCTGeometryDualCorrectionMutliSurfaceCostFunctionWrapper(OCTEdges_V_in,OCTEdges_H_in,OCTEdges_V_out,OCTEdges_H_out,optimizationParams,foveaV,foveaH,saveName,saveName2)
global states;
global itr;

% Angles_V = optimizationParams(1:2);
% Center_V = optimizationParams(3:5);
% R_V = optimizationParams(6);
% 
% Angles_H = optimizationParams(7:8);
% Center_H = optimizationParams(9:11);
% R_H = optimizationParams(12);


Angles_V = optimizationParams(1:2);
Center_V = [0 0 0];
R_V = optimizationParams(3);

Angles_H = optimizationParams(4:5);
Center_H = [0 0 0];
R_H = optimizationParams(6);


%cost = OCTGeometryDualCorrectionCostFunction(VScan,Angles_V,Center_V,R_V,HScan,Angles_H,Center_H,R_H);


[xyzPointCloud_V_in,foveaLocCorrected_V] = fixOCTGeometryFoveaCentered(OCTEdges_V_in,Angles_V,Center_V,R_V,foveaV);
[xyzPointCloud_H_in,foveaLocCorrected_H] = fixOCTGeometryFoveaCentered(OCTEdges_H_in,Angles_H,Center_H,R_H,foveaH);
[cost_V_in, dists_V_in] = pointCloudCompareCost(xyzPointCloud_V_in,xyzPointCloud_H_in);
[cost_H_in, dists_H_in] = pointCloudCompareCost(xyzPointCloud_H_in,xyzPointCloud_V_in);
cost = cost_H_in+cost_V_in;


[xyzPointCloud_V_out,foveaLocCorrected_out] = fixOCTGeometryFoveaCentered(OCTEdges_V_out,Angles_V,Center_V,R_V,foveaV);
[xyzPointCloud_H_out,foveaLocCorrected_out] = fixOCTGeometryFoveaCentered(OCTEdges_H_out,Angles_H,Center_H,R_H,foveaH);
[cost_V_out, dists_V_out] = pointCloudCompareCost(xyzPointCloud_V_out,xyzPointCloud_H_out);
[cost_H_out, dists_H_out] = pointCloudCompareCost(xyzPointCloud_H_out,xyzPointCloud_V_out);
cost = cost_H_in+cost_V_in + cost_H_out+cost_V_out;

h=figure(10)
subplot(2,2,1)
imshow(reshape(dists_V_in,size(OCTEdges_V_in,2),size(OCTEdges_V_in,3)));
colorbar
caxis([0 1])
colormap('default')
daspect([.1 1 1])
subplot(2,2,2)
imshow(reshape(dists_H_in,size(OCTEdges_H_in,2),size(OCTEdges_H_in,3))');
colorbar
caxis([0 1])
colormap('default')
daspect([1 .1 1])
subplot(2,2,3)
imshow(reshape(dists_V_out,size(OCTEdges_V_out,2),size(OCTEdges_V_out,3)));
colorbar
caxis([0 1])
colormap('default')
daspect([.1 1 1])
subplot(2,2,4)
imshow(reshape(dists_H_out,size(OCTEdges_H_out,2),size(OCTEdges_H_out,3))');
colorbar
caxis([0 1])
colormap('default')
daspect([1 .1 1])


frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,saveName2,'gif','DelayTime', 0.2,'WriteMode','append');




h=figure(12);
clf
%subplot(1,3,1)
pcshowpair(xyzPointCloud_V_in,xyzPointCloud_H_in);
hold on
pcshowpair(xyzPointCloud_V_out,xyzPointCloud_H_out);

plot3(foveaLocCorrected_V(1), foveaLocCorrected_V(2), foveaLocCorrected_V(3), 'r.', 'MarkerSize', 15);
plot3(foveaLocCorrected_H(1), foveaLocCorrected_H(2), foveaLocCorrected_H(3), 'b.', 'MarkerSize', 15);
line([foveaLocCorrected_V(1) foveaLocCorrected_H(1)]',[foveaLocCorrected_V(2) foveaLocCorrected_H(2)]',[foveaLocCorrected_V(3) foveaLocCorrected_H(3)]', ...
     'color','r','linewidth',.25);
%   view(90,-10)
   view(25,20)
    xlim([-5 5]);
    ylim([-2 2]);
    zlim([-5 5]);
    daspect([1 .4 1])
% subplot(1,3,2)
% pcshowpair(xyzPointCloud_V_in,xyzPointCloud_H_in);
% hold on
% pcshowpair(xyzPointCloud_V_out,xyzPointCloud_H_out);
% 
% plot3(foveaLocCorrected_V(1), foveaLocCorrected_V(2), foveaLocCorrected_V(3), 'r.', 'MarkerSize', 15);
% plot3(foveaLocCorrected_H(1), foveaLocCorrected_H(2), foveaLocCorrected_H(3), 'b.', 'MarkerSize', 15);
% line([foveaLocCorrected_V(1) foveaLocCorrected_H(1)]',[foveaLocCorrected_V(2) foveaLocCorrected_H(2)]',[foveaLocCorrected_V(3) foveaLocCorrected_H(3)]', ...
%      'color','r','linewidth',.25);
%    view(90,90)
%     xlim([-5 5]);
%     ylim([-2 2]);
%     zlim([-5 5]);
%     daspect([1 .4 1])    
% subplot(1,3,3)
% pcshowpair(xyzPointCloud_V_in,xyzPointCloud_H_in);
% hold on
% pcshowpair(xyzPointCloud_V_out,xyzPointCloud_H_out);
% 
% plot3(foveaLocCorrected_V(1), foveaLocCorrected_V(2), foveaLocCorrected_V(3), 'r.', 'MarkerSize', 15);
% plot3(foveaLocCorrected_H(1), foveaLocCorrected_H(2), foveaLocCorrected_H(3), 'b.', 'MarkerSize', 15);
% line([foveaLocCorrected_V(1) foveaLocCorrected_H(1)]',[foveaLocCorrected_V(2) foveaLocCorrected_H(2)]',[foveaLocCorrected_V(3) foveaLocCorrected_H(3)]', ...
%      'color','r','linewidth',.25);
% %   view(-95,10)
%    view(0,90)
%     xlim([-5 5]);
%     ylim([-2 2]);
%     zlim([-5 5]);
%     daspect([1 .4 1])    
%     
    
    
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append');
hold off    
plotOn = 0;
if(plotOn)
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
    
    plotOCTGeometry(Angles_V,Center_V,R_V)
    scatter3(surfPointsX_V,surfPointsY_V,surfPointsZ_V,3,'r');
    
    plotOCTGeometry(Angles_H,Center_H,R_H)
    scatter3(surfPointsX_H,surfPointsY_H,surfPointsZ_H,3,'b');
    
    view(-56,66)
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append');
    
    surf(x,y,z)
    
    view(-56,66)
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,saveName2,'gif','DelayTime', 0.2,'WriteMode','append');
    
    
    hold off
end
itr = itr+1;
states(itr,1) = R_V;
states(itr,2) = cost;
%states(itr,3) = Center(2);
end

