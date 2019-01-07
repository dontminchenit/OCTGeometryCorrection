function [cost,surfPointsX,surfPointsY,surfPointsZ,landmarkCorrected] = OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R,landmark)


[correctedLoc_X, correctedLoc_Y, correctedLoc_Z]=fixOCTGeometry(OCTEdges,Angles,Center,R);
landmarkCorrected = [correctedLoc_X(landmark) correctedLoc_Y(landmark) correctedLoc_Z(landmark)];
edgeMask = OCTEdges>0;

surfPointsX = correctedLoc_X(edgeMask);
surfPointsY = correctedLoc_Y(edgeMask);
surfPointsZ = correctedLoc_Z(edgeMask);

%C=surfFittingCostfunction(surfPointsX,surfPointsY,surfPointsZ);
%C = point_plane_shortest_dist(surfPointsX, surfPointsY, surfPointsZ, 0,1,0,-225);
%C=point_ellipse_shortest_dist(surfPointsX, surfPointsY, surfPointsZ, 11.541,10.474,11.545);
%pause(.5)
cost = 0;%sqrt(mean(C.*C));
%cost=0;

