function [outputArg1] = smoothing_spatial(inputArg1,block)
outputArg1 = zeros(size(inputArg1));
for i=block+1:size(inputArg1,1)-block-1
    for j=block+1:size(inputArg1,2)-block-1
        outputArg1(i,j,:) = smooth(squeeze(mean(mean(squeeze(abs(inputArg1(i-block:i+block,j-block:j+block,:)))))));
    end
end
end

