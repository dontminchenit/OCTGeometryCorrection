%generate3Dmodels
%load data

inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_analysis\OCTExplorerSegmentationData';

AllFiles = subdir(fullfile(inDir,'*Final.mat'));

%[headerV, BScanHeaderV, sloV, BScansV] = openVolFast(fullfile(inDir,'11015_1_21682.vol'));
%BScansV(BScansV>1) = 0;
%BScansV=BScansV.^.25;
saveName = './demo9.gif';
h=figure(1)
clf
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,saveName,'gif', 'DelayTime', 0.2,'Loopcount',1); 

for f = 1:4:60%length(AllFiles)
    AllFiles(f).name
octSurfV = open(AllFiles(f).name);
OCTinV = permute(octSurfV.mask,[1 3 2]);
OCTinV= rot90(OCTinV,1);
OCTEdgesV_inner = zeros(size(OCTinV));
OCTEdgesV_outer = zeros(size(OCTinV));

volName =  [AllFiles(f).name(1:end-30) '.vol']
[headerV, BScanHeaderV, sloV, BScansv] = openVolFast(volName);

%[headerH, BScanHeaderH, sloH, BScansH] = openVolFast(fullfile(inDir,'11015_1_21683.vol'));
%BScansH(BScansH>1) = 0; 
%BScansH=BScansH.^.25;
octSurfH = open(AllFiles(f).name);
OCTinH = permute(octSurfH.mask,[1 3 2]);
OCTinH= rot90(OCTinH,1);
OCTEdgesH_inner = zeros(size(OCTinH));
OCTEdgesH_outer = zeros(size(OCTinH));


%set header information
YN=size(OCTinV,1);
XN=size(OCTinV,2);
ZN=size(OCTinV,3);
%xResV = headerV.ScaleX;
%yResV = headerV.ScaleZ;
%zResV = headerV.Distance;
%xResH = headerH.ScaleX;
%yResH = headerH.ScaleZ;
%zResH = headerH.Distance;

%find the depthmap
vmap_inner = zeros(XN,ZN); 
hmap_inner = zeros(XN,ZN);
vmap_outer = zeros(XN,ZN); 
hmap_outer = zeros(XN,ZN);

for i = 1:XN
    for j = 1:ZN
        vmap_inner(i,j)=min(find(OCTinV(:,i,j)>0));
        hmap_inner(i,j)=min(find(OCTinH(:,i,j)>0));
        vmap_outer(i,j)=max(find(OCTinV(:,i,j)>0));
        hmap_outer(i,j)=max(find(OCTinH(:,i,j)>0));
    end
end

%calculate the distance offset
offset = max(max(vmap_inner)) - max(max(hmap_inner));

%Register slo to initial alignment
%[optimizer, metric] = imregconfig('monomodal');
%[tform] =  imregtform(sloV, sloH, 'rigid', optimizer, metric);

%plotHandVSurfaces

%calculate 3D surface
for i = 1:size(OCTinV,2)
    for j = 1:size(OCTinV,3)
        OCTEdgesV_inner(vmap_inner(i,j),i,j) = 1;
        OCTEdgesH_inner(hmap_inner(i,j),i,j) = 1;
        OCTEdgesV_outer(vmap_outer(i,j),i,j) = 1;
        OCTEdgesH_outer(hmap_outer(i,j),i,j) = 1;

    end
end



Angles = [0 0];
Center = [0 0 0];

ID = str2double(AllFiles(f).name(end-42:end-38))
ind=find(NodalPoints(:,1) == ID);
R = NodalPoints(ind,2)

if(isempty(R))
   R=18; 
end

hold on
[cost,surfPointsX,surfPointsY,surfPointsZ] = OCTGeometryCorrectionCostFunction(OCTEdgesV_inner,Angles,Center,R);
%figure(1)
%plotOCTGeometry(Angles,Center,R)
hold on
scatter3(surfPointsX,surfPointsY,surfPointsZ,3,rand(1,3));
ylim([14 22]);
view(-56,66)
hold on

frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
imwrite(imind,cm,saveName,'gif','DelayTime', 0.2,'WriteMode','append'); 


end

hold off
view(-56,66)


