function Pb=bootstrap(M);

[nx,ny,nt]=size(M);
width=3; widthG=3; Nsample=2; rankM=30;
%% construction of slice shift
trainM=zeros(nx,ny,nt*(2*width+1)*(2*width+1) + nt*Nsample);
m=1;
for x=-width:width
    for y=-width:width
%         if (x==0) && (y==0)
%             m
%         end
        tmpM=M-circshift(M,[x y]);
        trainM(:,:,1+nt*(m-1):nt*m)=tmpM;
        m=m+1;
    end
end
%% construction of Gaussian distribution
for n=1:Nsample
    tmpM=zeros(nx,ny,nt);
    for t=1:nt
        for x=floor(widthG./2)+1:nx-floor(widthG./2)
            for y=floor(widthG./2)+1:ny-floor(widthG./2)
                patch=M(x-floor(widthG./2):x+floor(widthG./2),y-floor(widthG./2):y+floor(widthG./2),t);
                tmpM(x,y,t)=patch(randperm(widthG*widthG,1));
            end
        end
    end
    tmpM=M-tmpM;
    tmpM(1:floor(widthG./2),:,:)=0;
    tmpM(:,1:floor(widthG./2),:)=0;
    tmpM(nx-floor(widthG./2)+1:end,:,:)=0;
    tmpM(:,ny-floor(widthG./2)+1:end,:)=0;
    trainM(:,:,1+nt*(m-1):nt*m)=tmpM;
    m=m+1;
end

%% construction of background subspace
[U S V]=svd(reshape(trainM,[nx*ny,nt*(2*width+1)*(2*width+1)+nt*Nsample]),0);
Pb=U(:,1:rankM);
% Pb=trainM;
% figure, plot(diag(S))
end