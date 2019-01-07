function [sloBars, mapSLO, isHscan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans,thic_map)
sloBars = slo;
mapSLO = double(slo);
mapSLO(:) = 0;

XN = size(BScans,2);
NBscans = size(BScans,3);

%Check the orientation of the scan
if(BScanHeader.StartX(1) == BScanHeader.EndX(1))
    isHscan = 0;
elseif(BScanHeader.StartY(1) == BScanHeader.EndY(1))
    isHscan = 1;
end

for j = 1:NBscans
        xStart = round(BScanHeader.StartX(j)/header.ScaleXSlo);
        yStart = round(BScanHeader.StartY(j)/header.ScaleYSlo);
        xEnd = round(BScanHeader.EndX(j)/header.ScaleXSlo);
        yEnd = round(BScanHeader.EndY(j)/header.ScaleYSlo);
    
        xInc= round((xEnd-xStart)/XN);
        yInc= round((yEnd-yStart)/XN);
        
    for i=1:XN
        y = yStart+yInc*(i-1)+1;
        x = xStart+xInc*(i-1)+1;
        if(y>=1 && y <= size(slo,1) && x>=1 && x <= size(slo,2))
            sloBars(y,x) = 255;
            if(exist('thic_map','var'))
                mapSLO(y,x) = thic_map(j,i);
            end
        end
    end
    
end