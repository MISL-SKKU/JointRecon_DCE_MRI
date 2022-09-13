function [final_w,final_h] = two_step_NNMF(inputArg1,patch_size_y,patch_size_z,opt,rank,W0,mode,mode2)
[~,~,Nt] = size(inputArg1);
Input=(inputArg1-repmat(inputArg1(:,:,1),[1,1,Nt]));
patch=(Input(patch_size_y,patch_size_z,:));
patch = reshape(patch,[size(patch,1)*size(patch,2),size(patch,3)]);
if mode
[outputArg1,outputArg2] = nnmf(abs(patch)',rank,'w0',W0,'replicates',30,...
                   'options',opt,...
                   'algorithm','mult');
else
[outputArg1,outputArg2] = nnmf(abs(patch)',rank,'replicates',30,...
                   'options',opt,...
                   'algorithm','mult');
end    
                             
tmp_h=zeros(length(patch_size_y),length(patch_size_z),rank);
final_w =zeros(Nt,rank); result=zeros(length(patch_size_y),length(patch_size_z),rank);
reorder = zeros(rank,1);


%%% sorting the graph %%%
M = max(abs(outputArg1(1:50,:)),[],1);
B = sort(M,'descend');

for rr=1:rank
[~,j]=find(abs(outputArg1)==B(rr));
reorder(rr,1)=j;
end

for rr=1:rank
final_w(:,rr)=abs(outputArg1(:,reorder(rr)));
end

for r =1:rank
res1 = reshape(squeeze(outputArg2(reorder(r,1),:)),[length(patch_size_y),length(patch_size_z)]);
if mode2
res_H1 = imgaussfilt(res1);
else
res_H1 = (res1);
end
tmp_h(:,:,r)=res_H1;
end
%%%%%%% CNNMF map %%%%%%%%%%
for r=1:rank
result(:,:,r)=tmp_h(:,:,r)./sqrt(sum(tmp_h.^2,3));
end

final_h= result;
for i=1:length(patch_size_y) 
    for j=1:length(patch_size_z) 
        A_base=squeeze(result(i,j,:));
        for k=1:3
            tmp=A_base(k)./(sum(A_base)+eps);
            final_h(i,j,k)=tmp;
        end
    end
end
       
               
end

