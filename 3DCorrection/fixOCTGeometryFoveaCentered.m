function [xyzPointCloudCorrectedCentered,foveaLocCorrectedCentered,NodalLocCentered,xyzPointCloudCorrected,foveaLocCorrected] = fixOCTGeometryFoveaCentered(OCTEdges,Angles,NodalLoc,R,OCTRes,foveaLoc)


[correctedLoc_X, correctedLoc_Y, correctedLoc_Z]=fixOCTGeometry(OCTEdges,Angles,NodalLoc,R,OCTRes,1);
foveaLocCorrected = [correctedLoc_X(foveaLoc) correctedLoc_Y(foveaLoc) correctedLoc_Z(foveaLoc)];
edgeMask = OCTEdges>0;

surfPointsX = correctedLoc_X(edgeMask);
surfPointsY = correctedLoc_Y(edgeMask);
surfPointsZ = correctedLoc_Z(edgeMask);

xyzPoints= [surfPointsX surfPointsY surfPointsZ];
xyzPointCloudCorrected=pointCloud(xyzPoints);


%C=surfFittingCostfunction(surfPointsX,surfPointsY,surfPointsZ);
%C = point_plane_shortest_dist(surfPointsX, surfPointsY, surfPointsZ, 0,1,0,-225);
%C=point_ellipse_shortest_dist(surfPointsX, surfPointsY, surfPointsZ, 11.541,10.474,11.545);
%pause(.5)
cost = 0;%sqrt(mean(C.*C));
%cost=0;

foveaTrans = -foveaLocCorrected;


surfPointsX = surfPointsX + ones(size(surfPointsX))*foveaTrans(1);
surfPointsY = surfPointsY + ones(size(surfPointsY))*foveaTrans(2);
surfPointsZ  = surfPointsZ + ones(size(surfPointsZ))*foveaTrans(3);

foveaLocCorrectedCentered  = foveaLocCorrected + foveaTrans;
NodalLocCentered = NodalLoc + foveaTrans;

xyzPoints= [surfPointsX surfPointsY surfPointsZ];
xyzPointCloudCorrectedCentered=pointCloud(xyzPoints);