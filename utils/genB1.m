function b1=genB1(data,winSize)

% data = fft2c_mri(data);

% data = data./max(data(:));

[ny nz nc]=size(data);
sy = winSize(1);
sz = winSize(2);

% Calib=zeros(size(data));
% Calib(ny/2+1 - sy/2 : ny/2 + sy/2,nz/2+1 - sz/2 : nz/2 + sz/2,:)=data(ny/2+1 - sy/2 : ny/2 + sy/2,nz/2+1 - sz/2 : nz/2 + sz/2,:).*repmat(hamming(sy)*hamming(sz)',[1 1 nc]);
Calib = data.*repmat(zpad(hamming(sy)*hamming(sz)',ny,nz),1,1,nc);


im=ifft2c_mri(Calib);

A=sos3(im);
% A(A<mean(mean(A(1:15,1:15))))=1;

b1=im./(repmat(A,[1 1 nc]));
