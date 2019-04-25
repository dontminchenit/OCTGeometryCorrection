function startGifRecording(figNum, SavePath)


h=figure(figNum);
%clf
%hold on

frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 
% Write to the GIF File 
imwrite(imind,cm,SavePath,'gif', 'DelayTime', 0.5,'Loopcount',inf); 