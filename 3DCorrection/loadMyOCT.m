inDir = 'C:\Users\dontm\Documents\ResearchResults\K99\20171024\';
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\TestMyData_12_17_2018';
subVolFiles = dir(fullfile(inDir,'*.vol'));

myBoundaries = cell(1,12);
counter = 0;

for n = 1:size(subVolFiles)
%[boundaries, img_vol] = quickSegmentOCT(fullfile(inDir,subVolFiles(n).name),outDir);
[header, BScanHeader, slo, BScans] = openVolFast(fullfile(inDir,subVolFiles(n).name));%,'nodisp');
BScansTop = BScans;
BScansTop(BScansTop<=1) = 0;
BScans(BScans>1) = 0;
BScans= BScans.^.25;

counter = counter+1;
[retinaMask, shifts, boundaries, nbpt] = retinaDetector2_scale(BScans,header);
myBoundaries{counter} = boundaries;
subplot(3,4,n)
imagesc(BScans(:,:,49));
end


inDir = 'C:\Users\dontm\Documents\ResearchResults\K99\20171107\11079-20171107-HeidelbergSpectralisOCT\FollowUpTool'

subVolFiles = dir(fullfile(inDir,'*.vol'));

for n = 1:size(subVolFiles)
%[boundaries, img_vol] = quickSegmentOCT(fullfile(inDir,subVolFiles(n).name),outDir);

[header, BScanHeader, slo, BScans] = openVolFast(fullfile(inDir,subVolFiles(n).name));%,'nodisp');
BScansTop = BScans;
BScansTop(BScansTop<=1) = 0;
BScans(BScans>1) = 0;

BScans= BScans.^.25;

counter = counter+1;
[retinaMask, shifts, boundaries, nbpt] = retinaDetector2_scale(BScans,header);
myBoundaries{counter} = boundaries;

subplot(3,4,n+4)
imagesc(BScans(:,:,49));
end


inDir = 'C:\Users\dontm\Documents\ResearchResults\K99\20171107\11079-20171107-HeidelbergSpectralisOCT\Freehand'

subVolFiles = dir(fullfile(inDir,'*.vol'));

for n = 1:size(subVolFiles)
%[boundaries, img_vol] = quickSegmentOCT(fullfile(inDir,subVolFiles(n).name),outDir);

[header, BScanHeader, slo, BScans] = openVolFast(fullfile(inDir,subVolFiles(n).name));%,'nodisp');
BScansTop = BScans;
BScansTop(BScansTop<=1) = 0;
BScans(BScans>1) = 0;

BScans= BScans.^.25;
counter = counter+1;
[retinaMask, shifts, boundaries, nbpt] = retinaDetector2_scale(BScans,header);
myBoundaries{counter} = boundaries;

subplot(3,4,n+8)
imagesc(BScans(:,:,49));
end

% 


% inDir = 'C:\Users\dontm\Documents\ResearchResults\K99\MinvsAlemanComparison';
%  subVolFiles = dir(fullfile(inDir,'*.vol'));
% 
% figure(2)
% for n = 1:size(subVolFiles)
% [header, BScanHeader, slo, BScans] = openVolFast(fullfile(inDir,subVolFiles(n).name));%,'nodisp');
% BScansTop = BScans;
% BScansTop(BScansTop<=1) = 0;
% BScans(BScans>1) = 0;
% 
% BScans= BScans.^.25;
% subplot(2,5,n)
% imshow(BScans(:,:,1));
% end

