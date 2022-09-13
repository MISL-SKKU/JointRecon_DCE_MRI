function [CA] = Concentration_calculation(inputArg1,T1_map,flip_angle,TR,delay,nb_pixel)
[ny,nz,~]=size(inputArg1);
CA = zeros(size(inputArg1));
 for y = nb_pixel+1:ny-nb_pixel-1
     for z= nb_pixel+1:nz-nb_pixel-1 
       A= sig2conc(mean(mean(inputArg1(y:y+nb_pixel,z:z+nb_pixel,:),1),2),1/(T1_map(y,z)*0.001),1,flip_angle,TR*0.001,delay);  
       CA(y,z,:)=smooth(abs(A));     
     end
 end
end

