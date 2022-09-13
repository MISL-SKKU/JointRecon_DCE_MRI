function x = CSL1SoftThresh_nmf_v1(x0,param)
% 
% res = CSL1SoftThresh(x0,param)
%
% Compressed sensing reconstruction of undersampled k-space MRI data
%
% L1-norm minimization using iterative soft-thresholding
% 
% Given the acquisition model y = E*x and the sparsifying transform W, the
% program perfoms soft-thresholding on W*x to estimate the missing values
% in the k-apce data y
%
% Ricardo Otazo 2009
%
x=x0;
ite=0;
[ny,nz,~]=size(x0);

% iterations
while(1)
    x0_1 = x; 
    X  = param.W*x0_1; 
    NOISE = abs(X(1:10,1:10,1:10));
    lambda= param.scale*mean(NOISE(:));
    lambda = lambda*(1-ite*param.dec); 
    lambda = param.weighting.*lambda;            
    for y=1:ny
        for z=1:nz       
        X(y,z,:) = SoftThresh(X(y,z,:),lambda(y,z));    
        end
    end
    x_0 = param.W'*X;
    x = x_0;
    x=  real(x).*exp(1j*param.phase);
    Y = param.FT*x; 
    Y = Y.*(param.y==0) + param.y;
    x = abs(exp(-1j*param.phase).*(param.FT'*Y)); %real
    ite = ite + 1;
    % print some numbers for debug purposes	
    if param.display
        fprintf(' %d   %f   %f  %f\n', ite,lambda,norm(X(:),1),norm(x(:)-x0(:))/norm(x0(:)));
    end
    % stopping criteria 
	if (ite > param.nite-1) || (norm(x(:)-x0(:))<param.tol*norm(x0(:))), break;end
    
end
return;

function y=SoftThresh(x,p)
y=(abs(x)-p).*x./abs(x).*(abs(x)>p);    