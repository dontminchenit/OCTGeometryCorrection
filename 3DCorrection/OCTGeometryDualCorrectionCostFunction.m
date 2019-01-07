function cost = OCTGeometryDualCorrectionCostFunction(VScan,Angles_V,Center_V,R_V,HScan,Angles_H,Center_H,R_H)
global states;
global itr;


[VScan_correctedLoc_X, VScan_correctedLoc_Y, VScan_correctedLoc_Z]=fixOCTGeometry(VScan,Angles_V,Center_V,R_V);
[HScan_correctedLoc_X, HScan_correctedLoc_Y, HScan_correctedLoc_Z]=fixOCTGeometry(HScan,Angles_H,Center_H,R_H);

h=figure(11)
clf
objCenter = [0 250 0];
objSideLength =[250 50 300]; 
objExt = [(objCenter-objSideLength/2);(objCenter+objSideLength/2)];
%plotcube(objSideLength,objExt(1,:),.5,[211/255 211/255 211/255]);
worldExt = [-150 0 -150;150 350 150];
worldLength = [(worldExt(2,1)-worldExt(1,1)) (worldExt(2,2)-worldExt(1,2)) (worldExt(2,3)-worldExt(1,3)) ];
xlim([worldExt(1,1) worldExt(2,1)])
ylim([worldExt(1,2) worldExt(2,2)])
zlim([worldExt(1,3) worldExt(2,3)])
hold on

featureMask_V = VScan>0;
surfPointsX_V = VScan_correctedLoc_X(featureMask_V);
surfPointsY_V = VScan_correctedLoc_Y(featureMask_V);
surfPointsZ_V = VScan_correctedLoc_Z(featureMask_V);
plotOCTGeometry(Angles_V,Center_V,R_V)
scatter3(surfPointsX_V,surfPointsY_V,surfPointsZ_V,3,'r');

featureMask_H = HScan>0;
surfPointsX_H = HScan_correctedLoc_X(featureMask_H);
surfPointsY_H = HScan_correctedLoc_Y(featureMask_H);
surfPointsZ_H = HScan_correctedLoc_Z(featureMask_H);
plotOCTGeometry(Angles_H,Center_H,R_H)
scatter3(surfPointsX_H,surfPointsY_H,surfPointsZ_H,3,'g');


view(-59,24)

%C=surfFittingCostfunction(surfPointsX,surfPointsY,surfPointsZ);
%C = point_plane_shortest_dist(surfPointsX, surfPointsY, surfPointsZ, 0,1,0,-225);
%C=point_ellipse_shortest_dist(surfPointsX_V, surfPointsY_V, surfPointsZ_V, 300, 225, 300);
[correspondance, ind1, ind2] = intersect(VScan(:),HScan(:));
C_X = VScan_correctedLoc_X(ind1)-HScan_correctedLoc_X(ind2);
C_Y = VScan_correctedLoc_Y(ind1)-HScan_correctedLoc_Y(ind2);
C_Z = VScan_correctedLoc_Z(ind1)-HScan_correctedLoc_Z(ind2);
C=[C_X;C_Y;C_Z];
%pause(.5)
cost = sqrt(mean(C.*C));

      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,'./demo2.gif','gif','DelayTime', 0.2,'WriteMode','append'); 
      


%itr = itr+1;
%states(itr,1) = R;
%states(itr,2) = cost;
%states(itr,3) = Center(2);
