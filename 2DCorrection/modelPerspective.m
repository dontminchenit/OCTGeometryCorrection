function simScan = modelPerspective(AngleStart,AngleSize,CameraOffset,phiN)

imYN = 1250;
imXN = 3000;
testobj = zeros(imYN,imXN);
testobj(750:900,:) = reshape(1:151*imXN,151,imXN);

vesselobj = zeros(imYN,imXN);


Camera_Center = [imXN/2+CameraOffset 100];
R = 500;
scanLength = 500;
scanEnd = R+scanLength;
%AngleStart = 75;%degree
%AngleSize = 30;%degree
%phiN = 200;
phi = (AngleStart:(AngleSize/phiN):(AngleStart+AngleSize))*pi/180;
x_R = R*cos(phi) + Camera_Center(1)*ones(size(phi));
y_R = R*sin(phi) + Camera_Center(2)*ones(size(phi));

x_End = scanEnd*cos(phi) + Camera_Center(1)*ones(size(phi));
y_End = scanEnd*sin(phi) + Camera_Center(2)*ones(size(phi));

%figure
%subplot(2,1,1)
hold on
imshow(testobj)
caxis([min(testobj(:)) max(testobj(:))]);
line([x_R ; Camera_Center(1)*(ones(size(phi)))],[y_R ; Camera_Center(2)*(ones(size(phi)))],'color','g','lineWidth',2);
line(x_R,y_R,'color','b','lineWidth',2);
line([x_R ; x_End],[y_R ; y_End],'color','b','lineWidth',2);
line(x_End,y_End,'color','b','lineWidth',2);

%simulate scan

sim_YN = 100;
sim_XN = size(phi,2);
simScan = zeros(sim_YN,sim_XN);

[X,Y] = meshgrid(1:imXN,1:imYN);

AscanPoints = R:scanEnd;

Xq = AscanPoints'*cos(phi) + Camera_Center(1)*ones(length(AscanPoints),length(phi));
Yq = AscanPoints'*sin(phi) + Camera_Center(2)*ones(length(AscanPoints),length(phi));


simScan = fliplr(interp2(X,Y,testobj,Xq,Yq,'nearest'));

% subplot(2,1,2)
clf
imagesc(simScan)
axis off
axis square
colormap('gray')
%line([100 200; 700 200; 300 200]',[100 200; 100 200; 100 200]','color','k','lineWidth',2);