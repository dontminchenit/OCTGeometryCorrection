%generate3Dmodels
%load data
addpath(genpath('C:\Users\dontm\Dropbox (Personal)\Research\Projects\OCTGeometryCorrection'));
inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_analysis\OCTExplorerSegmentationData';
LN = 11; %number of layers in segmentation image

AllSubIDs = dir(fullfile(inDir,'1*'));

validIDs = [11015];
validIDeye = [1];

hgaps = zeros(length(AllSubIDs),ZN);
vgaps = zeros(length(AllSubIDs),ZN);
      

for e = 1%:2
    for f = 2:length(AllSubIDs)
        subject = struct;
        if (e == 1)
            subject.eyeSide = 'OD';
        else
            subject.eyeSide = 'OS';
        end
        subject.ID = str2double(AllSubIDs(f).name)
        subDir = fullfile(inDir,AllSubIDs(f).name,subject.eyeSide);
        
        valid = find(validIDs == subject.ID);
        f
        if(isempty(valid) || validIDeye(valid) ~= e)
            %continue
        end
        
        %        saveName = fullfile(outDir,num2str(subject.ID),[num2str(subject.ID) '_' subject.eyeSide '.mat']);
        %         if exist(saveName,'file')
        %            disp([AllSubIDs(i).name '(' subject.eyeSide ') already processed. Skipping.' ])
        %            continue
        %         end
        %Align using SLO
        subVolFiles = dir(fullfile(subDir,'*.vol'));
        
        if(length(subVolFiles) ~= 2 )
            disp(['Wrong number of OCT vol files for Subject ID ' AllSubIDs(f).name]);
        else%assign to
            
            for s=1:2%first load each indidivdually
                [header, BScanHeader, slo, BScans] = openVolFast(fullfile(subDir,subVolFiles(s).name));%,'nodisp');
                BScansTop = BScans;
                BScansTop(BScansTop<=1) = 0;
                BScans(BScans>1) = 0;
                OrigBScans = BScans;
                %BScans= imresize3(BScans,.5).^.25;
                segfilename = fullfile(subDir,[subVolFiles(s).name(1:end-4) '_Surfaces_Retina-JEI-Final.mat']);
                segFile = open(segfilename);
                
                segVol = permute(segFile.mask,[3 1 2]);
                %segVol = permute(imresize3(segFile.mask,.5),[3 1 2]);
                segVol= rot90(segVol,2);
                
                [sloBars,  mapSLO, isHScan] = OCTBarsOnSLO(slo,header,BScanHeader,BScans);
                
                %place as either H or V scan depending on header
                if(isHScan)
                    headerH = header;
                    BScanHeaderH = BScanHeader;
                    sloH=slo;
                    BScansH=BScans;%don't save this, but need as input later
                    BScansHTop =  BScansTop;
                    octSurfH = segFile;
                    OCTinH = segVol;
                    OCTEdgesH_inner = zeros(size(OCTinH));
                    OCTEdgesH_outer = zeros(size(OCTinH));
                    
                    
                else
                    headerV = header;
                    BScanHeaderV = BScanHeader;
                    sloV=slo;
                    BScansV=BScans;%don't save this, but need as input later
                    BScansVTop =  BScansTop;
                    octSurfV = segFile;
                    OCTinV = segVol;
                    OCTEdgesV_inner = zeros(size(OCTinV));
                    OCTEdgesV_outer = zeros(size(OCTinV));
                    
                end
            end
            %set header information
            YN=size(OCTinV,1);
            XN=size(OCTinV,2);
            ZN=size(OCTinV,3);
            %xResV = headerV.ScaleX;
            %yResV = headerV.ScaleZ;
            %zResV = headerV.Distance;
            %xResH = headerH.ScaleX;
            %yResH = headerH.ScaleZ;
            %zResH = headerH.Distance;
            
            %find the depthmap
            vmap_inner = zeros(XN,ZN);
            hmap_inner = zeros(XN,ZN);
            vmap_outer = zeros(XN,ZN);
            hmap_outer = zeros(XN,ZN);
            
      
            
            for i = 1:XN
                for j = 1:ZN
                    vmap_inner(i,j)=min(find(OCTinV(:,i,j)>0));
                    hmap_inner(i,j)=min(find(OCTinH(:,i,j)>0));
                    vmap_outer(i,j)=max(find(OCTinV(:,i,j)>0));
                    hmap_outer(i,j)=max(find(OCTinH(:,i,j)>0));
                    
                    top = find(BScansHTop(:,i,j)<1,1,'first');
                    bot = find(BScansHTop(:,i,j)<1,1,'last');
                    if(~isempty(top) && ~isempty(bot))
                        if(top >= 1 && bot == YN)
                            hgaps(f,j) = hgaps(f,j) + double(top)/XN;
                        elseif(top == 1 && bot <= YN)
                            hgaps(f,j) = hgaps(f,j) + double(bot - YN)/XN;
                        end
                    end
                    
                    top = find(BScansVTop(:,i,j)<1,1,'first');
                    bot = find(BScansVTop(:,i,j)<1,1,'last');
                    if(~isempty(top) && ~isempty(bot))
                        if(top >= 1 && bot == YN)
                            vgaps(f,j) = vgaps(f,j) + double(top)/XN;
                        elseif(top == 1 && bot <= YN)
                            vgaps(f,j) = vgaps(f,j) + double(bot - YN)/XN;
                        end
                    end
                    
                    
                end
            end
            
%             for i = 1:size(OCTinV,2)
%                 for j = 1:size(OCTinV,3)
%                     OCTEdgesV_inner(vmap_inner(i,j),i,j) = 1;
%                     OCTEdgesH_inner(hmap_inner(i,j),i,j) = 1;
%                     OCTEdgesV_outer(vmap_outer(i,j),i,j) = 1;
%                     OCTEdgesH_outer(hmap_outer(i,j),i,j) = 1;
%                     
%                 end
%             end
%             
%             OCTEdgesV_Both = OCTEdgesV_inner+OCTEdgesV_outer;
%             OCTEdgesH_Both = OCTEdgesH_inner+OCTEdgesH_outer;
            
            
        end
    end
end




