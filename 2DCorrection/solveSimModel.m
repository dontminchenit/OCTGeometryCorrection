figure(1)
%simImage1 = modelPerspective(70,30,-50,20);
simImage1 = modelPerspective(75,30,-50,200);
figure(2)
%simImage2 = modelPerspectiveOverlay(80,30,50,200);
%simImage2 = modelPerspective(80,30,50,20);
simImage2 = modelPerspective(90,30,50,200);
figure(3)
[correspondance, ind1, ind2] = intersect(simImage1(:),simImage2(:));



XN = size(simImage1,2);
YN = size(simImage1,1);

simImageMask1 = zeros(YN,XN);
simImageMask2 = zeros(YN,XN);

simImageMask1(ind1) = correspondance;
simImageMask2(ind2) = correspondance;

[y1,x1] = ind2sub(size(simImage1),ind1);
[y2,x2] = ind2sub(size(simImage2),ind2);

figure(4)
subplot(1,2,1)
imagesc(simImageMask1)
colormap('parula')
subplot(1,2,2)
imagesc(simImageMask2)
colormap('parula')

R_all = zeros(1,10000);

%simImage1(y1(j),x1(j))

for q = 1:10000

i = round((size(x1,1)-1)*rand(1))+1;
j = round((size(x1,1)-1)*rand(1))+1;
    
a1 = (x1(j) - x1(i))*30*pi/(180*200); 
a2 = (x2(j) - x2(i))*30*pi/(180*200);
r1_c1 = y1(i);
r2_c1 = y1(j);
r1_c2 = y2(i);
r2_c2 = y2(j);

R=solveR(a1,a2,r1_c1,r1_c2,r2_c1,r2_c2);

Rsolution = R(R>0);

if(~isempty(Rsolution) && length(Rsolution) == 1)
R_all(q) = R(R>0);
end
end