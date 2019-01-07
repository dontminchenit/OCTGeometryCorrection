function [X_t,Y_t] = transformMesh(X,Y,T)

N = length(X(:));

X_t = X;
Y_t = Y;

theta = 90; % to rotate 90 counterclockwise
%T = [cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; 0 0 1];
for i = 1:N
   
    c = [X(i); Y(i) 1]*T;
    X_t(i) = c(1);
    Y_t(i) = c(2);
  
    
end

