
x=-1:.01:1;
z=-1:.01:1;

[X,Z] = meshgrid(x,z);
Y_All = zeros(size(X));

savePath4 = fullfile(outDir,'CenteredFovea_surf.Gif');
%startGifRecording(4, savePath4);

for f = 2:41
   currPt = allFoveas{f};
   Y = griddata(currPt.Location(:,1),currPt.Location(:,3),currPt.Location(:,2),X,Z);
%   surf(X,Z,Y)
%   appendGifRecording(4, savePath4)
   
   Y_All = Y_All+Y;
end

Y_All = Y_All/(41-2+1);

surf(X,Z,Y_All)
