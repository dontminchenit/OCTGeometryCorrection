%function [ cost ] =  OCTGeometryDualCorrectionCostFunctionWrapper(VScan,HScan,optimizationParams)
function [cost, surfPointsX_V, surfPointsY_V,surfPointsZ_V,surfPointsX_H,surfPointsY_H,surfPointsZ_H] =  OCTGeometryDualCorrectionCostFunctionWrapper(OCTEdges_V,OCTEdges_H,optimizationParams,foveaV,foveaH,saveName,saveName2)
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

[cost_V,surfPointsX_V,surfPointsY_V,surfPointsZ_V, foveaVCorrected] = OCTGeometryCorrectionCostFunction(OCTEdges_V,Angles_V,Center_V,R_V,foveaV);
[cost_H,surfPointsX_H,surfPointsY_H,surfPointsZ_H, foveaHCorrected] = OCTGeometryCorrectionCostFunction(OCTEdges_H,Angles_H,Center_H,R_H,foveaH);

%foveaTransH = foveaVCorrected - foveaHCorrected;

foveaTransH = -foveaHCorrected;
foveaTransV = -foveaVCorrected;


surfPointsX_H = surfPointsX_H + ones(size(surfPointsX_H))*foveaTransH(1);
surfPointsY_H = surfPointsY_H + ones(size(surfPointsY_H))*foveaTransH(2);
surfPointsZ_H  = surfPointsZ_H + ones(size(surfPointsZ_H))*foveaTransH(3);
foveaHCorrected  = foveaHCorrected + foveaTransH;

surfPointsX_V = surfPointsX_V + ones(size(surfPointsX_V))*foveaTransV(1);
surfPointsY_V = surfPointsY_V + ones(size(surfPointsY_V))*foveaTransV(2);
surfPointsZ_V  = surfPointsZ_V + ones(size(surfPointsZ_V))*foveaTransV(3);
foveaVCorrected  = foveaVCorrected + foveaTransV;


%foveaVCorr = [surfPointsX_V(foveaV) surfPointsY_V(foveaV) surfPointsZ_V(foveaV)];
%foveaHCorr = [surfPointsX_H(foveaH) surfPointsY_H(foveaH) surfPointsZ_H(foveaH)];

xyzPoints_V= [surfPointsX_V surfPointsY_V surfPointsZ_V];
xyzPoints_H= [surfPointsX_H surfPointsY_H surfPointsZ_H];

pc_V=pointCloud(xyzPoints_V);
pc_H=pointCloud(xyzPoints_H);

upperBound = max(1, round(.5*pc_H.Count));
% Find the correspondence
[indices, dists_H] = knnsearch(pc_V.Location, pc_H.Location);
[indices, dists_V] = knnsearch(pc_H.Location, pc_V.Location);

h=figure(10)
subplot(1,2,1)
imshow(reshape(dists_V,size(OCTEdges_V,2),size(OCTEdges_V,3)));
colorbar
caxis([0 5])
colormap('default')
daspect([.1 1 1])
subplot(1,2,2)
imshow(reshape(dists_H,size(OCTEdges_H,2),size(OCTEdges_H,3))');
colorbar
caxis([0 5])
colormap('default')
daspect([1 .1 1])

    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,saveName2,'gif','DelayTime', 0.2,'WriteMode','append');


% Remove outliers
keepInlierA = false(pc_H.Count, 1);
[~, idx] = sort(dists_H);
keepInlierA(idx(1:upperBound)) = true;
inlierDist = dists_H(keepInlierA);
cost_H =sqrt(sum(inlierDist)/length(inlierDist));

keepInlierA = false(pc_V.Count, 1);
[~, idx] = sort(dists_V);
keepInlierA(idx(1:upperBound)) = true;
inlierDist = dists_V(keepInlierA);
cost_V =sqrt(sum(inlierDist)/length(inlierDist));
cost = cost_H+cost_V;
h=figure(12);
pcshowpair(pc_V,pc_H);
hold on
plot3(foveaVCorrected(1), foveaVCorrected(2), foveaVCorrected(3), 'r.', 'MarkerSize', 15);
plot3(foveaHCorrected(1), foveaHCorrected(2), foveaHCorrected(3), 'b.', 'MarkerSize', 15);
line([foveaVCorrected(1) foveaHCorrected(1)]',[foveaVCorrected(2) foveaHCorrected(2)]',[foveaVCorrected(3) foveaHCorrected(3)]', ...
     'color','r','linewidth',.25);
%   view(-95,10)
   view(50,10)
    xlim([-5 5]);
    ylim([-2 2]);
    zlim([-5 5]);

    daspect([1 .4 1])

    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append');
    
% Res = [0.00387 0.01281 0.06834];
% [correctedLoc_X, correctedLoc_Y, correctedLoc_Z]=fixOCTGeometry(OCTEdges_V,Angles_V,Center_V,R_V);
%
% BBox = zeros(1,6);
% BBox(1) = min(correctedLoc_X(:));
% BBox(2) = max(correctedLoc_X(:));
% BBox(3) = min(correctedLoc_Y(:));
% BBox(4) = max(correctedLoc_Y(:));
% BBox(5) = min(correctedLoc_Z(:));
% BBox(6) = max(correctedLoc_Z(:));
% correctedOCT_V = pointsToVol(correctedLoc_X, correctedLoc_Y, correctedLoc_Z,OCTEdges_V,BBox,Res);


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

