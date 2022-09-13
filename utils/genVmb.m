function [ S,Vmb ] = genVmb( param )
%Construct model-based dictionary  Vmb
%   Detailed explanation goes here

S=[];
for t_max=param.tmax_st:.1:param.tmax_ed
    for alpha=param.alpha-3:.5:param.alpha+3
        beta_ref=t_max/alpha;
        for beta= beta_ref-0.1:.01:beta_ref+0.4
            
            A = 1 / (beta^(alpha+1) * gamma(alpha+1));
           
            for t=1:param.t_end
                G(t) = A * ((t-param.t0)^alpha) * exp(-(t-param.t0)/beta);
            end
            
            S=cat(1,S,G);
            G=[];
            
        end
    end
end

if param.fig
    figure,plot(abs(S(1:30:end,:)'))
end

[u, si, Vmb]=svd(S.'*S,'econ');

end

