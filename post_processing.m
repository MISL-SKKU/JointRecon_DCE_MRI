function [output_w,output_h] = post_processing(input,tmp_W,tmp_H,patch_size_y,patch_size_z)
%% post processing
threshold  = 0.015;
[MASKING] = tumor_masking(input,patch_size_y,patch_size_z,threshold);
%%%%% confirm %%%%
MASKING(20:end,1:5)=0; MASKING(30:end,1:15)=0; MASKING(38:end,15:21)=0; MASKING(1:10,48:end)=0;
figure,imshow(MASKING,[])
%% functional segmentmap
[final_w,~,final_h] = rank_one_proc(tmp_W,tmp_H,size(input,1),size(input,2),patch_size_y,patch_size_z,MASKING);
output_w=final_h.*repmat(MASKING,[1,1,size(final_w,3)]);
output_h= final_w;
end

