function [sloBars, mapSLO] = OCTBarsOnSLO(slo,header,BScanHeader,BScans,thic_map)
sloBars = slo;
mapSLO = slo;
mapSLO(:) = 0;

XN = size(BScans,2);
NBscans = size(BScans,3);

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
                mapSLO(y,x) = thic_map(i,j);
            end
        end
    end
    
end