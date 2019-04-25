function [xyzPointCloudCentered,xyzPointCloud] = OCTtoPointCloud(OCTEdges,OCTRes,foveaLoc)

%find pixe coordinate of surface
[Loc_Y,Loc_X,Loc_Z] = ind2sub(size(OCTEdges),find(OCTEdges(:)>0));

%convert to mm using machine resolution
Loc_Y = Loc_Y*OCTRes(1);
Loc_X = Loc_X*OCTRes(2);
Loc_Z = Loc_Z*OCTRes(3);

%convert into point cloud
xyzPoints= [Loc_X Loc_Y Loc_Z];
xyzPointCloud=pointCloud(xyzPoints);


%Translate so fovea is centered
[foveaLoc_Y,foveaLoc_X,foveaLoc_Z] = ind2sub(size(OCTEdges),foveaLoc);

foveaTrans = -[foveaLoc_Y,foveaLoc_X,foveaLoc_Z].*OCTRes;

Loc_Y = Loc_Y + ones(size(Loc_Y))*foveaTrans(1);
Loc_X = Loc_X + ones(size(Loc_X))*foveaTrans(2);
Loc_Z  = Loc_Z + ones(size(Loc_Z))*foveaTrans(3);

%convert to point cloud
xyzPoints= [Loc_X Loc_Y Loc_Z];
xyzPointCloudCentered=pointCloud(xyzPoints);


