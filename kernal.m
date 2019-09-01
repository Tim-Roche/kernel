rgbImage = imread('flower.png');
% Extract color channels.
redChannel = double(rgbImage(:,:,1)); % Red channel
greenChannel = double(rgbImage(:,:,2)); % Green channel
blueChannel = double(rgbImage(:,:,3)); % Blue channel

meanBlur(1:3,1:3) = 1;

gaussian = [1,2,1;2,4,2;1,2,1];

mean_redResult = applyKernal_withExtend(redChannel, meanBlur);
mean_greenResult = applyKernal_withExtend(greenChannel, meanBlur);
mean_blueResult = applyKernal_withExtend(blueChannel, meanBlur);

mean_finalResult = cat(3, mean_redResult, mean_greenResult, mean_blueResult);

gaussian_red = applyKernal_withExtend(redChannel, gaussian);
gaussian_green = applyKernal_withExtend(greenChannel, gaussian);
gaussian_blue = applyKernal_withExtend(blueChannel, gaussian);

gaussian_finalResult = cat(3, gaussian_red, gaussian_green, gaussian_blue);

%Presenting Results
fontSize = 20;

subplot(2,3,2);
imshow(rgbImage);
title('Original RGB Image', 'FontSize', fontSize)

subplot(2,3,4);
imshow(mean_finalResult);
title('Mean Blur', 'FontSize', fontSize)

subplot(2,3,6);
imshow(gaussian_finalResult);
title('Gaussian Blur', 'FontSize', fontSize)

function extended = addExtension(mat, extendY, extendX)
    [sizeY, sizeX] = size(mat);
    topExtension = repmat(mat(1,:),extendY,1);
    botExtension = repmat(mat(sizeY,:),extendY,1);
    extended = [topExtension; mat; botExtension]; %top and bottom are now extended
    leftExtension = repmat(extended(:,1),1, extendX);
    rightExtension = repmat(extended(:,sizeX), 1, extendX);
    extended = [leftExtension, extended, rightExtension]; %Now extended in all directions
end

function output = removeExtension(channel, yK, xK)
    [ySize,xSize] = size(channel);    
    output = channel(yK+1:ySize-yK, xK+1: xSize-xK);
end

function output = applyKernal_ignoredEdges(channel, kernal, yK, xK)
    [ySize,xSize] = size(channel);
    sumOfKernal = sum(sum(kernal));
    output = uint8(zeros(ySize, xSize));
    for ySelect = 2:(ySize-1)
        for xSelect = 2:(xSize-1)
            channelSelect = channel(ySelect-yK:ySelect+yK, xSelect-xK:xSelect+xK);
            sumOfDots = sum(dot(channelSelect, kernal));
            value = sumOfDots/sumOfKernal;
            output(ySelect, xSelect) = uint8(value);
        end
    end
end

function output = applyKernal_withExtend(channel, kernal)
    [yK, xK] = size(kernal);
    disp(yK);
    %Gets extension amounts for y and x
    yK = floor(yK/2); 
    xK = floor(xK/2);
    %Now adding the extension
    exChannel = addExtension(channel, yK, xK);
    output = applyKernal_ignoredEdges(exChannel, kernal, yK, xK);
    output = removeExtension(output, yK, xK)
end

