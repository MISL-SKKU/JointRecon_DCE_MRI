function [recon] = Main_kt_focuss(input,param)
%% KT -FOCUSS
[~,~,~,Nc]=size(input);
tic
for c = 1:Nc
    c
    recon(:,:,:,c) = KTFOCUSS_v1(input(:,:,:,c),param,squeeze(input(:,:,:,1)~=0),param.pred,param.factor,param.lambda,param.iter,param.outerloop);
end
toc
end

