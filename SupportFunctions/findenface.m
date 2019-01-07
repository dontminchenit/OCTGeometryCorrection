function enface =findenface(BScans,bnd1,bnd2)

BScans(BScans>1) = 0;
BScans = BScans.^.25;

XN =size(BScans,1);
YN =size(BScans,2);
ZN =size(BScans,3);
enface = zeros(size(bnd1));
avgBscanInt = zeros(ZN,1);%keep record of Bscan intensity for normalization
counter = zeros(ZN,1);
for k = 1:ZN
    for j = 1:YN
        for i = 1:XN
        if(BScans(i,j,k) > 0)
        avgBscanInt(k) = avgBscanInt(k) + BScans(i,j,k);
        counter(k) = counter(k) + 1;
        end
        end
        enface(j,k) =  min(BScans(ceil(bnd2(j,k)):ceil(bnd1(j,k)),j,k));
    end
end

%Normalize

for k = 1:ZN
    enface(:,k) = enface(:,k)./(avgBscanInt(k)/counter(k));
   
end


end