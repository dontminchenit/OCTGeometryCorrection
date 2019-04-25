function f_cen = foveaFinder(thicknessMap,scale)

if all(scale < 1)
    scale = scale*1000;
end
scaleY = scale(1);
scaleX = scale(2);

% Retina thickness
th = thicknessMap;

% Only look in the center part of the volume
cr = round([0.35 0.65]*size(th,2));
cr2 = round([0.35 0.65]*size(th,1));
thi = th(cr2(1):cr2(2),cr(1):cr(2));

% Minimum thickness average in 0.3 mm radius circle
r = 300;
nx = ceil(r/scaleX); ny = ceil(r/scaleY);
py = (-ny:ny)*scaleY; px = (-nx:nx)*scaleX;    
[X,Y] = meshgrid(px,py);
R = sqrt(X.^2+Y.^2);
m = R < r;
thi = imfilter(thi,double(m)/sum(m(:)),'replicate');

[~,ptm] = min(thi(:));
[ptm1, ptm2] = ind2sub(size(thi),ptm);

% Fovea center (adding back the crop) (x-coord, y-coord)
f_cen = [ptm1 + cr2(1)-1, ptm2 + cr(1)-1];