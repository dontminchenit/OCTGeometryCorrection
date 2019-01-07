addpath('..\SupportFunctions');

%load data
%Input output locations
inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_analysis\OCTExplorerSegmentationData';
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\2DThicknessMapsAllLayersFixed_11_1_2018';
mkdir(outDir);
LN = 11; %number of layers in segmentation image

AllSubIDs = dir(fullfile(inDir,'1*'));

%validIDs = [11028 11055 11088 11091 11031];
%validIDeye = [2 2 1 2 2]

for e = 1:2 %eye side
    for i = 2:length(AllSubIDs) %subject folders found.
        subject = struct;
        if (e == 1)
            subject.eyeSide = 'OD';
        else
            subject.eyeSide = 'OS';
        end
        subject.ID = str2double(AllSubIDs(i).name);
        subDir = fullfile(inDir,AllSubIDs(i).name,subject.eyeSide);
        
        %         valid = find(validIDs == subject.ID);
        %         i
        %         if(isempty(valid) || validIDeye(valid) ~= e)
        %             continue
        %         end
        %
        saveName = fullfile(outDir,num2str(subject.ID),[num2str(subject.ID) '_' subject.eyeSide '.mat']);
        if exist(saveName,'file')
            disp([AllSubIDs(i).name '(' subject.eyeSide ') already processed. Skipping.' ])
            continue
        end
        %Align using SLO
        subVolFiles = dir(fullfile(subDir,'*.vol'));
        
        if(length(subVolFiles) ~= 2 )% check there is one H and one V file
            disp(['Wrong number of OCT vol files for Subject ID ' AllSubIDs(i).name]);
        else%Read them and assign
            for s=1:2%first load each indidivdually
                %read OCT vol
                [header, BScanHeader, slo, BScans] = openVolFast(fullfile(subDir,subVolFiles(s).name));%,'nodisp');
                BScans(BScans>1) = 0;
                OrigBScans = BScans;
                BScans=BScans.^.25;
                
                %read OCT segmentation
                segfilename = fullfile(subDir,[subVolFiles(s).name(1:end-4) '_Surfaces_Retina-JEI-Final.mat']);
                segFile = open(segfilename);
                segVol = permute(segFile.mask,[3 1 2]);
                segVol= rot90(segVol,2);
                
                
                %allocate everything we're saving
                enface=squeeze(max(BScans,[],1));
                boundariesLocVoxel = findBoundariesFromSeg(segVol);
                boundariesLocMM = boundariesLocVoxel*header.ScaleZ*1000;%in mm
                thicknessAllLayers = zeros(size(boundariesLocMM,1),size(boundariesLocMM,2),LN);
                thicknessAllLayersOnSLO = zeros(size(slo,1),size(slo,2),LN);
                thicknessAllLayersOnSLOInterp = zeros(size(slo,1),size(slo,2),LN);
                
                LayerMeanIntensityMaps = findLayerMeanIntensityMaps(boundariesLocVoxel,OrigBScans,LN);
                LayerMeanIntensityMapsOnSLO = zeros(size(slo,1),size(slo,2),LN);
                LayerMeanIntensityMapsOnSLOInterp = zeros(size(slo,1),size(slo,2),LN);
                
                %calc Layer thicknesses and mean intensity on SLO
                for l = 1:LN
                    thicknessAllLayers(:,:,l) = (boundariesLocMM(:,:,l+1)-boundariesLocMM(:,:,l));%in mm
                    [sloBars,  mapSLO, isHScan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans,thicknessAllLayers(:,:,l));
                    thicknessAllLayersOnSLO(:,:,l) = mapSLO;
                    thicknessAllLayersOnSLOInterp(:,:,l) = interpolateEnface(double(mapSLO));
                    
                    [sloBars,  mapSLO, isHScan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans,LayerMeanIntensityMaps(:,:,l));
                    LayerMeanIntensityMapsOnSLO(:,:,l) = mapSLO;
                    LayerMeanIntensityMapsOnSLOInterp(:,:,l) = interpolateEnface(double(mapSLO));
                    
                end
                
                %calculate total thickness
                bndCompareB=12;
                bndCompareT=1;
                thicknessTotal = (boundariesLocMM(:,:,bndCompareB)-boundariesLocMM(:,:,bndCompareT));%in mm
                [sloBars,  mapSLO, isHScan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans,thicknessTotal);
                mapSLO_interp = interpolateEnface(double(mapSLO));
                
                
                %place as either H or V scan depending on header
                %create save structure "subject"
                subject.BoundaryLoc = boundariesLocMM;
                if(isHScan)
                    subject.HScanHeader = header;
                    subject.HScanBScanHeader = BScanHeader;
                    HScanSLO=slo;
                    subject.HScanSLO=slo;
                    subject.HScanThicknessMap = thicknessTotal;
                    subject.HScanBScansLocOnSLO = sloBars;
                    subject.HScanThicknessOnSLO = mapSLO;
                    subject.HScanThicknessOnSLOInterp = mapSLO_interp;
                    
                    subject.HScanLayerThicknessMaps = thicknessAllLayers;
                    subject.HScanLayerThicknessMapsOnSLO = thicknessAllLayersOnSLO;
                    subject.HScanLayerThicknessMapsOnSLOInterp = thicknessAllLayersOnSLOInterp;
                    
                    subject.HScanLayerMeanIntensityMaps = LayerMeanIntensityMaps;
                    subject.HScanLayerMeanIntensityMapsOnSLO = LayerMeanIntensityMapsOnSLO;
                    subject.HScanLayerMeanIntensityMapsOnSLOInterp = LayerMeanIntensityMapsOnSLOInterp;
                    
                    HScanBScans=BScans;%don't save this, but need as input later
                else
                    subject.VScanHeader = header;
                    subject.VScanBScanHeader = BScanHeader;
                    VScanSLO=slo;
                    subject.VScanSLO=slo;
                    subject.VScanThicknessMap = thicknessTotal;
                    subject.VScanBScansLocOnSLO = sloBars;
                    subject.VScanThicknessOnSLO = mapSLO;
                    subject.VScanThicknessOnSLOInterp = mapSLO_interp;
                    
                    subject.VScanLayerThicknessMaps = thicknessAllLayers;
                    subject.VScanLayerThicknessMapsOnSLO = thicknessAllLayersOnSLO;
                    subject.VScanLayerThicknessMapsOnSLOInterp = thicknessAllLayersOnSLOInterp;
                    
                    subject.VScanLayerMeanIntensityMaps = LayerMeanIntensityMaps;
                    subject.VScanLayerMeanIntensityMapsOnSLO = LayerMeanIntensityMapsOnSLO;
                    subject.VScanLayerMeanIntensityMapsOnSLOInterp = LayerMeanIntensityMapsOnSLOInterp;
                end
                
            end
            
            %once we've figured out which scan is which, now register
            [optimizer, metric] = imregconfig('monomodal');
            
            %first we bandpass filter the SLO images
            HScanSLO=butterworthbpf(HScanSLO,10,1000,1);
            VScanSLO=butterworthbpf(VScanSLO,10,1000,1);
            
            %register
            [tform] =  imregtform(VScanSLO, HScanSLO, 'rigid', optimizer, metric);
            
            %apply transformation to SLO
            subject.RegisteredVScanBScansLocOnSLO = imwarp(subject.VScanBScansLocOnSLO,tform,'OutputView',imref2d(size(subject.HScanSLO)));
            [sloBars_combined, ~] = OCTBarsOnSLO(subject.RegisteredVScanBScansLocOnSLO,subject.HScanHeader,subject.HScanBScanHeader ,HScanBScans,subject.HScanThicknessOnSLOInterp);
            subject.BothBScansLocOnSLO = sloBars_combined;

            %apply transformation to all layer thickness alignments
            subject.RegisteredVScanLayerThicknessesOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            subject.BothMeanLayerThicknessesOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            subject.BothAbsLayerThicknessesDiffOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            
            for l = 1:LN
                [RegisteredVScan,BothMean,BothAbsDiff] = alignHandVscans(subject.VScanLayerThicknessMapsOnSLOInterp(:,:,l),subject.HScanLayerThicknessMapsOnSLOInterp(:,:,l),tform);
                subject.RegisteredVScanLayerThicknessesOnSLOInterp(:,:,l) = RegisteredVScan;
                subject.BothMeanLayerThicknessesOnSLOInterp(:,:,l) = BothMean;
                subject.BothAbsLayerThicknessesDiffOnSLOInterp(:,:,l) = BothAbsDiff;
            end
            
            %calc the mean intensity
            subject.RegisteredVScanLayerMeanIntensityMapsOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            subject.BothMeanLayerMeanIntensityMapsOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            subject.BothAbsLayerMeanIntensityMapsDiffOnSLOInterp = zeros(size(HScanSLO,1),size(HScanSLO,1),LN);
            
            for l = 1:LN
                [RegisteredVScan,BothMean,BothAbsDiff] = alignHandVscans(subject.VScanLayerMeanIntensityMapsOnSLOInterp(:,:,l),subject.HScanLayerMeanIntensityMapsOnSLOInterp(:,:,l),tform);
                subject.RegisteredVScanLayerMeanIntensityMapsOnSLOInterp(:,:,l) = RegisteredVScan;
                subject.BothMeanLayerMeanIntensityMapsOnSLOInterp(:,:,l) = BothMean;
                subject.BothAbsLayerMeanIntensityMapsDiffOnSLOInterp(:,:,l) = BothAbsDiff;
            end
            
            %apply transformation to total thickness alignment
           [RegisteredVScan,BothMean,BothAbsDiff] = alignHandVscans(subject.VScanThicknessOnSLOInterp,subject.HScanThicknessOnSLOInterp,tform);
           subject.RegisteredVScanThicknessOnSLOInterp = RegisteredVScan;
           subject.BothMeanThicknessOnSLOInterp = BothMean;
           subject.BothAbsThicknessDiffOnSLOInterp = BothAbsDiff;

            
            %save the subject (this file is pretty big)
            mkdir(fullfile(outDir,num2str(subject.ID)));
            save(saveName,'subject','-v7.3');
        end
    end
end