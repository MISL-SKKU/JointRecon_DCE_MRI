function  [res,WH]= NMF_recon_single_coil_v3_104(Input,param)
%%% NMF
[nx,ny,nt]=size(Input);
NMF_real_tmp = Input;
% NMF_real=real(NMF_real_tmp(:,:,1:nt));
NMF_real=real(NMF_real_tmp(:,:,1:nt))-repmat(squeeze(real(NMF_real_tmp(:,:,1))),[1,1,nt]);
NMF_region=NMF_real;
%% mask pattern
% Cas_NMF_control=NMF_region(:,:,1:round(nt/4));
% for x=1:nx
%     for y=1:ny
%         Cas_NMF_control(x,y,:)= smooth(squeeze(Cas_NMF_control(x,y,:)));
%     end
% end
% res_tmp=abs(Cas_NMF_control)-Cas_NMF_control;
% refer_mask=res_tmp(:,:,size(res_tmp,3));
% idx0 = find(refer_mask>0);
% sample_mask=Recon_mask(:,:,1);
% idx_recon_mask= sample_mask(:)~=0;
%% real reconstruction %%
if param.nmfweight
 if param.pre_init
    init_factors = param.init_factors;
 else
    NMF_tmp=reshape(abs(NMF_region).*repmat(param.W2,[1,1,nt]),[nx*ny,nt]);
    x_init = [];
    options.init_alg = 'semi_random';
    options.x_init = x_init;
    options.verbose = 2;
    options.f_opt = 1;
    % Hierarchical ALS
    options.alg = 'hals';
    [init_factors,~] = nmf_als(NMF_tmp, rank, options);   
 end

% for r =1:param.nmf_rank
% figure(100),plot(init_factors.W(:,r)),hold on
% end


%%% main recon %%%
%  NMF_tmp0=reshape(abs(NMF_region).*repmat(param.W2,[1,1,nt]),[nx*ny,nt]);
   NMF_tmp0=reshape(abs(NMF_region),[nx*ny,nt]);
   
   for voxel =1:size(NMF_tmp0)
     NMF_tmp0(voxel,:) = smooth(NMF_tmp0(voxel,:));
   end   
   
   if param.nmf_prior
    options.init_alg = 'pre_defined_t';    
    options.verbose = 2;
    options.f_opt = 1;   
    options.lambda =param.pattern_weighting;   % 5e-2;
    options.type = 'l1r';
    options.pre_defined = init_factors;
    options.tolerance = param.tolerance; 
    [WH] = nenmf((NMF_tmp0)', param.nmf_rank, options);

for r =1:param.nmf_rank
figure(100),plot(WH.W(:,r)),hold on
end
  
    R_mag_tmp_1=(WH.W*WH.H)';
%     R_mag_tmp_1(idx0,:) = -R_mag_tmp_1(idx0,:);
    R_mag_tmp_res= R_mag_tmp_1;
    R_mag_tmp_res=reshape(R_mag_tmp_res,[nx,ny,nt]);
    R_mag_tmp_res=reshape(R_mag_tmp_res,[nx,ny,nt])+repmat(real(NMF_real_tmp(:,:,1)),[1,1,nt]);
   else
    R_mag_tmp_res=zeros(nx,ny,nt);
   end
res= R_mag_tmp_res;
end





