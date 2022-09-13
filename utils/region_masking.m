function [Imask4] = region_masking(inputArg1)
[~,V_mean,V_std,Vfad] = NeckBackground(inputArg1,0,2);
corner =  2; percent = 0;
[Imask,~] = NeckMask(Vfad,[0.3*V_mean,10*V_mean+V_std],corner,percent);
Imask4 = NeckMaskCLean(Imask);
end

