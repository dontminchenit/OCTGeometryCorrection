function out=interpolateEnface(im)

[yi,xi,V] = find(im);

dy=1:size(im,1);
dx=1:size(im,2);

[X, Y] = meshgrid(dx,dy);


out = griddata(xi,yi,V,X,Y);
out(isnan(out)) = 0; 
end