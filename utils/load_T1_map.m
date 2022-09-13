function [T1_map] = load_T1_map(In_dir_T1,slice)
load(strcat(In_dir_T1,'slice_',num2str(slice-1),'.mat'));
T1_map_tmp(:,:,:,1)=T1;
load(strcat(In_dir_T1,'slice_',num2str(slice),'.mat'));
T1_map_tmp(:,:,:,2)=T1;
load(strcat(In_dir_T1,'slice_',num2str(slice+1),'.mat'));
T1_map_tmp(:,:,:,3)=T1;
clear X
T1_map= mean(T1_map_tmp,4);
T1_map=rot90(abs(T1_map),2);
end

