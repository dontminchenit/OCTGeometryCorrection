
% Put the toolbox and dependencies on the path
%tbUse('gkaModelEye');

% Create a model eye structure. Can also specify by axial length:
	eye = modelEyeParameters('axialLength',27.52,'eyeLaterality','Left');
%eye = modelEyeParameters('sphericalAmetropia',-2);

% Get radii of the vitreous chamber ellipsoid. These are in mm and in the
% order of axial depth, horizonal width, and vertical height
radii = quadric.radii(eye.retina.S);
center = quadric.center(eye.retina.S);

% If you like, you can calculate the distance of the posterior vertex of
% the retinal surface from an approximation of the nodal point of the eye.

% This value taken from the Gullstrand-Elmsley eye relative to the corneal
% apex.
nodalPointDepth = -7.2;

% This is the distance of the nodal point to the posterior apex of the
% retina
distanceNodalPointToRetina = nodalPointDepth - center(1) + radii(1);
