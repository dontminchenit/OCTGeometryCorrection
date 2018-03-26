%[fig,sloBars_v_reg,sloBars_h,mapSLO_v_interp_reg,mapSLO_h_interp,slo_v_reg,tform] = plotBndDiff(volFn_v, volFn_h, enface_v, enface_h');


%[fig,sloBars_v_reg,sloBars_h,mapSLO_v_interp_reg,mapSLO_h_interp,tform] = plotBndDiff(volFn_v, volFn_h, totalThickness_v, totalThickness_h);

mask = double((mapSLO_v_interp_reg>0) & (mapSLO_h_interp>0));

Imoving = mapSLO_v_interp_reg.*mask;
Istatic = mapSLO_h_interp.*mask;

Imoving_slo = double(slo_v_reg).*mask;
Istatic_slo = double(slov_h).*mask;


[Ireg,Bx,By,Fx,Fy] = register_images(Imoving,Istatic,struct('Similarity','p'));


  % Show the registration result
  figure,
  subplot(2,2,1), imshow(Imoving); title('moving image'); caxis([0 max(Imoving(:))]);
  subplot(2,2,2), imshow(Istatic); title('static image'); caxis([0 max(Istatic(:))]);
  subplot(2,2,3), imshow(Ireg); title('registerd moving image'); caxis([0 max(Ireg(:))]);
  % Show also the static image transformed to the moving image
  Ireg2=movepixels(Istatic,Fx,Fy);
  subplot(2,2,4), imshow(Ireg2); title('registerd static image');caxis([0 max(Ireg2(:))]);

 % Show the transformation fields
  figure,
  subplot(2,2,1), imshow(Bx,[]); title('Backward Transf. in x direction');
  subplot(2,2,2), imshow(Fx,[]); title('Forward Transf. in x direction');
  subplot(2,2,3), imshow(By,[]); title('Backward Transf. in y direction');
  subplot(2,2,4), imshow(Fy,[]); title('Forward Transf. in y direction');




% % Use mutual information
%   Options.Similarity='mi';
% % Set grid smoothness penalty
%   Options.Penalty = 1e-3;
%   % Register the images
%   [Ireg,O_trans,Spacing,M,B,F] = image_registration(Imoving,Istatic);
% 
%   % Show the registration result
%   figure,
%   subplot(2,2,1), imshow(Imoving); title('moving image');
%   subplot(2,2,2), imshow(Istatic); title('static image');
%   subplot(2,2,3), imshow(Ireg); title('registerd moving image');
%   % Show also the static image transformed to the moving image
%   Ireg2=movepixels(Istatic,F);
%   subplot(2,2,4), imshow(Ireg2); title('registerd static image');
% 
%  % Show the transformation fields
%   figure,
%   subplot(2,2,1), imshow(B(:,:,1),[]); title('Backward Transf. in x direction');
%   subplot(2,2,2), imshow(F(:,:,2),[]); title('Forward Transf. in x direction');
%   subplot(2,2,3), imshow(B(:,:,1),[]); title('Backward Transf. in y direction');
%   subplot(2,2,4), imshow(F(:,:,2),[]); title('Forward Transf. in y direction');