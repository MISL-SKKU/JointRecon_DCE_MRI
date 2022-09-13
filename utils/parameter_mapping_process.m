function [outputArg1] = parameter_mapping_process(inputArg1,zero_matrix,Imask4,AIF,time,prefs)
tic
[ny,nz,nt]=size(inputArg1);

for y = 1:ny
    for z= 1:nz
        if(Imask4(y,z)==1)        
    x2 = model_tissue_uptake(squeeze(inputArg1(y,z,1:165)),(AIF(1:165,1)),time(1:165)',prefs);
    zero_matrix(y,z,1)=x2(2);		
    zero_matrix(y,z,2)=x2(1);	
    zero_matrix(y,z,3)=x2(3);	
        end
    end
end
toc

PS_ref = zero_matrix(:,:,1).*zero_matrix(:,:,2)./((zero_matrix(:,:,1)-zero_matrix(:,:,2))+eps);
zero_matrix(:,:,2)=PS_ref;

close all
for y = 1:ny
    for z= 1:nz
        if(Imask4(y,z)==1)        
     par2= fitdcemri(squeeze(inputArg1(y,z,1:165)),(AIF(1:165,1)),time(1:165)',[0.5; 0.005 ;0.005],zeros(3,1),[10;10;10],'extended_Tofts');
     zero_matrix(y,z,4)=par2(2);  
        end
    end
end
outputArg1=zero_matrix;
clear zero_matrix
end

