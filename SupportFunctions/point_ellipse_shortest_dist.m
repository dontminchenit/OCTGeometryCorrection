function dist_all = point_ellipse_shortest_dist(x, y, z, x_r, y_r, z_r)
% Point to plane shortest distance vector
% The plane is defined by: ax+by+cz+d = 0
% The point is defined by: x, y, and z

%dist = (a*x+b*y+c*z+d) / sqrt(a^2+b^2+c^2);
y = y - 7.5*ones(size(y));
X=[x z y];

axis=[x_r;z_r;y_r];

dist_all = zeros(length(x),1); 
for i = 1:length(x)
[Xo,dist] = shortest_distance(X(i,:), axis);
dist_all(i) = dist;
end
end
