%% prospective study
clear all 
clc 
addpath(genpath('utils'));addpath(genpath('NMFLibrary-master'));
%% Load Slice data
load(strcat('raw.mat'));
center_region_y =66:79; center_region_x =90:103; %% k-space center size
[X_pre,init_phase_0,init_mag_0,raw_sh_low1] = preprocessing(raw_data,center_region_y,center_region_x); %% pre initialization 
[norm_X] = Normalization_v1((X_pre),(X_pre)); %% to visualize and calculate the M in detail;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% M calculation
[W1] = Cal_M1_M2(norm_X,1,300,0.15);
%% input_pattern
load('initial_basis.mat') % pre-setting initial basis for avoiding local minima
param_real.FT= Fmat_xytc(ones(size(X_pre)),ones(size(X_pre))); param_real.W = TempFFT(3);
param_real.pre_iter= 5; param_real.iteration =25; param_real.display = 0; 
param_real.scale =15; param_real.scale1=30; param_real.tol=1e-8;
param_real.lambda_0 = 1; param_real.W1 = W1; param_real.W2 = W1; param_real.nmfweight=1; param_real.nmf_rank = 3;
param_real.nmf_prior = 1; param_real.lambda_0 = 1; param_real.lambda_1 = 1; %%% step formulation
param_real.lambda_2 =0.7; param_real.tau_0 = 0.3; %%% weighting CG
param_real.pre_init = 1; param_real.init_factors = init_factors; %%% NNMF input 
param_real.pattern_weighting = 1e-3; param_real.tolerance = 1e-7; %%% NNMF part weighting
%% final reconstruction %%%%
for c=1:size(raw_sh_low1,4)
    c
param_real.y=raw_sh_low1(:,:,:,c);
param_real.init_phase_0 =init_phase_0(:,:,:,c);
param_real.init_mag_0 =init_mag_0(:,:,:,c) ;
tic
[Complex_img, Mag_img, Phase_img, W, H] = Fast_reconstruction( param_real );
toc
tmp_whole(:,:,:,c)=Complex_img;
tmp_W(:,:,c) = W;
tmp_H(:,:,c) = H; 
end
whole=sos4(tmp_whole);
[norm_whole] = Normalization_v1( whole,X_pre ); %% intensity normalization
close all % image_show([cat(4,norm_whole)],50,[0 0.5],1,1000)
%% post processing ( normalize & functional segment maps )
patch_size_y=50:90; patch_size_z=55:105;%% mask region manually
[output_w,output_h] = post_processing(norm_whole,tmp_W,tmp_H,patch_size_y,patch_size_z);

