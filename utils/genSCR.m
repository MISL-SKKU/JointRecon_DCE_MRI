function [ S,Vmb ] = genSCR( param )
%Construct model-based dictionary  Vmb
%   Detailed explanation goes here

newS=[];
for t_max=param.tmax_st:.2:param.tmax_ed
    for alpha=param.alpha-3:.5:param.alpha+3
        beta_ref=t_max/alpha;
        for beta= beta_ref-0.1:.5:beta_ref+0.3
            
            A = 1 / (beta^(alpha+1) * gamma(alpha+1));
           
            for t=1:param.t_end
                G(t) = A * ((t-param.t0)^alpha) * exp(-(t-param.t0)/beta);
                intG(t) = -(A*beta*(t - param.t0)^alpha*igamma(alpha + 1, (t - param.t0)/beta))/((t - param.t0)/beta)^alpha;
                newG(t)=G(t)+0.05*intG(t);
            end
            
            newS=cat(1,newS,newG);
            G=[];
            intG=[];
            newG=[];
            
        end
    end
end

if param.fig
    figure,plot(abs(newS(1:10:end,:)'))
end




[u, si, Vmb]=svd(newS.'*newS,'econ');

end

