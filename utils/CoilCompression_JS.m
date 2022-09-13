function [newdata,svdmatrices] = CoilCompression_JS(rawdata, numVrec, calsize,correction,reference)
% function [newdata,svdmatrices] = CoilCompression(rawdata, numVrec, calsize,correction)
% 
% This is a simple demo of coil compression for 3D Cartesian datasets.
%
% Input: rawdata, 4D array of the original multicoil dataset, (kx,ky,kz,coil).
%	 numVrec, the number of virtual coils prescribed.
%	 calsize, the calibration size in ky and kz of the fully sampled region in center k-space.
%	 correction, whether virtual coil alignment is performed.
%
% Output: newdata, the compressed data, (kx,ky,kz,numVrec)  
%	  svdmatrices, the coil compression matrices
%
% Note: rawdata has to be fully sampled in kx direction (partial echo is okay).
%
% (C) Tao Zhang, MRSRL, Stanford University, 2011

% findout the max in readout
readout_max = 0;
max_read = 0;
temp_read = 0;
for i=1:size(rawdata,1)
	temp_read = sum(abs(rawdata(i,end/2,end/2,:)).^2);
	if max_read < temp_read
		max_read = temp_read;
		readout_max = i;
	end
end

% do a circshift here so that the echo is in the center
shiftlen=round(size(rawdata,1)/2-readout_max);
rawdata=circshift(rawdata,[shiftlen 0 0 0]);

% now go to hybrid space (x,ky,kz,coil)
rawdata=fftshift(ifft(fftshift(rawdata,1),[],1),1);

disp('initialization of coil compression matrices.');
for slice = 1 : size(rawdata,1);
	% find the autocalibration signal
	for i=1: size(rawdata,4)		
		tmp=crop_JS(squeeze(reference(slice,:,:,i)),calsize);
		caldata(:,i)=tmp(:);		
	end
	
	[U,S,V]=svd(caldata,'econ');
	% save the SVD results
	svdmatrices(slice,:,:)= V(:,1:numVrec);

end

% for slice = 1 : size(rawdata,1);
% 	% find the autocalibration signal
% 	for i=1: size(rawdata,4)		
% 		tmp=crop(squeeze(rawdata(slice,:,:,i)),calsize);
% 		caldata(:,i)=tmp(:);		
% 	end
% 	
% 	[U,S,V]=svd(caldata,'econ');
% 	% save the SVD results
% 	svdmatrices(slice,:,:)= V(:,1:numVrec);
% 
% end

if(correction)
disp('aligning of coil compression matrices.');
% find out the rotation matrices from the center to both sides
for slice = size(rawdata,1)/2-1:-1:1

	V1 = squeeze(svdmatrices(slice+1,:,:));
	V2 = squeeze(svdmatrices(slice,:,:));

	A = V1'*V2;
	[UA,SA,VA] = svd(A,'econ');
	P = VA*UA';
	svdmatrices(slice,:,:)= (squeeze(svdmatrices(slice,:,:))*P);

end

for slice = size(rawdata,1)/2+1:size(rawdata,1)
	
	V1 = squeeze(svdmatrices(slice-1,:,:));
	V2 = squeeze(svdmatrices(slice,:,:));
		
	A = V1'*V2;
	[UA,SA,VA] = svd(A,'econ');
	P = VA*UA';
	svdmatrices(slice,:,:)= (squeeze(svdmatrices(slice,:,:))*P);

end
end

% compression: from original coils to numVrec
disp('compressing data into virtual coils.');
for slice = 1:size(rawdata,1)
%	disp(slice)
	for j=1:numVrec % compressed coil index    
        	for k=1:size(rawdata,4) % original coil index
        	
            		mat(:,:,k,j)=repmat(svdmatrices(slice,k,j),[size(rawdata,2) size(rawdata,3) 1]);
        	end
        	
        	newdata(slice,:,:,j)=sum(squeeze(rawdata(slice,:,:,:)).*mat(:,:,:,j),3);
	
    	end

end

% do the circshift back
newdata=fftshift(fft(fftshift(newdata,1),[],1),1);
newdata=circshift(newdata,[-shiftlen 0 0 0]);
disp('coil compression done');

