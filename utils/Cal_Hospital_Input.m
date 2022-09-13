function [W0,H0] = Cal_Hospital_Input(input,patch_size_y,patch_size_x,tolerance)
X_norm_smooth=zeros(size(input));
for i=1:144
    for j=1:192
        X_norm_smooth(i,j,:) = smooth(squeeze(input(i,j,:)-input(i,j,1)));
    end
end
tmp_patch=(X_norm_smooth(patch_size_y,patch_size_x,:));
patch=(tmp_patch);
patch = reshape(patch,[size(patch,1)*size(patch,2),size(patch,3)]);
opt = statset('MaxIter',500,'Display','final','TolFun',tolerance,'TolX',tolerance);
[W0,H0] = nnmf(abs(patch)',3,'replicates',30,...
                   'options',opt,...
                   'algorithm','mult');          
for r =1:3
figure(100),plot(smooth(W0(:,r))),hold on    
end
end

