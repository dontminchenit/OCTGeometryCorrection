function boundaries = findBoundariesFromSeg(segVol)

YN =size(segVol,1);
XN =size(segVol,2);
ZN =size(segVol,3);

labels = unique(segVol(:));
LN = length(labels);
boundaries = zeros(ZN,XN,LN);


for i = 1:XN
    for j = 1:ZN
        ascan = squeeze(segVol(:,i,j));
        maxAscan = max(ascan(:));
        locEnd = find(ascan==maxAscan,1,'last')+1;
        ascan(locEnd:end)=maxAscan+1;
        lastValidLabel = 1;
        for l = 2:LN %we skip the zero label
            loc = find(ascan==labels(l),1,'first');
            if (~isempty(loc))
                lastValidLabel=l;
            else
                loc = find(ascan==labels(lastValidLabel),1,'last')+1;
            end
                boundaries(j,i,l-1) = loc;
        end
            boundaries(j,i,LN) =  find(ascan==labels(lastValidLabel),1,'last')+1;
    end
end
