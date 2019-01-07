function [X,Z] = meshgridOCT(header,BScanHeader)

XN =  header.SizeX; %Ascan Index within each Bscan
ZN = header.NumBScans; %Bscans Index

X = zeros(XN,ZN);
Z = zeros(XN,ZN);

for j = 1:ZN

xStart = BScanHeader.StartX(j);
zStart = BScanHeader.StartY(j);
xEnd = BScanHeader.EndX(j);
zEnd = BScanHeader.EndY(j);

xInc= (xEnd-xStart)/double(XN-1);
zInc= (zEnd-zStart)/double(XN-1);

    for i = 1:XN
        X(i,j)=xStart + xInc*double(i-1);
        Z(i,j)=zStart + zInc*double(i-1);
    end
end
 