function h = draw_plane(A, B, C, D, color, alpha, length)
% Draw planes defined by: Ax + By + Cz + D = 0
% color is the color of the plane
% alpha is the transparency factor
% length is the projected length of the plane: from -length to length


if nargin < 7
    length = 1;
    color = 'g';
    alpha = 0.5;
elseif nargin < 6
    color = 'g';
    alpha = 0.5;
elseif nargin < 5
    alpha = 0.5;
end        


x = [length -length -length length]; 
y = [length length -length -length]; 
z = -1/C*(A*x + B*y + D); 

if any(isinf(z) == 1)
    x = [length -length -length length];
    z = [length length -length -length]; 
    y = -1/B*(A*x + C*z + D); 
end

if any(isinf(y) == 1)
    y = [length -length -length length]; 
    z = [length length -length -length]; 
    x = -1/A*(B*y + C*z + D);
end
    
h = fill3(x, y, z, color);

xlabel('x');
ylabel('y');
zlabel('z');

set(h,'facealpha', alpha)

end