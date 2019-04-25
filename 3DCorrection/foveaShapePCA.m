x=-1:.1:1;
z=-1:.1:1;

[X,Z] = meshgrid(x,z);
mkdir(outDir)
savePath4 = fullfile(outDir,'CenteredFovea_surf.Gif');
startGifRecording(4, savePath4);
counter = 1;
%allSurfacesValid_in = allSurfacesOrig_in;
allSurfacesValid_in = allSurfacesCorrected_in;

%allSurfacesValid_in(1) = [];
%allSurfacesValid_out = allSurfacesOrig_out;
%allSurfacesValid_out(1) = [];

%allSurfacesValid_in=allSurfacesValid;

N = length(allSurfacesValid_in);
%Y_All = zeros(N,2*length(X(:)));

Y_All = zeros(N,length(X(:)));
for f = 1:N
   currPc_in = allSurfacesValid_in{f};
   [currPc2_in, tform, modelReorient] = rotateFoveaPlane(currPc_in);

%   currPc_out = pctransform(allSurfacesValid_out{f},tform);
   
   Y_in = griddata(currPc_in.Location(:,1),currPc_in.Location(:,3),currPc_in.Location(:,2),X,Z);
   % Y_out = griddata(currPc_out.Location(:,1),currPc_out.Location(:,3),currPc_out.Location(:,2),X,Z);

   clf
   surf(X,Z,Y_in)
   hold on 
%   surf(X,Z,Y_out)
 
    plot(modelReorient);
    setDisplayViews
    view(-60,10)
   appendGifRecording(4, savePath4)
   
%   Y_All(counter,:) = [Y_in(:); Y_out(:)] ;
   Y_All(counter,:) = [Y_in(:)] ;

   counter = counter+1;
end

[coeff1,score1,latent,tsquared,explained,mu1] = pca(Y_All);

%[coeff1,score1,latent,tsquared,explained,mu1] = pca(Y_All,'algorithm','als');

%Y_All = Y_All/(41-2+1);

%surf(X,Z,Y_All)
