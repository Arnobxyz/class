clc;
template = imread('prl_database.jpg');
tem2gray = rgb2gray(template);
feature = imread('D.jpg');
fea2gray = rgb2gray(feature);
tem_thres = graythresh(tem2gray);
tem2bin = imbinarize(tem2gray,tem_thres);
fea_thresh = graythresh(fea2gray);
fea2bin = imbinarize(fea2gray,fea_thresh);
tem_complement = imcomplement(tem2bin);
fea_complement = imcomplement(fea2bin);

[height,weight] = size(tem_complement);
[height2,weight2] = size(fea_complement);

sum = 0;
for i = 1:height2
    for j = 1: weight2
        sum = sum + fea_complement(i,j);
    end
end

fea_mean = sum/(height2*weight2);

ncc_value = zeros(1,10);
current = 1;
for x = 1:10
    sum = 0;
    for i = 1:height
        for j =current:current+29
            sum = sum+tem_complement(i,j);
        end
    end
    
    tem_mean = sum/(height2*weight2);
    
    x1 = 0;
    x2 = 0;
    x3 = 0;
    
    a = 1;
    for i =1:height
        b= 1;
        for j = current:current+29
            x1= x1+(tem_complement(i,j)-tem_mean)*(fea_complement(a,b)-fea_mean);
            x2 = x2 + tem_complement(i,j)^2;
            x3 = x3 + fea_complement(a,b)^2;
            b=b+1;
        end
        a= a+1;
    end
    
    c= x1/sqrt(x2*x3);
    ncc_value(x) = c;
    current = current+30;
end

fprintf("Value of NCC\n");
for i=1:10
    fprintf('%.2f\n',ncc_value(i));
end

[value,index] = max(ncc_value);
fprintf('\n Matched With %d\n', index-1);
subplot(3,1,1);
imshow(tem_complement);
title('Template Image');
subplot(3,1,2);
imshow( fea_complement);
title('Cndidate Image');
subplot(3,1,3);
imshow(tem_complement);
title('Best Match shown by red rectangle box');
rectangle('Position',[(index-1)*weight2 5 weight2 height2], 'Edgecolor','r');