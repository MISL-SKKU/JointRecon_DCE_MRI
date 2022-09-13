function [raw_sh_low1] = Main_data_sharing(raw_data,mask,mask_high,filter)
[Ny,Nz,Nt,Nc]=size(raw_data);
raw_sh_low1 = zeros(Ny,Nz,Nt,Nc);
for c=1:Nc
    raw_sh_low1(:,:,:,c) = datasharing(squeeze(raw_data(:,:,:,c)),mask,mask_high,3).*repmat(filter,1,1,Nt);
end
end

