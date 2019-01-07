function v = point_plane_shortest_dist_vec(x, y, z, a, b, c, d)
% Point to plane shortest distance vector
% The plane is defined by: ax+by+cz+d = 0
% The point is defined by: x, y, and z

dist = (a*x+b*y+c*z+d) / sqrt(a^2+b^2+c^2);
N = [a; b; c]/norm([a; b; c]);
v = N.*dist;

end
