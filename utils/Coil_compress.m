function [ raw_data_out_put ] = Coil_compress( raw_data,final_frame,delay,numVrec,calsize,correction)
raw_data=raw_data(:,:,1:final_frame,:);
[ny,nz,nt,nc]=size(raw_data);
for i=1:delay
raw_data(:,:,i,:)=raw_data(:,:,1,:);
end
raw_data=raw_data./max(abs(raw_data(:)));
ref_frame(1,:,:,:)=squeeze(raw_data(:,:,1,:));
for t=1:nt
    kspace(1,:,:,:)=squeeze(raw_data(:,:,t,:));    
    [fe,pe,se,coils] = size(kspace);
    kspace_comp(:,:,:,t) = squeeze(CoilCompression_JS(kspace,numVrec,calsize,correction,ref_frame));
end
raw_data_out_put=permute(kspace_comp,[1,2,4,3]);
end

