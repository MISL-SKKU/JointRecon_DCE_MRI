function res = datasharing(kdata,mask,mask_high,Nsharing);

[ny nz nt]=size(mask);
res=zeros(size(kdata));
maskshared=zeros(ny,nz,nt+Nsharing-1); datashared=maskshared;
maskshared(:,:,1:nt)=mask_high; datashared(:,:,1:nt)=kdata;
if Nsharing>1
    maskshared(:,:,nt+1:end)=mask_high(:,:,nt-Nsharing+1:end-1);
    datashared(:,:,nt+1:end)=kdata(:,:,nt-Nsharing+1:end-1);
end
res(:,:,1)=kdata(:,:,1);

for t=2:nt
    tmp1=res(:,:,t);
    if Nsharing>1
        for s=Nsharing-2:-1:-1
            idxM=maskshared(:,:,t+s)>0;
            tmp2=datashared(:,:,t+s);
            tmp1(idxM)=tmp2(idxM);
        end
    end
    idxM=mask(:,:,t)>0;
    tmp3=kdata(:,:,t);
    tmp1(idxM)=tmp3(idxM);
    res(:,:,t)=tmp1;
end
