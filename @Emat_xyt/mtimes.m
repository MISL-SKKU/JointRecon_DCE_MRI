function res = mtimes(a,b)   
if a.adjoint
    
    % x=H'*y (x=res,b=y), x: object, y: multi-coil k-space data
    % multi-coil data in image domain        
    res     = zeros(size(b,1),size(b,2),size(b,3));
    x_array = ifft2c_mri(b.*repmat(a.mask,[1,1,1,size(b,4)]));
    
    % multi-coil combination in the image domain
    for tt=1:size(b,3)
        res(:,:,tt)=sum(squeeze(x_array(:,:,tt,:)).*conj(a.b1),3)./sum(abs((a.b1)).^2,3);
    end
    clear x_array
    
else
    
    % y=H*x (y=res,b=x), x: object, y: multi-coil k-space data
    % multi-coil image from object
    
    x_array = zeros(size(b,1),size(b,2),size(a.b1,3),size(b,3));
    for tt=1:size(b,3)
      x_array(:,:,:,tt) = repmat(squeeze(b(:,:,tt)),[1,1,size(a.b1,3)]).*a.b1;
    end   
    
    % multi-coil image to k-space domain
    res=fft2c_mri(permute(x_array,[1,2,4,3]));
    clear x_array
    
    % apply sampling mask    
    res=res.*repmat(a.mask,[1,1,1,size(a.b1,3)]);    
end