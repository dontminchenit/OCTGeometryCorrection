function [correctedLoc_X, correctedLoc_Y, correctedLoc_Z] = fixOCTGeometry(OCTin,Angles,Center,R,Res,coordmode)

XN = size(OCTin,2);
YN = size(OCTin,1);
ZN = size(OCTin,3);

alpha_x = Angles(1);
alpha_y = Angles(2);

phiN = XN;
phiStart = 75;
phiSize = 30;
phi = (phiStart:(phiSize/(phiN-1)):(phiStart+phiSize))*pi/180;

thetaStart = 83.5;
thetaSize = 15;
thetaN = (phiStart:(thetaSize/(ZN-1)):(thetaStart+thetaSize))*pi/180;

rotationX = [1 0 0; 0 cos(alpha_x) -sin(alpha_x);0 sin(alpha_x) cos(alpha_x)];
rotationY = [cos(alpha_y) 0 sin(alpha_y); 0 1 0; -sin(alpha_y) 0 cos(alpha_y)];

Camera_Rot = rotationX*rotationY;
%res = [0.00387 0.01281 0.06834];

AscanPoints = R:(YN*Res(1))/(YN-1):(R+YN*Res(1));
zFov = ZN*Res(3);
zN = -zFov/2:(((zFov)/(ZN-1))):zFov/2;

correctedLoc_X = zeros(YN,XN,ZN);
correctedLoc_Y = zeros(YN,XN,ZN);
correctedLoc_Z = zeros(YN,XN,ZN);

for b = 1:ZN
    
    x_C = Center(1)*ones(length(AscanPoints),length(phi));
    y_C = Center(2)*ones(length(AscanPoints),length(phi));
    z_C = Center(3)*ones(length(AscanPoints),length(phi));
    
    if coordmode == 1%spherical
        theta =  thetaN(b);
        Xq = (AscanPoints)'*cos(phi)*sin(theta);
        Yq = (AscanPoints)'*sin(phi)*sin(theta);
        Zq = (AscanPoints)'*cos(theta)*ones(1,length(phi));
        
    else
        z = zN(b);
        Xq = (AscanPoints)'*cos(phi);
        Yq = (AscanPoints)'*sin(phi);
        Zq = z*ones(length(AscanPoints),length(phi));
    end
    
    coor_q_rot = Camera_Rot*[Xq(:)'; Yq(:)'; Zq(:)'];
    
    Xq = reshape(coor_q_rot(1,:),[length(AscanPoints) length(phi)]) + x_C;
    Yq = reshape(coor_q_rot(2,:),[length(AscanPoints) length(phi)]) + y_C;%Center(2)*ones(length(AscanPoints),length(phi));
    Zq = reshape(coor_q_rot(3,:),[length(AscanPoints) length(phi)]) + z_C;%Center(3)*ones(length(AscanPoints),length(phi));
    
    correctedLoc_X(:,:,b) = Xq;
    correctedLoc_Y(:,:,b) = Yq;
    correctedLoc_Z(:,:,b) = Zq;
    
end
