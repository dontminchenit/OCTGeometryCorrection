currPc_in = allSurfacesOrig_in{2};
%currPc_in = allSurfacesCorrected_in{2};


[X,Z] = meshgrid(x,z);
Y_in = griddata(currPc_in.Location(:,1),currPc_in.Location(:,3),currPc_in.Location(:,2),X,Z);

figure(30)
surf(X,Z,Y_in)
   hold on 
   
   x=-4:.1:4;
z=-4:.1:4;
   xlim([-4 4]);
    ylim([-4 4]);
    zlim([-2 .5]);
        view(-55,20)
    ax = gca;
    ax.ZDir = 'reverse';
ax.DataAspectRatio = [1 1 1]