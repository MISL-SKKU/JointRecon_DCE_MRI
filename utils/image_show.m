function image_show(input,slice,dynamic_range,rotating,number)
[~,~,~,z]=size(input);
tmp =[];
for order =1:z
    tmp_k = squeeze(input(:,:,:,order));   
    if rotating
    tmp = [tmp,rot90(abs(squeeze(tmp_k(:,:,slice))),3)];        
    figure(number),imshow(tmp,dynamic_range)% weighting mask
    else
    tmp = [tmp,(abs(squeeze(tmp_k(:,:,slice))))];                
    figure(number+1),imshow(tmp,dynamic_range)% weighting mask
    end
end

