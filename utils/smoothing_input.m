function [X_norm_smooth] = smoothing_input(inputArg1)

X_norm_smooth=zeros(size(inputArg1));
for i=1:size(inputArg1,1)
    for j=1:size(inputArg1,2)
        X_norm_smooth(i,j,:) = smooth(squeeze(inputArg1(i,j,:)-inputArg1(i,j,1)));
    end
end

end

