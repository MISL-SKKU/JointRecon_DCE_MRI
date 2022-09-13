function res = datasharing_new(kdata,mask_a,mask_b,mask_c);

[ny nz nt]=size(mask_a);
res=zeros(size(kdata));


for t=1:2
B = sum(mask_b(:,:,t:t+2),3);
B(B<2) = 1;
% figure,imshow(B,[0 3])
C = sum(mask_c(:,:,t:t+4),3);
C(C<2) = 1;
% figure,imshow(C,[0 3])

res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t:t+2).*mask_b(:,:,t:t+2),3)./B+ sum(kdata(:,:,t:t+4).*mask_c(:,:,t:t+4),3)./C;
% figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
end


for t=3:nt-2
B = sum(mask_b(:,:,t-1:t+1),3);
B(B<2) = 1;
% figure,imshow(B,[0 3])
C = sum(mask_c(:,:,t-2:t+2),3);
C(C<2) = 1;
% figure,imshow(C,[0 3])

res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t-1:t+1).*mask_b(:,:,t-1:t+1),3)./B+ sum(kdata(:,:,t-2:t+2).*mask_c(:,:,t-2:t+2),3)./C;
% figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
end


for t=nt-1:nt
B = sum(mask_b(:,:,t-2:t),3);
B(B<2) = 1;
% figure,imshow(B,[0 3])
C = sum(mask_c(:,:,t-4:t),3);
C(C<2) = 1;
% figure,imshow(C,[0 3])

res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t-2:t).*mask_b(:,:,t-2:t),3)./B+ sum(kdata(:,:,t-4:t).*mask_c(:,:,t-4:t),3)./C;
% figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
end

end


% function res = datasharing_new(kdata,mask_a,mask_b,mask_c);
% 
% [ny nz nt]=size(mask_a);
% res=zeros(size(kdata));
% 
% 
% for t=1:2
% B = sum(mask_b(:,:,t:t+2),3);
% B(B<2) = 1;
% % figure,imshow(B,[0 3])
% C = sum(mask_c(:,:,t:t+4),3);
% C(C<2) = 1;
% % figure,imshow(C,[0 3])
% 
% res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t:t+2).*mask_b(:,:,t:t+2),3)./B+ sum(kdata(:,:,t:t+4).*mask_c(:,:,t:t+4),3)./C;
% % figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
% end
% 
% 
% for t=3:nt-2
% B = sum(mask_b(:,:,t-1:t+1),3);
% B(B<2) = 1;
% % figure,imshow(B,[0 3])
% C = sum(mask_c(:,:,t-2:t+2),3);
% C(C<2) = 1;
% % figure,imshow(C,[0 3])
% 
% res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t-1:t+1).*mask_b(:,:,t-1:t+1),3)./B+ sum(kdata(:,:,t-2:t+2).*mask_c(:,:,t-2:t+2),3)./C;
% % figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
% end
% 
% 
% for t=nt-1:nt
% B = sum(mask_b(:,:,t-2:t),3);
% B(B<2) = 1;
% % figure,imshow(B,[0 3])
% C = sum(mask_c(:,:,t-4:t),3);
% C(C<2) = 1;
% % figure,imshow(C,[0 3])
% 
% res(:,:,t) = kdata(:,:,t).*mask_a(:,:,t) + sum(kdata(:,:,t-2:t).*mask_b(:,:,t-2:t),3)./B+ sum(kdata(:,:,t-4:t).*mask_c(:,:,t-4:t),3)./C;
% % figure(100),imshow(abs(res(:,:,t)~=0),[0 1]);drawnow;
% end
% 
% end
