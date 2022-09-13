function [ u,s,v_saif ] = BASIS_estimation( raw_data,center_region_y,center_region_x,rank)
basis=[];
kspace=raw_data(center_region_y,center_region_x,1:end,:);
[ny, nz, nt, nc]=size(kspace);
 for y = 1: ny
    for z = 1:nz
        for c= 1:nc
          A = smooth((real(squeeze(kspace(y,z,:,c)))-real(squeeze(kspace(y,z,:,1)))));          
          basis=[basis,A];
        end
    end
 end
[u,s,v_saif] = svds(basis',50);
v_saif(:,rank+1:end) = 0;
end

