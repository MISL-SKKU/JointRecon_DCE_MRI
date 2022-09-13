function [Samp Reordercounter Samp_high] = radiallike(n1,n2,n3,line,NNyq,reordernumber,inc);

ang=0;
 for frameno = 1:n3,
     
%    
      y=-n1/2:1:n1/2-0.5;  % Create an array of N points between -n1/2 and n1/2
      x=(linspace(-n2/2,n2/2,length(y)));
      i=1;
      

    
     % Loop to traverse the kspace ; 0 to pi in steps of pi/lines -- 
     % Succesive frames rotated by a small random angle (pi/line)*rand (see
     % above)
   
     while i<line+1
%      for ang=0:pi/line:pi-1e-3;
         klocn=complex(y*cos(ang+ (inc)),x*sin(ang+ (inc)));
         kloc_all(:,i)=klocn;
         i=i+1; ang=ang+111.25*pi/180;
     end
     
     
     % Round the collected data to the nearest cartesian location   
     kcart=round(kloc_all+(0.5+0.5*1i));
     % plot(kcart,'*');title('k locations after nearest neighbor interpolation: Center (0,0)');
%     
%     
    % Next, shift the cartesian locations accordingly such that the center
    % is now at (n1/2,n1/2); {Previously the center in kcart was (0,0)}
    kloc1 = round(kcart)+((n1/2+1)+(n2/2+1)*1i);
    kloc1real = real(kloc1); kloc1real = kloc1real - n1*(kloc1real>n1);
    kloc1imag = imag(kloc1); kloc1imag = kloc1imag - n2*(kloc1imag>n2);
    kloc1real = kloc1real + n1*(kloc1real<1);
    kloc1imag = kloc1imag + n2*(kloc1imag<1);
    kloc1 = kloc1real + 1i*kloc1imag;
    

    centerlines=floor(size(kloc1,1)/2); 
    idx_sampling1=1:2:size(kloc1,1);
%   idx_sampling1=1:size(kloc1,1);
    idx_sampling2=centerlines-NNyq:centerlines+NNyq;
    idx_sampling=union(idx_sampling1,idx_sampling2);
    size(idx_sampling)
    if frameno == 1
        size(idx_sampling)
    end
    
    n=1;
    for i=1:size(kloc1,1)
        if ismember(i,idx_sampling1)
            if ~ismember(i,idx_sampling2)
                idx_sampling3(n)=i;
                n=n+1;
            end
        end
    end
%
%   Create the sampling pattern
%     shift=randperm(4)-0; 
%     shift=zeros(1,2);
mask = zeros (n1,n2);
reordercounter=0;
% && reordercounter< reordernumber

    for j=1:size(kloc1,2)     
           for i=idx_sampling           
               if ismember(i,idx_sampling3)
                shift=randperm(5)-3; % 5
                if real(kloc1(i,j))+shift(1)<=0 || imag(kloc1(i,j))+shift(2)<=0 || real(kloc1(i,j))+shift(1)> n1 || imag(kloc1(i,j))+shift(2)>n2                 
                   if mask(real(kloc1(i,j)),imag(kloc1(i,j)))==0  && reordercounter< reordernumber 
                    Samp_high (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    Samp      (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    mask(real(kloc1(i,j)),imag(kloc1(i,j)))=1; 
                    reordercounter=reordercounter+1;
                   else
                   end
                else
                    if mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))==0  && reordercounter< reordernumber 
                    Samp_high (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
                    Samp      (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
                    mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))=1; 
                    reordercounter=reordercounter+1;
                    else
                    end
                end
            else
                shift=randperm(8)-3;  %5
                   if mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))==0  && reordercounter< reordernumber 
                    Samp      (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
%                   Samp      (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))=1;  
                    reordercounter=reordercounter+1;               
                   else
                   end
            end
%     figure(100),(imshow(abs(mask)));drawnow;            
        end
    end

    
if (reordercounter < reordernumber)
    for j=1:size(kloc1,2)     
           for i=idx_sampling           
            if ismember(i,idx_sampling3)
                shift=randperm(5)-3;
                if real(kloc1(i,j))+shift(1)<=0 || imag(kloc1(i,j))+shift(2)<=0 || real(kloc1(i,j))+shift(1)> n1 || imag(kloc1(i,j))+shift(2)>n2                 
                   if mask(real(kloc1(i,j)),imag(kloc1(i,j)))==0 && reordercounter< reordernumber 
                    Samp_high (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    Samp      (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    mask(real(kloc1(i,j)),imag(kloc1(i,j)))=1; 
                    reordercounter=reordercounter+1;
                   else
                   end
                else
                    if mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))==0   && reordercounter< reordernumber 
                    Samp_high (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
                    Samp      (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
                    mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))=1; 
                    reordercounter=reordercounter+1;
                    else
                    end
                end
            else
                shift=randperm(5)-3;
                   if mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))==0    && reordercounter< reordernumber 
                    Samp      (real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2),frameno) = 1;
%                   Samp      (real(kloc1(i,j)),imag(kloc1(i,j)),frameno) = 1;
                    mask(real(kloc1(i,j))+shift(1),imag(kloc1(i,j))+shift(2))=1;  
                    reordercounter=reordercounter+1;               
                   else
                   end
            end
        if (reordercounter>reordernumber)
            break;
        end            
           end
        if (reordercounter>reordernumber)
            break;
        end           
    end
end

    clear mask 
    Reordercounter(frameno)=reordercounter;
 end
         
end
