origDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_data\connectomeRetinaData\';
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\FeatureMatch_3_12_2018';
inDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\FullProcess';
ids = 11072;
eyeSide = {'OD'};


id = num2str(11072);
        for e = 1
            subInDir = fullfile(inDir,id,eyeSide{e});
            scans = dir(subInDir);
            fig= figure(1);clf
            counter = 1;
            
            for ii = 1:length(scans)
                scans_ii = scans(ii).name;
                if(~strcmp(scans_ii,'.') && ~strcmp(scans_ii,'..'))
                    subplot(1,length(scans)-2,counter);
                    matfile = load(fullfile(subInDir,scans_ii,[scans_ii '_result.mat']));
                    
                    subOrigDir = fullfile(origDir,id,'HeidelbergSpectralisOCT',eyeSide{e});
                    fn = fullfile(subOrigDir,[scans_ii '.vol']);
                    [header, BScanHeader, slo, BScans] = openVolFast(fn);
                    
                    if(BScanHeader.StartX(1) == BScanHeader.EndX(1))
                        ilmBnd = matfile.bd_pts(:,:,1);
                        enface_v=matfile.bd_pts(:,:,6)-matfile.bd_pts(:,:,5);
                        totalThickness_v=matfile.bd_pts(:,:,9)-matfile.bd_pts(:,:,1);
                        volFn_v = fn; 
                        map_v = ilmBnd;
                        slov_v = slo;
                        BScans_v = BScans;
                    else
                        ilmBnd = matfile.bd_pts(:,:,1)';
                        enface_h=matfile.bd_pts(:,:,6)-matfile.bd_pts(:,:,5);
                        totalThickness_h=matfile.bd_pts(:,:,9)-matfile.bd_pts(:,:,1);
                        enface_h = enface_h';
                        volFn_h = fn;
                        map_h = ilmBnd';
                        slov_h = slo;
                        BScans_h = BScans;
                    end
                    
                    matfile.header
                    imagesc(ilmBnd)
                    caxis([0 200]);
%                    caxis([min(ilmBnd(:)) max(ilmBnd(:))])
                    colorbar
                    counter=counter+1;
                    if(BScanHeader.StartX(1) == BScanHeader.EndX(1))
                        xlabel('Vertical Scan');
                    else
                        xlabel('Horizontal Scan');
                    end
               %     saveas(fig,fullfile(outDir,[id '_' eyeSide{e} '_ILMmap.png']));
                end
            end
            %  [fig,sloBars_v_reg,sloBars_h,mapSLO_v_interp_reg,mapSLO_h_interp,tform] = plotBndDiff(volFn_v, volFn_h, map_v, map_h);
              %saveas(fig2,fullfile(outDir,[id '_' eyeSide{e} '_Comparemap.png']));
        end
    
