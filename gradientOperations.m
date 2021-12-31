function [prewittmagnitude, prewittangle] = gradientOperations(inputImageMatrix)

%% Store input size and initialize matrix
image = inputImageMatrix;
sizeImage = size(image);
gradientx = zeros(sizeImage);
gradienty = zeros(sizeImage);

%% Calculate the X and Y gradient using the formula
for i=2:sizeImage(1)-1
    for j=2:sizeImage(2)-1
        gradientx(i,j)=image(i-1,j+1)-image(i-1,j-1)+image(i,j+1)-image(i,j-1)+image(i+1,j+1)-image(i+1,j-1);
        gradienty(i,j)=image(i-1,j-1)-image(i+1,j-1)+image(i-1,j)-image(i+1,j)+image(i-1,j+1)-image(i+1,j+1);
    end
end

%% Calculate magnitude using squared sum method
prewittmagnitude = sqrt(gradientx.^2+ gradienty.^2);

% Normalize the Components after the gradient operation to display the
% Image correctly in the range of 0-255
prewittmagnitude = round(normalizeImage(prewittmagnitude));

%% Calculate the angle using tan-1
prewittangle =atan2d(gradienty,gradientx);
prewittangle(isnan(prewittangle))=0;

% If the angle are less than 0, then increment 180
% Range of angle should between 0-180
for i = 1:sizeImage(1)
    for j = 1:sizeImage(2)
        if(prewittangle(i,j)<0)
            prewittangle(i,j)=prewittangle(i,j)+180;
        end
    end
end

prewittmagnitude;
prewittangle;
