function [Xo,dis] = shortest_distance( X, axis )
%
% The shortest distance from a point to Triaxial Ellipsoid or Biaxial Ellipsoid or Sphere
%
%   (x/a)^2+(y/b)^2+(z/c)^2=1   Triaxial Ellipsoid Equation centered at the
%   origin
%    
%
% Parameters:
% * X, [x y z]     - Cartesian coordinates data, n x 3 matrix or three n x 1 vectors
% * axis,[a; b; c] - ellipsoid radii  [a; b; c],its axes % along [x y z] axes
%  
%                  For Triaxial ellipsoid ,it must be a > b > c
%
%                  For Biaxial ellipsoid ,it must be a = b > c
%
%                  For Sphere ,it must be a = b = c
%
% Output:
% * Xo,[xo yo zo]   -  Cartesian coordinates of Point onto ellipsoid 
% 
%
% Author:
% Sebahattin Bektas, 19 Mayis University, Samsun
% sbektas@omu.edu.tr

format long
ro=180/pi; % converter Degree to radian
eps=0.0001; % three sholder
a=axis(1);b=axis(2);c=axis(3);
   
x=X(1);y=X(2);z=X(3);
   

%display(' ******** a             b                 c                semi axis')
%fprintf(' %15.4f %15.4f %15.4f   \n',a,b,c)


 %display(' C A R T E S i A N     C O O R D i N A T E S         ')   
%display('X                     Y                           Z         ')
 %fprintf('  %15.4f %15.4f %15.4f    \n',x,y,z) 

E=1/a^2;F=1/b^2;G=1/c^2;
E=sign(a)/a^2;F=sign(b)/b^2;G=sign(c)/c^2;
xo=a*x/sqrt(x^2+y^2+z^2);
yo=b*y/sqrt(x^2+y^2+z^2);
zo=c*z/sqrt(x^2+y^2+z^2);
xo=x;yo=y;zo=z;% deneme
%xo,yo,zo
for i=1:20
j11=F*yo-(yo-y)*E;
j12=(xo-x)*F-E*xo;

j21=G*zo-(zo-z)*E;
j23=(xo-x)*G-E*xo;

A=[ j11   j12   0 
    j21   0   j23
    2*E*xo    2*F*yo  2*G*zo  ];

sa=(xo-x)*F*yo-(yo-y)*E*xo;
sb=(xo-x)*G*zo-(zo-z)*E*xo;
se=E*xo^2+F*yo^2+G*zo^2-1;
Ab=[ sa  sb  se]';
bil=-A\Ab;
xo=xo+bil(1);
yo=yo+bil(2);
zo=zo+bil(3);
%xo,yo,zo
%fprintf('%5d %18.4f %18.4f %18.4f %8.4f %8.4f %8.4f  \n',i,xo,yo,zo,bil(1),bil(2),bil(3))
if max(abs(bil))<eps
    break
end
end
% display(' C A R T E S  A N     C O O R D  N A T E S  on ELLPSODAL SURFACE       ')   
% display('Xo                     Yo                           Zo         ')
% fprintf('  %15.4f %15.4f %15.4f    \n',xo,yo,zo) 

 
dis=sign(zo-z)*sign(zo)*sqrt((x-xo)^2+(y-yo)^2+(z-zo)^2);

Xo=[xo  yo  zo];

end