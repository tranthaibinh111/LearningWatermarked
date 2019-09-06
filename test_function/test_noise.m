clc;
clear;

% Chat luong anh 85%
noise = 0.02;

try
    % Add path common function
    addpath('../common_function'); 
    
    [fWM, pthWM] = doc_hinh('Chon anh');
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon anh\n');
        return;
    end
    
    fprintf('Doc image\n');
    wm = imread([pthWM, fWM]);
    subplot(1, 2, 1), imshow(wm), title('Hinh anh');
    fprintf('Ket thuc doc image\n');

    fprintf("Thuc nghiem tan cong bang cach noise\n");  
    image_noise = imnoise(wm, 'salt & pepper', noise);
    header = sprintf('Luu anh noise %0.2f', noise);
    [fIQ, pthIQ, flIQ] = viet_hinh(header, image_noise);
    fprintf("Ket thuc nghiem tan cong bang cach noise\n");

    if (~isequal(fIQ, 0) && ...
        ~isequal(pthIQ, 0) && ...
        ~isequal(flIQ, 0))
        fprintf("Xem ket qua tan cong bang cach noise\n");

        image_noise = imread([pthIQ, fIQ]);
        header = sprintf('Anh noise %0.2f', noise);
        subplot(1, 2, 2), imshow(image_noise), title(header);

        fprintf("Ket thuc xem ket qua tan cong bang cach noise\n");
    end
catch ME
    fprintf("Error trong qua trinh tan cong noise anh\n");
    rethrow(ME);
end
