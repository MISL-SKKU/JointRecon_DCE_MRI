function AIF = plot_concentration_time_course(input,yy,zz,block,scale,number)
[~,~,~,z]=size(input);
for order=1:z
    tmp_input=squeeze(input(:,:,:,order));
    figure(number),plot(smooth(squeeze(mean(mean(squeeze(abs(tmp_input(yy-block:yy+block,zz-block:zz+block,:))),1),2)),3)*scale(order)),hold on
    AIF(:,order)=smooth(squeeze(mean(mean(squeeze(abs(tmp_input(yy-block:yy+block,zz-block:zz+block,:))),1),2)),3)*scale(order);
end



