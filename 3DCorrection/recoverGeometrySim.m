%generate3Dmodels

OCTinV = vscan;
OCTEdgesV = zeros(size(vscan));

for i = 1:size(OCTinV,2)
    for j = 1:size(OCTinV,3)
        OCTEdgesV(vmap(i,j),i,j) = 1;
    end
end

OCTinH = hscan;
OCTEdgesH = zeros(size(hscan));

for i = 1:size(OCTinH,2)
    for j = 1:size(OCTinH,3)
        OCTEdgesH(hmap(i,j),i,j) = 1;
    end
end

% Angles = [0 0];
% Center = [0 10 0];
%Center = [50 30 30];
%R=200;

%fixOCTGeometry(OCTin,Angles,Center,R) 


%cost = OCTGeometryCorrectionCostFunction(OCTEdges,Angles,Center,R)

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
 x0_v=[0 0 5 5 5 150];
 lb_v=[0 0 0 0 0 1];
 ub_v=[0.15 0.15 50 50 50 350];
 plb_v=[0 0 0 0 0 150];
 pub_v=[0.05 0.05 10 20 10 250];

      h=figure(11)
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
          imwrite(imind,cm,'./demo2.gif','gif', 'DelayTime', 0.2,'Loopcount',1); 
      
%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesV,Params),x0_v,lb_v,ub_v,plb_v,pub_v,[],options);

%Hscan

 x0_h=[0 90*pi/180 5 5 5 150];
 lb_h=[0 90*pi/180 0 0 0 1];
 ub_h=[0 90*pi/180 50 50 50 350];
 plb_h=[0 90*pi/180 0 0 0 150];
 pub_h=[0 90*pi/180 10 20 10 250];

%[x,fval,exitflag] = bads(@(Params) OCTGeometryCorrectionCostFunctionWrapper(OCTEdgesH,Params),x0_h,lb_h,ub_h,plb_h,pub_h,[],options);

x0_both=[x0_v x0_h];
lb_both=[lb_v lb_h];
ub_both=[ub_v ub_h];
plb_both=[plb_v plb_h];
pub_both=[pub_v pub_h];

[x,fval,exitflag] = bads(@(Params)  OCTGeometryDualCorrectionCostFunctionWrapper(vscanFeatures,hscanFeatures,Params),x0_both,lb_both,ub_both,plb_both,pub_both,[],options);

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
