function [dynamic_cs,coil_img_1,dynamic_cs_y,coil_img_y,init_phase_0,init_mag_0] = Main_DCS(input,param_1)
%%% pre define phase map
[~,~,~,Nc]=size(input);
for c=1:Nc
    c
param_1.y = input(:,:,:,c);
recon_dft=squeeze(param_1.FT'*param_1.y);
fprintf('\n dynamic CS...pre_phase \n');  
params=param_1;
recon_cs_y=CSL1SoftThresh(recon_dft,params);
coil_img_y(:,:,:,c)=recon_cs_y;
end
dynamic_cs_y=(sos4(coil_img_y));
close all
%%%%% phase information %%%%%
for c=1:Nc
init_phase_0(:,:,:,c) = angle(coil_img_y(:,:,:,c));
end
for c=1:Nc
init_mag_0(:,:,:,c) = exp(-1j*init_phase_0(:,:,:,c)).*(param_1.FT'*param_1.tmpk(:,:,:,c));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% real dyanmic CS
for c=1:Nc
    c  
param_1.y = input(:,:,:,c);
param_1.phase = init_phase_0(:,:,:,c);
recon_dft=squeeze(abs(init_mag_0(:,:,:,c)));
fprintf('\n dynamic CS... \n');
params=param_1;
% repetitions
recon_cs=CSL1SoftThresh_nmf(recon_dft,params);
coil_img_1(:,:,:,c)=recon_cs.*exp(1j*param_1.phase);
end
dynamic_cs=sos4((coil_img_1));
close all
end

