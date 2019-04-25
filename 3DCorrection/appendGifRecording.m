function appendGifRecording(figNum, SavePath)

h = figure(figNum);
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,SavePath,'gif','DelayTime', 0.1,'WriteMode','append');