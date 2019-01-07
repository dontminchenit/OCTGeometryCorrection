

optimizationParams=x;

Angles_V = optimizationParams(1:2);
Center_V = optimizationParams(3:5);
R_V = optimizationParams(6);

Angles_H = optimizationParams(7:8);
Center_H = optimizationParams(9:11);
R_H = optimizationParams(12);


%cost = OCTGeometryDualCorrectionCostFunction(VScan,Angles_V,Center_V,R_V,HScan,Angles_H,Center_H,R_H);

%[cost_V,surfPointsX_V_inner,surfPointsY_V_inner,surfPointsZ_V_inner] = OCTGeometryCorrectionCostFunction(OCTEdgesV_inner,Angles_V,Center_V,R_V);
%[cost_V,surfPointsX_V_outer,surfPointsY_V_outer,surfPointsZ_V_outer] = OCTGeometryCorrectionCostFunction(OCTEdgesV_outer,Angles_V,Center_V,R_V);

%[cost_H,surfPointsX_H,surfPointsY_H,surfPointsZ_H] = OCTGeometryCorrectionCostFunction(OCTEdges_H,Angles_H,Center_H,R_H);


%DT = delaunayTriangulation(surfPointsX_V,surfPointsY_V,surfPointsZ_V);
%TRI_H = delaunayTriangulation(surfPointsX_H,surfPointsY_H,surfPointsZ_H);

%TRI_V = delaunay(surfPointsX_V,surfPointsY_V,surfPointsZ_V);
%TRI_H = delaunay(surfPointsX_H,surfPointsY_H,surfPointsZ_H);

%TRI_V = delaunay(surfPointsX_V,surfPointsZ_V);
%trimesh(TRI_v,surfPointsX_V,surfPointsZ_V,surfPointsY_V);

[xyz_inner,P_inner,F_inner,TR_inner]=createTriSurface(surfPointsX_V_inner,surfPointsY_V_inner,surfPointsZ_V_inner,1,0);

%hold on

[xyz_outer,P_outer,F_outer,TR_outer]=createTriSurface(surfPointsX_V_outer,surfPointsY_V_outer,surfPointsZ_V_outer,0,1);



