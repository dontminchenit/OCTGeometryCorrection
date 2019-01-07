vscan = modelPerspective3D(75,30,0,50,0,0,0);%centered Camera

%modelPerspective3D(75,30,10,50,0,0,45*pi/180);%centered Camera y=45

hscan = modelPerspective3D(75,30,0,50,0,0,90*pi/180);%centered Camera y=90

%modelPerspective3D(75,30,10,50,0,10*pi/180,0);%centered x-tilt Camera

%modelPerspective3D(65,30,-20,50,0,10*pi/180,10*pi/180);%centered x-tilt Camera
YN=size(vscan,1);
XN=size(vscan,2);
ZN=size(vscan,3);
vmap = zeros(XN,ZN); 
hmap = zeros(XN,ZN);
for i = 1:XN
    for j = 1:ZN
        vmap(i,j)=min(find(vscan(:,i,j)>0));
        hmap(i,j)=min(find(hscan(:,i,j)>0));
    end
end


[correspondance, ind1, ind2] = intersect(vscan(:),hscan(:));
vscanFeatures = zeros(YN,XN,ZN);
hscanFeatures = zeros(YN,XN,ZN);

vscanFeatures(ind1) = correspondance;
hscanFeatures(ind2) = correspondance;

figure(5)
imagesc(vmap)
figure(6)
imagesc(hmap)