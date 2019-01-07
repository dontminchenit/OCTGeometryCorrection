inDir  = 'C:\Users\dontm\Documents\ResearchResults\OCTGeometryCorrection\2DThicknessMaps_10_15_2018';

AllSubIDs = dir(fullfile(inDir,'1*'));
for i = 32%1:length(AllSubIDs)

    subjectFile = dir(fullfile(inDir,AllSubIDs(i).name,'*.mat'));
    
    for j = 1:length(subjectFile)
    load(fullfile(inDir,AllSubIDs(i).name,subjectFile(j).name));
    
    outDir = fullfile(inDir,AllSubIDs(i).name,subject.eyeSide);
    mkdir(outDir);
    
    subjectProp=fieldnames(subject);
    for p=1:numel(subjectProp)
 
       obj = subject.(subjectProp{p});
       objname = subjectProp{p};
       if(isnumeric(obj))
           if(length(size(obj)) == 2 && size(obj,1) > 1 && size(obj,2) > 1)
               
               h=figure(1);
               imshow(obj)
               caxis([min(obj(:)) max(obj(:))]);
               if (isa(obj,'double'))
                  colorbar
               else
                  colormap('gray')
               end
               
               saveas(h,fullfile(outDir,[num2str(subject.ID) '_' subject.eyeSide '_' objname '.jpg']));
           end
       end
    end
    end
end