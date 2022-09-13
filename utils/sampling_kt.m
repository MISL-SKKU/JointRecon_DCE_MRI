function mask = sampling_kt(params)

mask = zeros(params.Nky, params.Nt);
mask(1:params.ORF:params.Nky,:) = 1;

    for t=1:params.Nt
        mask(:,t) = circshift(mask(:,t), [mod(t-1,params.ORF) 0]);
    end

mask = repmat(mask,[1 1 params.Nkx]);
mask = permute(mask,[1 3 2]);

mask(params.Nky/2 - floor((params.NACS-1)/2):params.Nky/2 + floor(params.NACS/2),:,:) = 1;

end
