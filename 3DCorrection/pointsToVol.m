function Vq = pointsToVol(X,Y,Z,V,BBox,Res)

XRange = BBox(1):Res(1):BBox(2);
YRange = BBox(3):Res(2):BBox(4);
ZRange = BBox(5):Res(3):BBox(6);

[Xq,Yq,Zq] = meshgrid(XRange,YRange,ZRange);
F=scatteredInterpolant(X(:),Y(:),Z(:),V(:));
Vq=F(Xq,Yq,Zq);
%Vq = griddata(X,Y,Z,V,Xq,Yq,Zq);


