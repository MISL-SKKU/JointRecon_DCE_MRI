function [X_pre,init_phase_0,init_mag_0,raw_sh_low1] = preprocessing(raw_data,center_region_y,center_region_x)
%%% size %%
[Ny,Nz,Nt,Nc] = size(raw_data);
%% suppress the noise
w1 = tukeywin(Ny+4,0.35); w2 = tukeywin(Nz+4,0.35);
w = crop(w1*w2',Ny,Nz);
%%% pre-reconstruction : model-based reconstruction
[~,~,v_saif] = BASIS_estimation(raw_data,center_region_y,center_region_x,3);
b1 = coil_sensitivity_map(raw_data,w );
[mask,mask_high] = Masking_calculation(raw_data,center_region_y,center_region_x);
[raw_sh_low1] = Main_data_sharing(raw_data,mask,mask_high,w);
%%% parameter_setting 
XFM = Wavelet('Daubechies',4,4);	% wavelet 
tmpk = (raw_sh_low1.*repmat(mask,[1,1,1,Nc])+ permute(repmat(squeeze(raw_sh_low1(:,:,1:Nc,1)),[1,1,1,Nt]),[1,2,4,3]).*repmat((1-mask),[1,1,1,Nc])).*repmat(w,[1,1,Nt,Nc]);
param_pre.nite =30; param_pre.Vmb = v_saif;
param_pre.FT = Fmat_xyt(ones(Ny,Nz,Nt),b1); param_pre.E  = Emat_xyt(raw_sh_low1(:,:,:,10)~=0,b1);  param_pre.T = TempFFT(3); param_pre.XFM = XFM;
param_pre.y = raw_sh_low1; param_pre.initM = param_pre.FT'*tmpk; param_pre.mu   = repmat(param_pre.initM(:,:,1),1,1,Nt);
param_pre.dely = param_pre.y-param_pre.E*param_pre.mu; 
param_pre.scale1=2; param_pre.scale2=0.0001; param_pre.scale3=2;
[~, XD, XM, ~] = prereconstruction(param_pre);
X_pre=(param_pre.mu) +(XD)+XM;
%%% initial phase and magnitude
for c=1:Nc
coil_img_y=X_pre.*repmat(b1(:,:,c),[1,1,Nt]);
init_phase_0(:,:,:,c) = angle(coil_img_y);
init_mag_0(:,:,:,c) = exp(-1j*init_phase_0(:,:,:,c)).*(param_pre.FT'*tmpk(:,:,:,c));
end
end

