function [d,SM]=temporalaverage(ref,data)

y= ref + data;
M=abs(y)>0;
SM=sum(M,3);
index1=find(SM==0);
SM(index1)=1;

d = sum(y,3)./SM;
SM(index1)=0;
index2= SM>0;
SM(index2)=1;

end