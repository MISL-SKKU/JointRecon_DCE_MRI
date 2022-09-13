function [mask,mask_high] = Masking_calculation(raw_data,center_region_y,center_region_x)
mask = squeeze(raw_data(:,:,:,1)~=0);
mask_high = mask;
mask_high(center_region_y,center_region_x,:)=0;
end

