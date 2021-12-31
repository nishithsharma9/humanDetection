function [feature] = hog_vector(Img, displayImage,imageName)
%% Image read operations
rgbImage = imread(Img);
rgbImage = double(rgbImage);

% Use custom channel proportion to get images
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

% Round off the values using the formula to generate matrix
im = round(0.299*redChannel + 0.587*greenChannel + 0.114*blueChannel);
rows=size(im,1);
cols=size(im,2);

%% Gradient Operations to Calculate Magnitude, Gx, Gy and GradientAngle
[magnitude, angle] = gradientOperations(im);

if(displayImage==1)
% Display Image
figure('Name','Prewitt Magnitude');
imshow(matrixToImage(magnitude));
title(imageName)
end

%% Generate the feature

% Initialized the feature vector
feature=[]; 

% Iterations for Blocks(19x11 blocks)
for i = 0: rows/8 - 2
    for j= 0: cols/8 -2
        
        % Each block is of 16x16
        % Getting Block magnitude and angles with overlap
        mag_block = magnitude(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);
        ang_block = angle(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);

        block_feature=[];
        
        % Iterations for cells in a block(2x2 cells in block)
        for x= 0:1
            for y= 0:1
                
                % Each Cell is 8x8 
                % Getting Cell magnitude and angles
                angle_cell =ang_block(8*x+1:8*x+8, 8*y+1:8*y+8);
                mag_cell =mag_block(8*x+1:8*x+8, 8*y+1:8*y+8); 
                histr = zeros(1,9);

                %Iterations for pixels in one cell
                for p=1:8
                    for q=1:8 
                        alpha= angle_cell(p,q);
                        
                        % Division of Magnitude in Buckets proportionally
                        if alpha>10 && alpha<=30
                            histr(1)=histr(1)+ mag_cell(p,q)*(30-alpha)/20;
                            histr(2)=histr(2)+ mag_cell(p,q)*(alpha-10)/20;
                        elseif alpha>30 && alpha<=50
                            histr(2)=histr(2)+ mag_cell(p,q)*(50-alpha)/20;                 
                            histr(3)=histr(3)+ mag_cell(p,q)*(alpha-30)/20;
                        elseif alpha>50 && alpha<=70
                            histr(3)=histr(3)+ mag_cell(p,q)*(70-alpha)/20;
                            histr(4)=histr(4)+ mag_cell(p,q)*(alpha-50)/20;
                        elseif alpha>70 && alpha<=90
                            histr(4)=histr(4)+ mag_cell(p,q)*(90-alpha)/20;
                            histr(5)=histr(5)+ mag_cell(p,q)*(alpha-70)/20;
                        elseif alpha>90 && alpha<=110
                            histr(5)=histr(5)+ mag_cell(p,q)*(110-alpha)/20;
                            histr(6)=histr(6)+ mag_cell(p,q)*(alpha-90)/20;
                        elseif alpha>110 && alpha<=130
                            histr(6)=histr(6)+ mag_cell(p,q)*(130-alpha)/20;
                            histr(7)=histr(7)+ mag_cell(p,q)*(alpha-110)/20;
                        elseif alpha>130 && alpha<=150
                            histr(7)=histr(7)+ mag_cell(p,q)*(150-alpha)/20;
                            histr(8)=histr(8)+ mag_cell(p,q)*(alpha-130)/20;
                        elseif alpha>150 && alpha<=170
                            histr(8)=histr(8)+ mag_cell(p,q)*(170-alpha)/20;
                            histr(9)=histr(9)+ mag_cell(p,q)*(alpha-150)/20;
                        elseif alpha>=0 && alpha<=10
                            histr(1)=histr(1)+ mag_cell(p,q)*(alpha+10)/20;
                            histr(9)=histr(9)+ mag_cell(p,q)*(10-alpha)/20;
                        elseif alpha>170 && alpha<=180
                            histr(9)=histr(9)+ mag_cell(p,q)*(190-alpha)/20;
                            histr(1)=histr(1)+ mag_cell(p,q)*(alpha-170)/20;
                        end
                        
                
                    end
                end
                
                % Concatenation of Four histograms to form one block feature
                block_feature=[block_feature histr];
                  
            end
        end
        
        % Block Normalization using L2 Norm
        block_feature = block_feature/sqrt(sum(block_feature.^2));
        
        %Features concatenation
        feature=[feature block_feature]; 
        
    end
end

% Removing Infinitiy values
feature(isnan(feature))=0; 

feature;