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
 x0_v=[0 0 18];
 lb_v=[-10*pi/180 -10*pi/180 15];
 ub_v=[10*pi/180 10*pi/180 28];
 plb_v=[-5*pi/180 -5*pi/180 17];
 pub_v=[5*pi/180 5*pi/180 20];

%  x0_v=[0 0 39];
%  lb_v=[0 0 10];
%  ub_v=[0 0 108];
%  plb_v=[0 0 17];
%  pub_v=[0 0 100];


h=figure(11);
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,'./demo5.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
      
%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesV,Params,'./demo5.gif'),x0_v,lb_v,ub_v,plb_v,pub_v,[],options);

%Hscan

  x0_h=[0 90*pi/180 18];
 lb_h=[-10*pi/180 80*pi/180 15];
 ub_h=[10*pi/180 100*pi/180 28];
 plb_h=[-5*pi/180 85*pi/180 17];
 pub_h=[5*pi/180 95*pi/180 20];
%  
%  x0_h=[0 90*pi/180 38];
%  lb_h=[0 90*pi/180 10];
%  ub_h=[0 90*pi/180 108];
%  plb_h=[0 90*pi/180 17];
%  pub_h=[0 90*pi/180 100];


 h=figure(15);
 clf
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,'./demo15.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
 h=figure(12);
 clf
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,'./demo16.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
 
%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesH,Params,'./demo8.gif'),x0_h,lb_h,ub_h,plb_h,pub_h,[],options);

x0_both=[x0_v x0_h];
lb_both=[lb_v lb_h];
ub_both=[ub_v ub_h];
plb_both=[plb_v plb_h];
pub_both=[pub_v pub_h];

OCTinV_d = double(OCTinV);
OCTinH_d = double(OCTinH);

[x, I] = max(vmap_inner(:));
[y, z] = ind2sub(size(vmap_inner),I);
foveaV = sub2ind(size(BScansV),x,y,z);

[x, I] = max(hmap_inner(:));
[y, z] = ind2sub(size(hmap_inner),I);
foveaH = sub2ind(size(BScansH),x,y,z);


[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionMutliSurfaceCostFunctionWrapper(OCTEdgesV_inner,OCTEdgesH_inner,OCTEdgesV_outer,OCTEdgesH_outer,Params,foveaV,foveaH,'./demo15.gif','./demo16.gif'),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);

%[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionCostFunctionWrapper(OCTEdgesV_inner,OCTEdgesH_inner,Params,foveaV,foveaH,'./demo15.gif','./demo16.gif'),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);
%[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionCostFunctionWrapper(OCTEdgesV_Both,OCTEdgesH_Both,Params,foveaV,foveaH,'./demo15.gif','./demo16.gif'),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);
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
