inDir = 'C:\Users\dontm\Dropbox (Aguirre-Brainard Lab)\AOSO_data\connectomeRetinaData\';
outDir = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\FullProcess';
ids = dir(inDir);
eyeSide = {'OD', 'OS'};

for i = 1:length(ids)
    i
    if(~strcmp(ids(i).name,'.') && ~strcmp(ids(i).name,'..'))
        id = ids(i).name;
        
        if(isdir(fullfile(inDir,id)))
            mkdir(fullfile(outDir,id));
            
            for e = 1:2%do for both eye
                subOutDir = fullfile(outDir,id,eyeSide{e});
                mkdir(subOutDir);
                subInDir = fullfile(inDir,id,'HeidelbergSpectralisOCT',eyeSide{e});
                fns = dir(fullfile(subInDir,'*.vol'));
                
                for f = 1:length(fns)
                    fn = fullfile(subInDir,fns(f).name);
                    [header, BScanHeader, slo, BScans] = openVolFast(fn);
                    
                    dim = size(BScans);
                    if(length(dim) == 3)
                        if(dim(3) > 40)
                         [boundaries_h, img_vol_h] = quickSegmentOCT(fn,subOutDir);
                        end
                    end
                end
            end
            
        end
    end
end

