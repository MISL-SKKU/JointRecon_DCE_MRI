function [ X, XD, XM, R] = MASE_relaxed_POCS( param )
X = param.initM;
[nx,ny,nt]=size(X);
X0= param.mu;
R = X-X0; 
dely = param.dely;
%% initialize
XM = 0;
U= 0;
for i=1:param.nite
    i
tic
Rpre = real(R); % old  Rpre = R
Rpre2 = imag(R); % old  Rpre = R

%% update U - proximal gradient
Upre = reshape(Rpre,[nx*ny,nt])*(param.Vmb); 
Upre(isinf(Upre))=0;    Upre(isnan(Upre))=0;
Upre1 = reshape(Upre,[nx,ny,size(Upre,2)]);
wavelet_mask = zeros(256,256,size(Upre,2));
wavelet_mask(128-71:128+72 ,128-95:128+96,:)=Upre1;
for t = 1:size(Upre1,3)
    wavelet_mask(:,:,t) = param.XFM *(wavelet_mask(:,:,t)); % apply wavelet
end
noise=abs(wavelet_mask(157:166,145:154,1:5));
lambda_S= param.scale1*mean(noise(:));    
wavelet_mask_hat = SoftThresh(wavelet_mask,lambda_S); % threshold
for t = 1:size(Upre1,3)
    wavelet_mask(:,:,t) = param.XFM' *(wavelet_mask_hat(:,:,t)); % apply wavelet
end 
for t = 1:size(Upre1,3)
  Upre1(:,:,t)=crop(wavelet_mask(:,:,t),144,192);
end
U = reshape(Upre1 ,[nx*ny,size(Upre1,3)]);
U(isinf(U))=0;    U(isnan(U))=0;
%% update XD - proximal gradient
XDpre = reshape(U*param.Vmb',[nx,ny,nt]);
noise=abs(XDpre(1:20,1:20,1:10));
lambda_XD= param.scale2*mean(noise(:));   
XD_real= (reshape(SoftThresh(reshape(XDpre,[nx*ny,nt]),lambda_XD),[nx,ny,nt]));
clear XDpre
%% update U - proximal gradient
Upre = reshape(Rpre2,[nx*ny,nt])*(param.Vmb); 
Upre(isinf(Upre))=0;    Upre(isnan(Upre))=0;
Upre1 = reshape(Upre,[nx,ny,size(Upre,2)]);
wavelet_mask = zeros(256,256,size(Upre,2));
wavelet_mask(128-71:128+72 ,128-95:128+96,:)=Upre1;
for t = 1:size(Upre1,3)
    wavelet_mask(:,:,t) = param.XFM *(wavelet_mask(:,:,t)); % apply wavelet
end
noise=abs(wavelet_mask(157:166,145:154,1:5));
lambda_S= param.scale1*mean(noise(:));    
wavelet_mask_hat = SoftThresh(wavelet_mask,lambda_S); % threshold
for t = 1:size(Upre1,3)
    wavelet_mask(:,:,t) = param.XFM' *(wavelet_mask_hat(:,:,t)); % apply wavelet
end 
for t = 1:size(Upre1,3)
  Upre1(:,:,t)=crop(wavelet_mask(:,:,t),144,192);
end
U = reshape(Upre1 ,[nx*ny,size(Upre1,3)]);
U(isinf(U))=0;    U(isnan(U))=0;
%% update XD - proximal gradient
XDpre = reshape(U*param.Vmb',[nx,ny,nt]);
noise=abs(XDpre(1:20,1:20,1:10));
lambda_XD= param.scale2*mean(noise(:));   
XD_imag= (reshape(SoftThresh(reshape(XDpre,[nx*ny,nt]),lambda_XD),[nx,ny,nt]));
XD=XD_real+1i*XD_imag;
clear XDpre
%% Data fidelity
resk = param.E*(XD)-dely;
R    = (XD)-(param.E'*resk);
%% update
X= (R)+X0;
toc
end
end

%% soft-thresholding function
function y=SoftThresh(x,p)
y=(abs(x)-p).*x./abs(x).*(abs(x)>p);
y(isnan(y))=0;
end
