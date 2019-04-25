function LayerMeanIntensityMaps = findLayerMeanIntensityMaps(boundariesLoc,OrigBScans,LN)

ZN = size(boundariesLoc,1);
XN = size(boundariesLoc,2);

LayerMeanIntensityMaps = zeros(ZN,XN,LN);


for i = 1:ZN
    for j = 1:XN
       for l = 1:LN
            LayerMeanIntensityMaps(i,j,l) = mean(OrigBScans(round(boundariesLoc(i,j,l)):round(boundariesLoc(i,j,l+1)-1),j,i));
       end
    end
end




