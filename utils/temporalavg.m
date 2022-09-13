function mu=temporalavg(param,order);
% edit by E.Lim

y=param.y(:,:,1:order);
M=abs(y)>0;
% M=param.mask;
SM=sum(M,3);
SM(find(SM==0))=1;

d = sum(y,3)./SM;
M=abs(d)==0;

[sx, sy]=size(d);
W = Wavelet('Daubechies',4,4);
ssx = 2^ceil(log2(sx));
ssy = 2^ceil(log2(sy));
ss = max(ssx, ssy); wavWeight=param.wavWeight;
data=d;

ite=0;
while(1),
    ite=ite+1;
    X = ifft2c_mri(data);
    X= zpad(X,ss,ss); % zpad to the closest diadic
    X = W*(X); % apply wavelet
    X = SoftThresh(X,wavWeight); % threshold ( joint sparsity)
    X = W'*(X); % get back the image
    X = crop(X,sx,sy); % return to the original size
    data=M.*(fft2c_mri(X))+d;
    if (ite > 50), break;end
end

mu = ifft2c_mri(data);

end


% soft-thresholding function
function y=SoftThresh(x,p)
y=(abs(x)-p).*x./abs(x).*(abs(x)>p);
y(isnan(y))=0;
end