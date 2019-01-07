loadOCTTestData;
BScanHeader = BScanHeaderV;
header = headerV;
NBscans =  size(BScansv,3);
y = zeros(1,XN*NBscans);
x = zeros(1,XN*NBscans);
for j = 1:NBscans
xStart = round(BScanHeader.StartX(j)/header.ScaleXSlo);
yStart = round(BScanHeader.StartY(j)/header.ScaleYSlo);
xEnd = round(BScanHeader.EndX(j)/header.ScaleXSlo);
yEnd = round(BScanHeader.EndY(j)/header.ScaleYSlo);

xInc= (xEnd-xStart)/(XN-1);
yInc= (yEnd-yStart)/(XN-1);

for i = 1:XN
    ii = i+(j-1)*XN;
y(ii) = yStart+yInc*(i-1);
x(ii) = xStart+xInc*(i-1);
end
end

%figure(1)
%plot(x,y,'.','markersize',5)
%figure(2)
tri = delaunay(x,y);
%hold on, triplot(tri,x,y,'LineWidth',.5), hold off
figure(3)
z_in=-vmap_inner(:)';
z_out=-vmap_outer(:)';

trimesh(tri,x,y,z_in)
hold on
trimesh(tri,x,y,z_out)
hold off
view(-87,24)

figure(4)
clf
%DT_3D = delaunayTriangulation(x',y',z');
%DT_2D = delaunayTriangulation(x',y');
%DT_3D = delaunayTriangulation([x' y' z'],DT_2D.ConnectivityList);

TR_in = triangulation(tri,[x' y' z_in']); 
TR_out = triangulation(tri,[x' y' z_out']); 

%Find the free boundary facets of the triangulation, and use them to create a 2-D triangulation on the surface.

%[T,Xb] = freeBoundary(DT);
%TR = triangulation(T,Xb);
%Compute the centers and face normals of each triangular facet in TR.
%TR=tri;
%DT_3D.Points = [DT_3D.Points z'];
P = incenter(TR_out);
F = faceNormal(TR_out);  
%Plot the triangulation along with the centers and face normals.


TN_IN = size(TR_in.ConnectivityList,1);
TN_OUT = size(TR_out.ConnectivityList,1);
thickness_all = zeros(TN_OUT,1);
intersect_all = zeros(TN_OUT,3);
for i = 1:100%TN_OUT 
origin = P(i,:);
direction = F(i,:);

for j = 1:TN_IN
TriVertex = TR_in.Points(TR_in.ConnectivityList(j,:),:);
v0 = TriVertex(1,:);
v1 = TriVertex(2,:);
v2 = TriVertex(3,:);
[flag, u, v, t] = rayTriangleIntersection(origin, direction, v0, v1, v2);

if(flag == 1)
   t; 
   intersection = origin + t*direction;
   thickness_all(i) = t;
   intersect_all(i,:) = intersection;
    break;
end

end
end
%trisurf(T,Xb(:,1),Xb(:,2),Xb(:,3), ...
%     'FaceColor','cyan','FaceAlpha',0.8);
hold on
trimesh(tri,x,y,z_in)
hold on
trimesh(tri,x,y,z_out)
%hold on

	text(origin(1), origin(2), origin(3), 'Origin');
	plot3(origin(1), origin(2), origin(3), 'r.', 'MarkerSize', 15);

	% direction
	quiver3(origin(1), origin(2), origin(3), direction(1), direction(2), direction(3), t, ...
     'color','r','linewidth',.15);

	% intersection 
    text(intersection(1), intersection(2), intersection(3), '  Intersection','Rotation',45);
	plot3(intersection(1), intersection(2), intersection(3), 'r.', 'MarkerSize', 15);
view(-87,24)

figure(5)
hold on
trimesh(tri,x,y,z_in)
hold on
trimesh(tri,x,y,z_out)
N = 100;
line([P(1:N,1) intersect_all(1:N,1)]',[P(1:N,2) intersect_all(1:N,2)]',[P(1:N,3) intersect_all(1:N,3)]', ...
     'color','r','linewidth',.15);
%quiver3(P(:,1),P(:,2),P(:,3), ...
%     F(:,1),F(:,2),F(:,3),thickness_all,'color','r','linewidth',.15);
hold off
view(-87,24)