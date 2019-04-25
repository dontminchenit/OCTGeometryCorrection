function [pcOut, tform, modelReorient] = rotateFoveaPlane(pcIn)

%model = pcfitplane(pcIn,.1)

%find 
%bndMax =max([pcIn.Location(:,1),pcIn.Location(:,3),pcIn.Location(:,2)]);
%bndMin =min([pcIn.Location(:,1),pcIn.Location(:,3),pcIn.Location(:,2)]);

%find points just on the edges of the z plane

w = .1;
%edge1roi = [bndMax(1)-w,bndMax(1)+w;0,inf;0,inf];
%edge2roi = [bndMax(2)-w,bndMax(2)+w;0,inf;0,inf];
%edge3roi = [0,inf; bndMax(3)-w,bndMax(3)+w;0,inf];
%edge4roi = [0,inf; bndMax(4)-w,bndMax(4)+w;0,inf];

w_m=1
w_p=.95
edge1roi = [w_p,w_m;-inf,inf;-1,1];
edge2roi = [-w_m,-w_p;-inf,inf;-1,1];
edge3roi = [-1,1;-inf,inf;w_p,w_m];
edge4roi = [-1,1;-inf,inf;-w_m,-w_p;];

% edge1pc = select(currPt,findPointsInROI(currPt,edge1roi));
% edge2pc = select(currPt,findPointsInROI(currPt,edge2roi));
% edge3pc = select(currPt,findPointsInROI(currPt,edge3roi));
% edge4pc = select(currPt,findPointsInROI(currPt,edge4roi));

edge1pc = findPointsInROI(pcIn,edge1roi);
edge2pc = findPointsInROI(pcIn,edge2roi);
edge3pc = findPointsInROI(pcIn,edge3roi);
edge4pc = findPointsInROI(pcIn,edge4roi);


%pcedgeAll = pcmerge(pcmerge(edge1pc,edge2pc,1),pcmerge(edge3pc,edge4pc,1),.0011);

% pcshow(currPt.Location,'r');
 %hold on;
 %pcshow([pcedgeAll.Location(1),pcedgeAll.Location(3),pcedgeAll.Location(2)],'g');
 model = pcfitplane(pcIn,.05,'MaxNumTrials',10000,'SampleIndices',[edge1pc;edge2pc;edge3pc;edge4pc]);

 r1 = vrrotvec([0 -1 0],model.Normal);
 r2 = vrrotvec([0 1 0],model.Normal);

 if(abs(r1(4)) < abs(r2(4)))
     r = r1;
 else
     r = r2;
 end
 
 m = vrrotvec2mat(r);
 
 tform = affine3d([[m [0 0 0]'];[0 0 0 1]]);
pcOut = pctransform(pcIn,tform);
 
%  hold on 
 modelReorient = planeModel([model.Parameters(1) model.Parameters(3) model.Parameters(2) model.Parameters(4)]);
% plot(modelReorient);
%model
% pcshow(edge1pc.Location,'g');
% pcshow(edge2pc.Location,'g');
% pcshow(edge3pc.Location,'g');
% pcshow(edge4pc.Location,'g');