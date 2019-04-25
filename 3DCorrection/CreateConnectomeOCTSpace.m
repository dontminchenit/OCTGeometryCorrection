%set inputs
addpath(genpath('C:\Users\dontm\Dropbox (Personal)\Research\Projects\OCTGeometryCorrection'));
inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_analysis\OCTExplorerSegmentationData';
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\ShapeAnalysis_MICCAI2019';
nodalDistxls = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\ConnectomeAnalysis_1_14_2019\NodalDistance.xlsx';
[nodalData, ~, ~]=xlsread(nodalDistxls);
mkdir(outDir);
AllSubIDs = dir(fullfile(inDir,'1*'));

savePath1 = fullfile(outDir,'Centered.Gif');
savePath2 = fullfile(outDir,'nonCentered.Gif');
savePath3 = fullfile(outDir,'CenteredFovea.Gif');


%startGifRecording(3, savePath3);
%startGifRecording(2, savePath2);

%allSurfaces = cell(1,length(AllSubIDs));
%allFoveas = cell(1,length(AllSubIDs));

%allSurfaces_in = cell(1,length(AllSubIDs));
%allSurfaces_out = cell(1,length(AllSubIDs));
%allSubjectsInfo = cell(1,length(AllSubIDs));

for e = 1%:2
    for f = 1%2:length(AllSubIDs)
        if (e == 1)
            eyeSide = 'OD';
        else
            eyeSide = 'OS';
        end
        f
        subID = str2double(AllSubIDs(f).name);
        subDir = fullfile(inDir,AllSubIDs(f).name,eyeSide);
        
        %         if (subID == 11092)
        %            continue
        %         end
        
        %         saveName = fullfile(outDir,num2str(ID),[num2str(ID) '_' eyeSide '.mat']);
        %         if exist(saveName,'file')
        %             disp([AllSubIDs(f).name '(' subject.eyeSide ') already processed. Skipping.' ])
        %             continue
        %         end
        
        %Load H and V scan for all subjects
        subject = loadAndPreprocessOCTData(subDir,subID,eyeSide,1);
        
        %Determine model parameters for all subjects
        
        %pull nodal distance from Spreadsheet
        ind = find(nodalData(:,1) == subID);
        subject.NodalDistance = nodalData(ind,2);
        
        %
        
        OCTScan = subject.VScan;
        
        %Set Model Parameters
        OCTEdges_Inner = OCTScan.OCTEdges_Inner;
        OCTEdges_Outer = OCTScan.OCTEdges_Outer;
        
        Angles = [0 0];
        NodalLoc = [0 0 0];
        R = subject.NodalDistance - OCTScan.FoveaDepth*OCTScan.Resolution(1);
        Resolution = OCTScan.Resolution;
        foveaLocIndex = sub2ind(size(OCTScan.BScans),OCTScan.FoveaDepth,OCTScan.FoveaLoc(1),OCTScan.FoveaLoc(2));
        
        %reconstruct geometry
        [xyzPointCloudCorrectedCentered_in,foveaLocCorrectedCentered,NodalLocCentered,xyzPointCloudCorrected,foveaLocCorrected] ...
            = fixOCTGeometryFoveaCentered(OCTEdges_Inner,Angles,NodalLoc,R,Resolution,foveaLocIndex);
        [xyzPointCloudCorrectedCentered_out,foveaLocCorrectedCentered,NodalLocCentered,xyzPointCloudCorrected,foveaLocCorrected] ...
            = fixOCTGeometryFoveaCentered(OCTEdges_Outer,Angles,NodalLoc,R,Resolution,foveaLocIndex);
        %[xyzPointCloud_out,foveaLocCorrected_out] = fixOCTGeometryFoveaCentered(OCTEdges_Outer,Angles,Center,R,Res,foveaLocIndex);
        
        
        [xyzPointCloudOrigCentered_in,xyzPointOrigCloud_in] = OCTtoPointCloud(OCTEdges_Inner,Resolution,foveaLocIndex);
        [xyzPointCloudOrigCentered_out,xyzPointOrigCloud_out] = OCTtoPointCloud(OCTEdges_Outer,Resolution,foveaLocIndex);
         
         
        currColor = rand(1,3);
        %         figure(1)
        %         hold on
        %         pcshow(xyzPointCloudCorrectedCentered.Location,currColor);
        %         pts = [foveaLocCorrectedCentered; NodalLocCentered];
        %         plot3(pts(:,1), pts(:,2), pts(:,3),'Color', currColor,'MarkerEdgeColor',currColor,'Marker','o')
        %         %pcshow(xyzPointCloud_out.Location,'b');
        %         appendGifRecording(1, savePath1)
        %
        %         figure(2)
        %         hold on
        %         pcshow(xyzPointCloudCorrected.Location,currColor);
        %         pts = [foveaLocCorrected; NodalLoc];
        %         plot3(pts(:,1), pts(:,2), pts(:,3),'Color', currColor,'MarkerEdgeColor',currColor,'Marker','o')
        %         appendGifRecording(2, savePath2)
        %
        
        
        %  figure(3)
        %  hold on
        
        %   ROI = [-1,1;-1,1;-1,1];
        %   indices=findPointsInROI(xyzPointCloudCorrectedCentered_in,ROI);
        %   xyzPointCloudCorrectedCenteredFovea = select(xyzPointCloudCorrectedCentered_in,indices);
        
        %   pcshow(xyzPointCloudCorrectedCenteredFovea.Location,currColor);
        %        pts = [foveaLocCorrectedCentered; NodalLocCentered];
        %         plot3(pts(:,1), pts(:,2), pts(:,3),'Color', currColor,'MarkerEdgeColor',currColor,'Marker','o')
        %pcshow(xyzPointCloud_out.Location,'b');
        %         appendGifRecording(3, savePath3)
        
        
        %         allFoveas{f} = xyzPointCloudCorrectedCenteredFovea;
        
        %Point cloud representations of inner and outer surfaces
        allSurfacesCorrected_in{f} = xyzPointCloudCorrectedCentered_in;
        allSurfacesCorrected_out{f} = xyzPointCloudCorrectedCentered_out;

        allSurfacesOrig_in{f} = xyzPointCloudOrigCentered_in;
        allSurfacesOrig_out{f} = xyzPointCloudOrigCentered_out;

        
        %save lighweight version of Subject
        %Create a lightweight version of the structure
        
        subjectSmall = subject;
        
        subjectSmall.HScan.BScans =[];
        subjectSmall.HScan.SegVol =[];
        subjectSmall.HScan.OCTEdges_Inner =[];
        subjectSmall.HScan.OCTEdges_Outer =[];
        subjectSmall.HScan.OCTEdges_Both =[];
        subjectSmall.VScan.BScans =[];
        subjectSmall.VScan.SegVol =[];
        subjectSmall.VScan.OCTEdges_Inner =[];
        subjectSmall.VScan.OCTEdges_Outer =[];
        subjectSmall.VScan.OCTEdges_Both =[];
        allSubjectsInfo{f} = subjectSmall;
        
    end
end

save(fullfile(outDir,'all_outputs.mat'),'allSubjectsInfo','allSurfacesCorrected_in',...
    'allSurfacesCorrected_out','allSurfacesOrig_in','allSurfacesOrig_out','-v7.3');








%reconstruct with scan geometry and plot

