function [fig,sloBars_v_reg,sloBars_h,mapSLO_v_interp_reg,mapSLO_h_interp,slo_v_reg,tform] = plotBndDiff(volFn_v, volFn_h, map_v, map_h)

%hScan_fn
%vScan_fn
%inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_data\connectomeRetinaData\11015\HeidelbergSpectralisOCT\OD';
%inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSLOImageProcessing\OCT Data\20171024'
%inDir = 'C:\Users\dontm\Documents\ResearchResults\K99\MinvsAlemanComparison'


%fns = dir(fullfile(inDir,'*.vol'));

%for i = 1:length(fns)
%     i
% fn = fullfile(inDir,fns(i).name);
% 
% [header_h, BScanHeader_h, slo_h, BScans_h] = openVolFast(fn);
% [sloBars_h,  mapSLO_h] = OCTBarsOnSLO(slo_h,header_h,BScanHeader_h,BScans_h);
% imagesc(sloBars_h);
% pause
% end


%bndCompareT=5;
%bndCompareB=6;

%for i = 1:length(fns)
%i=4
%i=1
%fn = fullfile(inDir,fns(i).name);
[header_h, BScanHeader_h, slo_h, BScans_h] = openVolFast(volFn_h);
%[boundaries_h, img_vol_h] = quickSegmentOCT(fn);
%thic_h = boundaries_h(:,:,bndCompareB)-boundaries_h(:,:,bndCompareT);

[sloBars_h,  mapSLO_h] = OCTBarsOnSLO(slo_h,header_h,BScanHeader_h,BScans_h,map_h);
mapSLO_h_interp = interpolateEnface(double(mapSLO_h));
figure(1)
subplot(1,2,1);
imagesc(sloBars_h);
subplot(1,2,2);
imagesc(mapSLO_h_interp);
colormap('gray')
caxis([min(mapSLO_h_interp(:)) max(mapSLO_h_interp(:))]);



%i=5
%i=3
%fn = fullfile(inDir,fns(i).name);
%fn = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSLOImageProcessing\OCT Data\20171107\11079-20171107-HeidelbergSpectralisOCT\Freehand\11079_1_44538.vol';
[header_v, BScanHeader_v, slo_v, BScans_v] = openVolFast(volFn_v);
%[boundaries_v, img_vol_v] = quickSegmentOCT(fn);
%thic_v = boundaries_v(:,:,bndCompareB)-boundaries_v(:,:,bndCompareT);

[sloBars_v,  mapSLO_v] = OCTBarsOnSLO(slo_v,header_v,BScanHeader_v,BScans_v,map_v);
mapSLO_v_interp = interpolateEnface(double(mapSLO_v));
figure(2)
subplot(1,2,1);
imagesc(sloBars_v);
subplot(1,2,2);
imagesc(mapSLO_v_interp);
colormap('gray')

[optimizer, metric] = imregconfig('monomodal');
[tform] =  imregtform(slo_v, slo_h, 'rigid', optimizer, metric);

mapSLO_v_interp_reg = imwarp(mapSLO_v_interp,tform,'OutputView',imref2d(size(double(slo_h))));
sloBars_v_reg = imwarp(sloBars_v,tform,'OutputView',imref2d(size(slo_h)));
slo_v_reg = imwarp(slo_v,tform,'OutputView',imref2d(size(slo_h)));


figure(3)
subplot(1,2,1);
imagesc(sloBars_v_reg);
subplot(1,2,2);
imagesc(mapSLO_v_interp_reg);
colormap('gray')
caxis([min(mapSLO_v_interp_reg(:)) max(mapSLO_v_interp_reg(:))]);



[sloBars_combined, ~] = OCTBarsOnSLO(sloBars_v_reg,header_h,BScanHeader_h,BScans_h,map_h);
mapSLO_combined = (mapSLO_v_interp_reg + mapSLO_h_interp)/2;
mapSLO_diff = mapSLO_v_interp_reg*header_v.ScaleZ*1000 - mapSLO_h_interp*header_h.ScaleZ*1000;
mask = mapSLO_v_interp_reg & mapSLO_h_interp;
mapSLO_diff(~mask) = 0;

fig = figure(4)
subplot(1,3,1);
%imagesc(sloBars_combined);
imshowpair(sloBars_v_reg,sloBars_h);
subplot(1,3,2);
imshowpair(mapSLO_v_interp_reg,mapSLO_h_interp);
subplot(1,3,3);
imagesc(mapSLO_diff);
colormap('default')
caxis([prctile(mapSLO_diff(:),.1)  prctile(mapSLO_diff(:),99.9)])
%caxis([min(mapSLO_diff(:))  max(mapSLO_diff(:))])

colorbar
%end

%[header_h, BScanHeader_h, slo_h, BScans_h] = openVolFast(hScan_fn);
%[header_v, BScanHeader_v, slo_v, BScans_v] = openVolFast(vScan_fn);