function [ output,Imask4] = Normalization_v1( Input,ref )
options.Nknots = [15 15];
options.NiterMax = 4;
options.flag_display = 0;
options.overs =1;
options.normalize = 1;
options.flag_allknots =1;
options.GainSmooth = 0.2;
options.Bgain = 0.8;
%% whole brain normalization
whole_brain_res= gray2ind(mat2gray(abs(ref)),4096);
M_res=whole_brain_res;
I0 = mean(double(M_res(:,:,1:100)),3);
%% update the outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mask,V_mean,V_std,Vfad] = NeckBackground(I0,0,1);
corner =  2;
percent = 0;
[Imask,Ibck] = NeckMask(Vfad,[1*V_mean,13*V_mean+V_std],corner,percent);
Imask4 = NeckMaskCLean(Imask);
%% update the outputs
[out,~,~]=PolyMaskFilter(double(I0),4,Imask4,0);
[B,~,~] = BiasCorrLEMSS2D(double(I0),Imask4,V_mean,V_std,options, out);
clear x;
clear p;

MASK=ones(size(Imask4));
idx=find(Imask4==1);
MASK(idx)=abs(B(idx));
BIAS=(imgaussfilt(MASK,20)+eps);
BIAS= BIAS./max(BIAS(:));
for i=1:size(Input,3)
    cor_M_res(:,:,i) = double(abs(Input(:,:,i)))./BIAS;
end
output = squeeze(cor_M_res);
toc

end


