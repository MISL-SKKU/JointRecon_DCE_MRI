function [W1] = Cal_M1_M2(X_norm,a,b,c)

for i=1:50
final_SR(:,:,i)=(abs(X_norm(:,:,i)));
end

final_SR_img_mask=imgaussfilt(abs(mean(abs(X_norm(:,:,1)),3)),2);
img=final_SR_img_mask;
ssize = size(img(:,:));
img_mask = zeros(ssize(1),ssize(2)); % reject the outside region 
img_mask(img > 0.2*max(img(:))) = 1;

%%%%
Example=abs(final_SR);
Example=double(gray2ind(mat2gray(Example),4096));
Example=(abs(Example)-repmat(abs(Example(:,:,1)),[1,1,size(Example,3)]));
Mask=zeros(size(Example,1),size(Example,2));
for y=1:size(Example,1)
    for z=1:size(Example,2)
             A=max((squeeze(Example(y,z,:))));
             Mask(y,z)=A;
    end
end
Mask=(Mask);
Mask=double(gray2ind(mat2gray(Mask),4096));

[hist,bins,x_bins] = histogram((Mask),100);
bar(bins,hist),hold on;
for i=1
a=1;
b=300; % 300 change parameters
c=0.3;  %c =0.3 change parameters
x=linspace(0,1,4096);
sigmoid = 1./(1+exp(b*(x-c)));
for y=1:size(Mask,1)
    for z=1:size(Mask,2)
        A=round(double(Mask(y,z)));
        if A ==0
          W1(y,z) = sigmoid(A+1);
        else
          W1(y,z) = sigmoid(A);
        end
    end
end
end
W1=imgaussfilt(W1./max(W1(:)),0.75);
end




