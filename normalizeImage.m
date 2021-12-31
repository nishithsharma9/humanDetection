function normalizedMatrix = normalizeImage(imageMatrix)

% Check what is the lowest value
lo = min(min(imageMatrix));

% Adjust low to 0
if(lo<0)
    imageMatrix=imageMatrix+abs(lo);
end

% Check the highest and the normalize all values by 
% scalling factor to get in 0-255 range
hi=max(max(imageMatrix));
if(hi>255)
    normalizeComponent=255/hi;
    imageMatrix = imageMatrix.*normalizeComponent;
end

%% Return Values
new_lo = min(min(imageMatrix));
new_hi = max(max(imageMatrix));
normalizedMatrix = imageMatrix;
