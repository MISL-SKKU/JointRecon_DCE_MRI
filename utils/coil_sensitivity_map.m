function [ b1_fromT1 ] = coil_sensitivity_map( raw_data,w )
t1 = squeeze(raw_data(:,:,1,:));
[~,~,Nc]=size(t1);
% calculate coil sensitivity map
b1_fromT1 = genB1(t1.*repmat(w,1,1,Nc),[120 160]);
end

