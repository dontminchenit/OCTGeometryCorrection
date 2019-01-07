origDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_data\connectomeRetinaData\';
inDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\FullProcess';
ids = dir(inDir);
eyeSide = {'OD', 'OS'};
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\Analysis_3_8_2018';


for i = 1:length(ids)
    i
    if(~strcmp(ids(i).name,'.') && ~strcmp(ids(i).name,'..'))
        id = ids(i).name;
        for e = 1:2
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
                        volFn_v = fn; 
                        map_v = ilmBnd;
                    else
                        ilmBnd = matfile.bd_pts(:,:,1)';
                        volFn_h = fn;
                        map_h = ilmBnd'; 
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
                    saveas(fig,fullfile(outDir,[id '_' eyeSide{e} '_ILMmap.png']));
                end
            end
              fig2 = plotBndDiff(volFn_v, volFn_h, map_v, map_h);
              saveas(fig2,fullfile(outDir,[id '_' eyeSide{e} '_Comparemap.png']));
        end
    end
    
    
end

