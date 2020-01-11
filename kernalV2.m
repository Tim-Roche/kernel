rgbImage = imread('flower.png');

meanBlur(1:3,1:3) = 1;
meanOut = kernalConv(rgbImage, meanBlur);

gaussian = [1,2,1;
            2,4,2;
            1,2,1];

gaussianOut = kernalConv(rgbImage, gaussian);

%Presenting Results
fontSize = 20;

subplot(2,3,2);
imshow(rgbImage);
title('Original RGB Image', 'FontSize', fontSize)

subplot(2,3,4);
imshow(meanOut);
title('Mean Blur', 'FontSize', fontSize)

subplot(2,3,6);
imshow(gaussianOut);
title('Gaussian Blur', 'FontSize', fontSize)


function output = kernalConv(image, kernal)
   image = double(image);
   [maxY, maxX, maxZ] = size(image);
   kSize = size(kernal);
   reach = floor(kSize(1)/2);
   
   kern3d = repmat(kernal, 1, 1, 3);
   output = uint8(zeros(maxY-reach, maxX-reach, maxZ));
   
   ksum = sum(sum(kernal));
   for midX = reach+1:maxX-reach
       for midY = reach+1:maxY-reach
           imWindow = image(midY-reach:midY+reach,midX-reach:midX+reach, :);
           windowConv = sum(dot(kern3d, imWindow));
           windowConv = windowConv/ksum;
           output(midY, midX, :) = uint8(windowConv);    
       end
   end
end 