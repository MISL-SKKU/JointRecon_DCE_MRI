function [MASKING] = tumor_masking(X_norm,patch_size_y,patch_size_z,threshold)


%%% smoothing signal time course %%%
norm_X=X_norm./max(abs(X_norm(:)));
[X_norm_smooth] = smoothing_input(abs(norm_X));
MASKING=(X_norm_smooth(patch_size_y,patch_size_z,170));
MASKING(MASKING<threshold)=0;
MASKING(MASKING>=threshold)=1;
end

