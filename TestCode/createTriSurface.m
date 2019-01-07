function  [xyz,P,F,TR] = createTriSurface(surfPointsX,surfPointsY,surfPointsZ,plotNorm,holdON)

shp=alphaShape(surfPointsX,surfPointsY,surfPointsZ);
figure(1)
if(holdON)
    hold on
end

scatter3(surfPointsX,surfPointsY,surfPointsZ);
if(holdON)
    hold off
end

figure(2)
if(holdON)
    hold on
end

plot(shp,'EdgeColor','none');
light
[tri, xyz] = boundaryFacets(shp);

if(holdON)
    hold off
end


figure(3)
if(holdON)
    hold on
end

trisurf(tri,xyz(:,1),xyz(:,2),xyz(:,3),...
    'FaceColor','cyan','FaceAlpha',0.3) 
axis equal
TR = triangulation(tri, xyz);
P = incenter(TR);
F = faceNormal(TR);  
%Plot the triangulation along with the centers and face normals.

if(holdON)
    hold off
end


if (plotNorm)
hold on  
quiver3(P(:,1),P(:,2),P(:,3), ...
     F(:,1),F(:,2),F(:,3),0.5,'color','r');
hold off
end