function [final_w,result,feature] = rank_one_proc(inputArg1,inputArg2,Ny,Nz,patch_size_y,patch_size_z,MASKING)
[Nt,r,~]=size(inputArg1);

tmp_w=zeros(Nt,r); tmp_h=zeros(length(patch_size_y),length(patch_size_z),r);
final_w =zeros(Nt,r); result=zeros(length(patch_size_y),length(patch_size_z),r);
reorder = zeros(r,1);

for r =1:r
A=squeeze(inputArg1(:,r,:)); [u1,~,~]=svd(A,'econ');
tmp_w(:,r)=u1(:,1);
end
%%% sorting the graph %%%
M = max(abs(tmp_w(1:50,:)),[],1);
B = sort(M,'descend');

for rr=1:r
[~,j]=find(abs(tmp_w)==B(rr));
reorder(rr,1)=j;
end

for rr=1:r
final_w(:,rr)=abs(tmp_w(:,reorder(rr)));
end

for rr =1:r
B=squeeze(inputArg2(reorder(rr,1),:,:)); [u2,~,~]=svd(B,'econ');
res1 = reshape(u2(:,1),[Ny,Nz]);
res_H1 = imgaussfilt(res1(patch_size_y,patch_size_z));
tmp_h(:,:,rr)=res_H1;
end
%%%%%%% CNNMF map %%%%%%%%%%
for rr=1:r
result(:,:,rr)=tmp_h(:,:,rr)./sqrt(sum(tmp_h.^2,3));
end

feature= result;
for i=1:size(MASKING,1) 
    for j=1:size(MASKING,2) 
        A_base=squeeze(result(i,j,:));
        for k=1:3
            tmp=A_base(k)./(sum(A_base)+eps);
            feature(i,j,k)=tmp;
        end
    end
end

