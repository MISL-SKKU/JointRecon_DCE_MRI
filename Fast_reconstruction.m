function [Complex_img, Mag_img,Phase_img,W,H] = Fast_reconstruction( param_real )
%%% initialization
[~,~,nt,~]= (size(param_real.y));
AAA=(1-param_real.W1);
Weighting=AAA./max(AAA(:));
%% initialize
M = param_real.init_mag_0;
P = param_real.init_phase_0;
for ite=1:param_real.iteration
    ite
%%% pre-interation %%%
if ite < 2
fprintf('\n pre-reconstruction ... \n');
%%% For initialization %%%
params.FT = param_real.FT;  params.W = param_real.W;
params.lambda=0.005; params.dec = 0.01;
params.nite=param_real.pre_iter; params.tol=5e-4;
params.display=param_real.display;
params.y = param_real.y;
params.scale = param_real.scale; params.weighting = param_real.W1;
params.phase = P;
tic
M_tmp=CSL1SoftThresh(M,params);
toc
M_update=M_tmp;
P_update=P;

else

tic 
%%%  phase update  %%% 
P_norm=P;
P_update=P_norm;   
%%%  soft_threshold  %%%   
params.phase = P_update;
params.weighting = param_real.W1;
params.nite =1;
params.scale=param_real.scale1;

  if param_real.lambda_0       
            M_TV=CSL1SoftThresh_nmf_v1(M,params);
  end
    
%%% NMF fitting %%%
%%% l2 norm CG problem %%%    
  if 1 < ite 
     if param_real.lambda_1
           [res,WH]= NMF_recon(M,param_real);
           M_NMF=res;
           constrained_res = (param_real.tau_0./(param_real.tau_0+param_real.lambda_2)).*M_TV + (param_real.lambda_2./(param_real.tau_0+param_real.lambda_2)).*(repmat(1-Weighting,[1,1,nt]).*M_NMF+repmat(Weighting,[1,1,nt]).*M_TV);            
           constrained_complex = real(constrained_res).*exp(1j*P_update);            
     end
  end
        
     Y = (param_real.FT*constrained_complex).*(params.y==0)+ param_real.y;
     M_update = real(exp(-1j*P_update).*(param_real.FT'*Y));   
    
%%% Gamma tau update
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	        fprintf(' ite: %d , M:update: %.4f\n', ite,norm(M_update(:)-M(:))/norm(M(:)));     
            %%%%	stopping criteria  %%%%
        	if (ite > param_real.iteration) || (norm(M_update(:)-M(:))<param_real.tol*norm(M(:))), break;end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 toc
end

M=M_update;
P=P_update;

end

Complex_img= constrained_complex;
Mag_img= constrained_res;
Phase_img=P_update;
W=WH.W;
H=WH.H;

end








