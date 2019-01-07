figure(1)
clf;
hold on
[X_V,Z_V] = meshgridOCT(headerV,BScanHeaderV);
[X_H,Z_H] = meshgridOCT(headerH,BScanHeaderH);

vmap=vmap_inner*headerV.ScaleZ;
hmap=hmap_inner*headerH.ScaleZ;

%vmap=vmap_outer*headerV.ScaleZ;
%hmap=hmap_outer*headerH.ScaleZ;


offset = max(max(vmap)) - max(max(hmap));

az=-140;
el=40;
 mesh(X_V,Z_V,vmap);
 set(gca, 'ZDir','reverse')
 colormap(spring)
 view(az,el)
 freezeColors
 mesh(X_H,Z_H,hmap+offset);
 set(gca, 'ZDir','reverse')
 colormap(winter)
 view(az,el)
 grid on
ylim([0 10])
xlim([0 10])
zlim([0 1])

figure(2)
mesh(X_V,Z_V,vmap)
set(gca, 'ZDir','reverse')
 view(az,el)
colormap(spring)
ylim([0 10])
xlim([0 10])
zlim([0 1])


figure(3)
mesh(X_H,Z_H,hmap+offset)
set(gca, 'ZDir','reverse')
ylim([0 10])
xlim([0 10])
zlim([0 1])
 view(az,el)
colormap(winter)