%Takes a transformation between a Vscan and Hscan and move them into the
%same space.

function [RegisteredVScan,BothMean,BothAbsDiff] = alignHandVscans(VScan,HScan,tform)

        RegisteredVScan = imwarp(VScan,tform,'OutputView',imref2d(size(double(HScan))));
        BothMean = (HScan + RegisteredVScan)/2;
        BothAbsDiff = abs(HScan - RegisteredVScan);

        armsMask = xor(HScan,RegisteredVScan);
        BothAbsDiff(armsMask) = 0;
        BothMean(armsMask) = BothMean(armsMask)*2;
