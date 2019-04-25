function [subject] = loadAndPreprocessOCTData(inDir,subID,eyeSide,rescaleFactor)

%Create Output Object
subject = struct;

%Basic Information
subject.InputFilesDir = inDir;
subject.ID = subID;
subject.eyeSide = eyeSide;

%LN = 11; %number of layers in segmentation image

subVolFiles = dir(fullfile(inDir,'*.vol'));

%Quick check that there is both a Horizontal and Vertical Scan
if(length(subVolFiles) ~= 2 )
    disp(['Wrong number of OCT vol files for Subject ID ' num2str(subID)]);
else%assign to
    
    for s=1:2%first load each indidivdually
        %load OCT
        volFilePath = fullfile(inDir,subVolFiles(s).name);
        [header, BScanHeader, slo, BScans] = openVolFast(volFilePath,'nodisp');
        BScansTop = BScans;
        BScansTop(BScansTop<=1) = 0;
        BScans(BScans>1) = 0;
        %  OrigBScans = BScans;
        BScans= BScans.^.25;
        
        %load Segmentations
        segFilePath = fullfile(inDir,[subVolFiles(s).name(1:end-4) '_Surfaces_Retina-JEI-Final.mat']);
        segFile = open(segFilePath);
        
        segVol = permute(segFile.mask,[3 1 2]);
        segVol= rot90(segVol,2);
        
        if(rescaleFactor ~= 1)
            BScans = imresize3(BScans,rescaleFactor);
            segVol = imresize3(segVol,rescaleFactor);
        end
        
        %find resolution and dimensions of OCT scan
        res = [header.ScaleZ header.ScaleX header.Distance]; %[resOfAscan resBetweenAscans resBetweenBscans]
        dim = size(segVol); %[#ofPixelinAscans #ofAscansInBscan #Bscans]
        
        %find the depth of the inner and outer surfaces (in pixels)
        depthmap_inner = zeros(dim(2),dim(3));
        depthmap_isos = zeros(dim(2),dim(3));
        depthmap_outer = zeros(dim(2),dim(3));
        
        %create volumes with inner and outter surface edges
         OCTEdges_inner = zeros(size(segVol));
         OCTEdges_outer = zeros(size(segVol));
        
        for i = 1:dim(2)
            for j = 1:dim(3)
                %find depth
                depthmap_inner(i,j)=find(segVol(:,i,j)>0,1,'first');
                depthmap_isos(i,j)=find(segVol(:,i,j)>=7,1,'first');
                depthmap_outer(i,j)=find(segVol(:,i,j)>0,1,'last');
                %set surface locations
                OCTEdges_inner(depthmap_inner(i,j),i,j) = 1;
                OCTEdges_outer(depthmap_outer(i,j),i,j) = 1;
            end
        end
        
        
       OCTEdges_Both = OCTEdges_inner+OCTEdges_outer;%both inner and outer edges;
        
        
        %find fovea pixel location and depth in the image
        foveaLoc = foveaFinder(depthmap_outer-depthmap_inner,res(2:3));
        foveaDepth = depthmap_inner(foveaLoc(1),foveaLoc(2));
        
        %find Enface image
        enface =findenface(BScans,depthmap_isos,depthmap_outer);
        
        %Collect all scan properties into an object
        OCTScan.Header = header;
        OCTScan.BScanHeader = BScanHeader;
        OCTScan.SLO=slo;
        OCTScan.BScans=BScans;%don't save this, but need as input later
        %     OCTScan.BScansTop =  BScansTop;
        OCTScan.SegVol = segVol;
        OCTScan.SurfDepthMap_Inner = depthmap_inner;
        OCTScan.SurfDepthMap_Outer = depthmap_outer;
        OCTScan.FoveaLoc = foveaLoc;
        OCTScan.FoveaDepth = foveaDepth;
        OCTScan.Resolution = res;
        OCTScan.Dimensions = dim;
        OCTScan.VolFilePath = volFilePath;
        OCTScan.SegVolFilePath = segFilePath;
        OCTScan.Enface = enface;
        OCTScan.OCTEdges_Inner = OCTEdges_inner;
        OCTScan.OCTEdges_Outer = OCTEdges_outer;
        OCTScan.OCTEdges_Both = OCTEdges_Both;
        
        
        %use header to check if scan is H or V scan;
        [~, ~, isHScan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans);
        
        %place as either H or V scan depending on header
        if(isHScan)
            subject.HScan = OCTScan;
        else
            subject.VScan = OCTScan;
        end
    end
end




