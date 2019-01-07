function simScan = modelPerspective3D(AngleStart,AngleSize,CameraOffset,phiN,coordmode,alpha_x,alpha_y)

imYN = 1250;
imXN = 3000;
testobj = zeros(imYN,imXN);


%Camera_Center = [imXN/2+CameraOffset 100 imXN/2+CameraOffset];
Camera_Center = [CameraOffset 10 CameraOffset];
%alpha_x = 10*pi/180;
%alpha_y = 90*pi/180;

rotationX = [1 0 0; 0 cos(alpha_x) -sin(alpha_x);0 sin(alpha_x) cos(alpha_x)];
rotationY = [cos(alpha_y) 0 sin(alpha_y); 0 1 0; -sin(alpha_y) 0 cos(alpha_y)];

Camera_Rot = rotationX*rotationY;

R = 200;
scanLength = 100;
scanEnd = R+scanLength;
%AngleStart = 75;%degree
%AngleSize = 30;%degree
%phiN = 200;
numBscans = 12%49;
phi = (AngleStart:(AngleSize/(phiN-1)):(AngleStart+AngleSize))*pi/180;
thetaN = (AngleStart:(AngleSize/(numBscans-1)):(AngleStart+AngleSize))*pi/180;

%Cylindrical
zFov = 100;
zN = -zFov/2:(((zFov)/(numBscans-1))):zFov/2;
clf
objCenter = [0 250 0];
objSideLength =[250 200 300]; 
objExt = [(objCenter-objSideLength/2);(objCenter+objSideLength/2)];
figure(1)
clf;

%[x,y,z] = ellipsoid(0,0,0,250,50,300,100);

%x(y<25) =[];
%z(y<25) =[];
%y(y<25) =[];

%surf(x(:,75:end),y(:,75:end),z(:,75:end))
%[x,y,z] = ellipsoid(xc,yc,zc,xr,yr,zr,n)

xlabel('x')
ylabel('y')
zlabel('z')


%plotcube(objSideLength,objExt(1,:),.5,[211/255 211/255 211/255]);

worldExt = [-150 0 -150;150 350 150];
worldLength = [(worldExt(2,1)-worldExt(1,1)) (worldExt(2,2)-worldExt(1,2)) (worldExt(2,3)-worldExt(1,3)) ];
xlim([worldExt(1,1) worldExt(2,1)])
ylim([worldExt(1,2) worldExt(2,2)])
zlim([worldExt(1,3) worldExt(2,3)])
hold on



sim_YN = 100;
sim_XN = size(phi,2);
sim_ZN = numBscans;

AscanPoints = R:(scanEnd-R)/(sim_YN-1):scanEnd;

simScan = zeros(sim_YN,sim_XN,sim_ZN);

[X,Y,Z] = meshgrid(worldExt(1,1):worldExt(2,1),worldExt(1,2):worldExt(2,2),worldExt(1,3):worldExt(2,3));
V=zeros(worldLength(2)+1,worldLength(1)+1,worldLength(3)+1); %Remember: X & Y are flipped in matrix form, Y is rows, X is cols
%V((objExt(1,2) - worldExt(1,2)+1):(objExt(2,2) - worldExt(1,2)+1),...
%    (objExt(1,1) - worldExt(1,1)+1):(objExt(2,1) - worldExt(1,1)+1),...
%    (objExt(1,3) - worldExt(1,3)+1):(objExt(2,3) - worldExt(1,3)+1)) = 1;
V_bnd = V;
counter = 1;
x_in_r2=350*350;
y_in_r2=225*225;
z_in_r2=350*350;

x_out_r2=350*350;
y_out_r2=300*300;
z_out_r2=350*350;


for i=(objExt(1,2) - worldExt(1,2)+1):(objExt(2,2) - worldExt(1,2)+1)
    for j = (objExt(1,1) - worldExt(1,1)+1):(objExt(2,1) - worldExt(1,1)+1)
        for k = (objExt(1,3) - worldExt(1,3)+1):(objExt(2,3) - worldExt(1,3)+1)
            
            x=X(i,j,k);
            y=Y(i,j,k);
            z=Z(i,j,k);
            inside = (y*y/y_in_r2 + x*x/x_in_r2 + z*z/z_in_r2) >= 1;
            outside = (y*y/y_out_r2 + x*x/x_out_r2 + z*z/z_out_r2) <= 1;
            if(inside && outside)
                V(i,j,k) = counter;
                counter = counter+1;
            end
        end
    end
end

%find surface of obj

%V_bnd(i,j,k) = 1;
for j = (objExt(1,1) - worldExt(1,1)+1):(objExt(2,1) - worldExt(1,1)+1)
    for k = (objExt(1,3) - worldExt(1,3)+1):(objExt(2,3) - worldExt(1,3)+1)
            i_first = min(find(V(:,j,k) > 0));
            i_last  = max(find(V(:,j,k) > 0));
            V_bnd(i_first,j,k) = 1;
            V_bnd(i_last,j,k) = 1;
            
    end
end

%plot object
scatter3(X(V_bnd>0),Y(V_bnd>0),Z(V_bnd>0),'filled','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);
view(-59,24)

for b = 1:numBscans
    
    x_C = Camera_Center(1)*(ones(size(phi)));
    y_C = Camera_Center(2)*(ones(size(phi)));
    z_C = Camera_Center(3)*(ones(size(phi)));
    
    if coordmode == 1%spherical
        z_C = Camera_Center(3)*ones(size(phi));
        
        theta =  thetaN(b);
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

        coor_Start_rot = Camera_Rot*[x_Start; y_Start; z_Start;];

        
        x_R = R*cos(phi);
        y_R = R*sin(phi);
        z_R = z*ones(size(phi));
        
        coor_R_rot = Camera_Rot*[x_R; y_R; z_R;];

        
        x_End = scanEnd*cos(phi);
        y_End = scanEnd*sin(phi);
        z_End = z*ones(size(phi));
        
        
        coor_End_rot = Camera_Rot*[x_End; y_End; z_End];
    end
    
    x_Start = coor_Start_rot(1,:) + x_C;
    y_Start = coor_Start_rot(2,:) + y_C;
    z_Start = coor_Start_rot(3,:) + z_C;
    
    x_R = coor_R_rot(1,:) + x_C;
    y_R = coor_R_rot(2,:) + y_C;
    z_R = coor_R_rot(3,:) + z_C;

    x_End = coor_End_rot(1,:) + x_C;
    y_End = coor_End_rot(2,:) + y_C;
    z_End = coor_End_rot(3,:) + z_C;

    figure(1)
    %subplot(1,2,1)
    %imshow(testobj)
    %caxis([min(testobj(:)) max(testobj(:))]);
    %line([x_R(1) ; Camera_Center(1)],[y_R(1) ; Camera_Center(2)],[z_R(1) ; Camera_Center(3)],'color','g','lineWidth',2);
    line([x_R ; x_Start],[y_R ; y_Start],[z_R ; z_Start],'color','g','lineWidth',2);
    line(x_R,y_R,z_R,'color','b','lineWidth',2);
    line([x_R ; x_End],[y_R ; y_End],[z_R ; z_End],'color','b','lineWidth',2);
    line(x_End,y_End,z_End,'color','b','lineWidth',2);
    
    
    
    Xq = AscanPoints'*cos(phi);
    Yq = AscanPoints'*sin(phi);
    Zq = z*ones(length(AscanPoints),length(phi));
    
    coor_q_rot = Camera_Rot*[Xq(:)'; Yq(:)'; Zq(:)'];
    
    Xq = reshape(coor_q_rot(1,:),[length(AscanPoints) length(phi)]) + Camera_Center(1)*ones(length(AscanPoints),length(phi));
    Yq = reshape(coor_q_rot(2,:),[length(AscanPoints) length(phi)]) + Camera_Center(2)*ones(length(AscanPoints),length(phi));
    Zq = reshape(coor_q_rot(3,:),[length(AscanPoints) length(phi)]) + Camera_Center(3)*ones(length(AscanPoints),length(phi));
    
    Vq = interp3(X,Y,Z,V,Xq,Yq,Zq,'nearest');
    simScan(:,:,b)=Vq;
    
    figure(2)
%    subplot(7,7,b);
    subplot(3,4,b);
    imagesc(Vq);

end


%simulate scan
hold off



AscanPoints = R:scanEnd;

% Xq = AscanPoints'*cos(phi) + Camera_Center(1)*ones(length(AscanPoints),length(phi));
% Yq = AscanPoints'*sin(phi) + Camera_Center(2)*ones(length(AscanPoints),length(phi));

% 
% x_C = Camera_Center(1)*ones(length(AscanPoints),length(phi));
% y_C = Camera_Center(2)*ones(length(AscanPoints),length(phi));
%     if coordmode == 1%spherical
%         z_C = Camera_Center(3)*ones(size(phi));
%         
%         theta =  thetaN(i);
%         
% %        Xq = AscanPoints'*cos(phi) + ;
%         Yq = AscanPoints'*sin(phi) + Camera_Center(2)*ones(length(AscanPoints),length(phi));
%         zq = AscanPoints;
% 
%         x_R = AscanPoints'*sin(theta)*cos(phi) + x_C;
%         y_R = AscanPoints'*sin(theta)*sin(phi) + y_C;
%         z_R = AscanPoints'*cos(theta)+ z_C;
%         
%         x_End = scanEnd*sin(theta)*cos(phi) + x_C;
%         y_End = scanEnd*sin(theta)*sin(phi) + y_C;
%         z_End = scanEnd*cos(theta) + z_C;
%     else%Cylindrical
%         
%         z = zN(i);
%         x_R = R*cos(phi) + x_C;
%         y_R = R*sin(phi) + y_C;
%         z_R = z + Camera_Center(3)*ones(size(phi));
%         
%         x_End = scanEnd*cos(phi) + x_C;
%         y_End = scanEnd*sin(phi) + y_C;
%         z_End = z + Camera_Center(3)*ones(size(phi));
%         z_C = z_R;
% 
%     end






%simScan = fliplr(interp2(X,Y,testobj,Xq,Yq,'nearest'));



%subplot(1,2,2)
%imagesc(simScan)

%line([100 200; 700 200; 300 200]',[100 200; 100 200; 100 200]','color','k','lineWidth',2);