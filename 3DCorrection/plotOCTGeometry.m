function plotOCTGeometry(Angles,Center,R)
numBscans = 97;%49;
phiN=50;
AngleStart = 75;
AngleSize = 30;
phi = (AngleStart:(AngleSize/(phiN-1)):(AngleStart+AngleSize))*pi/180;
thetaN = (AngleStart:(AngleSize/(numBscans-1)):(AngleStart+AngleSize))*pi/180;

res = [0.00387 0.01281 0.06834];
dim = [496 768 97];
%R=r*res(1);

%R=R;
scanLength = dim(1)*res(1);
scanEnd = R+scanLength;

alpha_x = Angles(1);
alpha_y = Angles(2);

zFov = 97*res(3);
zN = -zFov/2:(((zFov)/(numBscans-1))):zFov/2;

rotationX = [1 0 0; 0 cos(alpha_x) -sin(alpha_x);0 sin(alpha_x) cos(alpha_x)];
rotationY = [cos(alpha_y) 0 sin(alpha_y); 0 1 0; -sin(alpha_y) 0 cos(alpha_y)];
Camera_Rot = rotationX*rotationY;

coordmode=0;

EdgesStart=zeros(5,3);
EdgesEnd=zeros(5,3);

for b = [1 numBscans]
    
    x_C = Center(1)*(ones(size(phi)));
    y_C = Center(2)*(ones(size(phi)));
    z_C = Center(3)*(ones(size(phi)));
    
    if coordmode == 1%spherical
        theta =  thetaN(b);
        
        x_Start = 0*ones(size(phi));
        y_Start = 0*ones(size(phi));
        z_Start = 0*ones(size(phi));
        
        x_R = R*sin(theta)*cos(phi);
        y_R = R*sin(theta)*sin(phi);
        z_R = R*cos(theta);
        
        x_End = scanEnd*sin(theta)*cos(phi);
        y_End = scanEnd*sin(theta)*sin(phi);
        z_End = scanEnd*cos(theta);
    else%Cylindrical
        
        z = zN(b);

        x_Start = 0*ones(size(phi));
        y_Start = 0*ones(size(phi));
        z_Start = z*ones(size(phi));
       
        x_R = R*cos(phi);
        y_R = R*sin(phi);
        z_R = z*ones(size(phi));
        

        x_End = scanEnd*cos(phi);
        y_End = scanEnd*sin(phi);
        z_End = z*ones(size(phi));
        

    end
       
    coor_Start_rot = Camera_Rot*[x_Start; y_Start; z_Start;];
    coor_R_rot = Camera_Rot*[x_R; y_R; z_R;];
    coor_End_rot = Camera_Rot*[x_End; y_End; z_End];
    x_Start = coor_Start_rot(1,:) + x_C;
    y_Start = coor_Start_rot(2,:) + y_C;
    z_Start = coor_Start_rot(3,:) + z_C;
    
    x_R = coor_R_rot(1,:) + x_C;
    y_R = coor_R_rot(2,:) + y_C;
    z_R = coor_R_rot(3,:) + z_C;

    x_End = coor_End_rot(1,:) + x_C;
    y_End = coor_End_rot(2,:) + y_C;
    z_End = coor_End_rot(3,:) + z_C;

  
    
%plot
hold on
line([x_R(1) ; x_Start(1)],[y_R(1) ; y_Start(1)],[z_R(1) ; z_Start(1)],'color','g','lineWidth',2);
line([x_R(end) ; x_Start(end)],[y_R(end) ; y_Start(end)],[z_R(end) ; z_Start(end)],'color','g','lineWidth',2);
line(x_R,y_R,z_R,'color','k','lineWidth',2);

line([x_R(1) ; x_End(1)],[y_R(1) ; y_End(1)],[z_R(1) ; z_End(1)],'color','k','lineWidth',2);
line([x_R(end) ; x_End(end)],[y_R(end) ; y_End(end)],[z_R(end) ; z_End(end)],'color','k','lineWidth',2);
line(x_End,y_End,z_End,'color','k','lineWidth',2);

if b==1
EdgesStart(1,1:3)=[x_R(1) y_R(1) z_R(1)];
EdgesStart(2,1:3)=[x_R(end) y_R(end) z_R(end)];
EdgesStart(3,1:3)=[x_End(1) y_End(1) z_End(1)];
EdgesStart(4,1:3)=[x_End(end) y_End(end) z_End(end)];
EdgesStart(5,1:3)=[x_Start(1) y_Start(1) z_Start(1)];

elseif b==numBscans
EdgesEnd(1,1:3)=[x_R(1) y_R(1) z_R(1)];
EdgesEnd(2,1:3)=[x_R(end) y_R(end) z_R(end)];
EdgesEnd(3,1:3)=[x_End(1) y_End(1) z_End(1)];
EdgesEnd(4,1:3)=[x_End(end) y_End(end) z_End(end)];
EdgesEnd(5,1:3)=[x_Start(1) y_Start(1) z_Start(1)];
end

end
line([EdgesStart(1:4,1)' ; EdgesEnd(1:4,1)'],[EdgesStart(1:4,2)' ; EdgesEnd(1:4,2)'],[EdgesStart(1:4,3)' ; EdgesEnd(1:4,3)'],'color','k','lineWidth',2);
line([EdgesStart(5,1)' ; EdgesEnd(5,1)'],[EdgesStart(5,2)' ; EdgesEnd(5,2)'],[EdgesStart(5,3)' ; EdgesEnd(5,3)'],'color','g','lineWidth',2);
