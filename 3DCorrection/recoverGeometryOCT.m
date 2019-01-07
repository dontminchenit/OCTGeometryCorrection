%generate3Dmodels
%load data
% inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_analysis\OCTExplorerSegmentationData\11015\OD';
% [headerV, BScanHeaderV, sloV, BScansV] = openVolFast(fullfile(inDir,'11015_1_21682.vol'));
% BScansV(BScansV>1) = 0;
% BScansV=BScansV.^.25;
% octSurfV = open(fullfile(inDir,'11015_1_21682_Surfaces_Retina-JEI-Final.mat'));
% OCTinV = permute(octSurfV.mask,[1 3 2]);
% OCTinV= rot90(OCTinV,1);
% OCTEdgesV_inner = zeros(size(OCTinV));
% OCTEdgesV_outer = zeros(size(OCTinV));
% 
% 
% [headerH, BScanHeaderH, sloH, BScansH] = openVolFast(fullfile(inDir,'11015_1_21683.vol'));
% BScansH(BScansH>1) = 0; 
% BScansH=BScansH.^.25;
% octSurfH = open(fullfile(inDir,'11015_1_21683_Surfaces_Retina-JEI-Final.mat'));
% OCTinH = permute(octSurfH.mask,[1 3 2]);
% OCTinH= rot90(OCTinH,1);
% OCTEdgesH_inner = zeros(size(OCTinH));
% OCTEdgesH_outer = zeros(size(OCTinH));
% 
% 
% %set header information
% YN=size(OCTinV,1);
% XN=size(OCTinV,2);
% ZN=size(OCTinV,3);
% xResV = headerV.ScaleX;
% yResV = headerV.ScaleZ;
% zResV = headerV.Distance;
% xResH = headerH.ScaleX;
% yResH = headerH.ScaleZ;
% zResH = headerH.Distance;
% 
% %find the depthmap
% vmap_inner = zeros(XN,ZN); 
% hmap_inner = zeros(XN,ZN);
% vmap_outer = zeros(XN,ZN); 
% hmap_outer = zeros(XN,ZN);
% 
% for i = 1:XN
%     for j = 1:ZN
%         vmap_inner(i,j)=min(find(OCTinV(:,i,j)>0));
%         hmap_inner(i,j)=min(find(OCTinH(:,i,j)>0));
%         vmap_outer(i,j)=max(find(OCTinV(:,i,j)>0));
%         hmap_outer(i,j)=max(find(OCTinH(:,i,j)>0));
%     end
% end
% 
% %calculate the distance offset
% offset = max(max(vmap_inner)) - max(max(hmap_inner));
% 
% %Register slo to initial alignment
% %[optimizer, metric] = imregconfig('monomodal');
% %[tform] =  imregtform(sloV, sloH, 'rigid', optimizer, metric);
% 
% plotHandVSurfaces
% 
% %calculate 3D surface
% for i = 1:size(OCTinV,2)
%     for j = 1:size(OCTinV,3)
%         OCTEdgesV_inner(vmap_inner(i,j),i,j) = 1;
%         OCTEdgesH_inner(hmap_inner(i,j),i,j) = 1;
%         OCTEdgesV_outer(vmap_outer(i,j),i,j) = 1;
%         OCTEdgesH_outer(hmap_outer(i,j),i,j) = 1;
% 
%     end
% end

%[x,fval,exitflag,output] = bads(fun,x0,lb,ub,plb,pub,[],options,mu);
options = bads('defaults');             % Get a default OPTIONS struct
options.MaxFunEvals         = 100;       % Very low budget of function evaluations
options.Display             = 'final';   % Print only basic output ('off' turns off)
options.UncertaintyHandling = 0;        % We tell BADS that the objective is deterministic

global states
global itr;
states = zeros(100,3);
itr = 0;

%Full Search 
% Angles = optimizationParams(1:2);
% Center = optimizationParams(3:5);
% R = optimizationParams(6);
% 

%Vscan
 x0_v=[0 0 0 0 0 18];
 lb_v=[-10*pi/180 -10*pi/180 0 0 0 15];
 ub_v=[10*pi/180 10*pi/180 15 15 15 28];
 plb_v=[-5*pi/180 -5*pi/180 0 0 0 17];
 pub_v=[5*pi/180 5*pi/180 5 5 5 20];

h=figure(11);
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,'./demo5.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
      
%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesV,Params,'./demo5.gif'),x0_v,lb_v,ub_v,plb_v,pub_v,[],options);

%Hscan

  x0_h=[0 90*pi/180 0 0 0 18];
 lb_h=[-10*pi/180 80*pi/180 0 0 0 15];
 ub_h=[10*pi/180 100*pi/180 15 15 15 28];
 plb_h=[-5*pi/180 85*pi/180 0 0 0 17];
 pub_h=[5*pi/180 95*pi/180 5 5 5 20];
 
 h=figure(15);
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,'./demo15.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
imwrite(imind,cm,'./demo11.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
 
%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesH,Params,'./demo8.gif'),x0_h,lb_h,ub_h,plb_h,pub_h,[],options);

x0_both=[x0_v x0_h];
lb_both=[lb_v lb_h];
ub_both=[ub_v ub_h];
plb_both=[plb_v plb_h];
pub_both=[pub_v pub_h];

OCTinV_d = double(OCTinV);
OCTinH_d = double(OCTinH);

[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionCostFunctionWrapper(OCTEdgesV_outer,OCTEdgesH_outer,Params,'./demo15.gif','./demo11.gif'),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);
%[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionCostFunctionWrapper(OCTinV_d,OCTinH_d,Params,'./demo10.gif','./demo11.gif'),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);

%R solo Search
% x0=100;
% lb=1;
% ub=350;
% plb=1;
% pub=350;
% [x,fval,exitflag] = bads(@(R) OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R),x0,lb,ub,plb,pub,[],options);

%Center Search
% x0=[100 100 100];
% lb=[0 0 0];
% ub=[100 100 100];
% plb=[0 0 0];
% pub=[100 100 100];
% [x,fval,exitflag] = bads(@(Center) OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R),x0,lb,ub,plb,pub,[],options);

%Angle Search
% x0=[.25 .25];
% lb=[0 0];
% ub=[.35 .35];
% plb=[0 0];
% pub=[.35 .35];
% [x,fval,exitflag] = bads(@(Angles) OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R),x0,lb,ub,plb,pub,[],options);



figure(20)
clf;
plot(states(:,1));
figure(21)
clf;
plot(states(:,2));
figure(22)
clf;
plot(states(:,3));
