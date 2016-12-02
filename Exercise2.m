% inclass Assignment
% author Apoorva Jain

clear; clc;

pepper_img = imread('peppers.jpg');
hsv_pepper = rgb2hsv(pepper_img);
size = size(hsv_pepper);

%hsv
pepper_h = hsv_pepper(:,:,1);

category = 4;
N = [1, 5, 10];

for n = 1: length(N)
    mean_hue = zeros(1, category);
    imshow(pepper_img);
    for i = 1 : category
        [x, y] = ginput(N(n));
        row = int32(y);
        col = int32(x);
        pixel = zeros(N(n), 1);
        for j = 1: N(n)
            pixel(j) = pepper_h(row(j), col(j));
        end
        mean_hue(i) = mean(pixel);
    end;
    
    sorted_mean_hue = sort(mean_hue);
    range = zeros(category, 2);
    
    for i = 1 : category
        if i == 1
            range(i, 1) = 0;
        else
            range(i, 1) = range(i-1, 2);
        end
        if i == category
            range(i, 2) = 1.0;
        else
            range(i, 2) = (sorted_mean_hue(i) + sorted_mean_hue(i+1))/2;
        end
    end;
    
    pepper_classification = uint8(zeros(255,725));
    
    for i = 1: size(1)
        for j = 1: size(2)
            data_point = pepper_h(i, j);
            if range(1,2) >= data_point
                pepper_classification(i, j) = 0;
            elseif data_point >= range(1, 2) && data_point < range(2,2)
                pepper_classification(i, j) = 1;
            elseif data_point >= range(2, 2) && data_point< range(3,2)
                pepper_classification(i, j) = 2;
            elseif data_point >= range(3,2)
                pepper_classification(i, j) = 3;
            end
        end
    end
    
    pepper_color = uint8(zeros(size));
    for i = 1: category
        [r, c] = find(pepper_classification == i-1) ;
        
        int_r = zeros(length(r), 1);
        int_g = zeros(length(r), 1);
        int_b = zeros(length(r), 1);
        
        for j = 1: length(r)
            int_r(j) = pepper_img(r(j), c(j), 1);
            int_g(j) = pepper_img(r(j), c(j), 2);
            int_b(j) = pepper_img(r(j), c(j), 3);
        end
        
        mean_r = mean(int_r);
        mean_g = mean(int_g);
        mean_b = mean(int_b);
        
        for j = 1: length(r)
            pepper_color(r(j), c(j),1) = mean_r;
            pepper_color(r(j), c(j),2) = mean_g;
            pepper_color(r(j), c(j),3) = mean_b;
        end
    end
    imshow(pepper_color);
    pause(2);
end


