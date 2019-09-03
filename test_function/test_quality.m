clc;
clear;

% Chat luong anh 95%
quality = 95;

try
    % Add path common function
    addpath('../common_function'); 
    
    [fWM, pthWM] = doc_hinh('Chon anh watermarking');
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end
    
    fprintf('Doc watermarking image\n');
    wm = imread([pthWM, fWM]);
    subplot(1, 2, 1), imshow(wm), title('Watermarking');
    fprintf('Ket thuc doc watermarking image\n');

    fprintf("Thuc nghiem tan cong bang cach nen anh\n");      
    header = sprintf('Luu anh nen chat luong %d%c', quality, '%');
    [fIQ, pthIQ, flIQ] = viet_hinh(header, wm, quality);
    fprintf("Ket thuc nghiem tan cong bang cach nen anh\n");

    if (~isequal(fIQ, 0) && ...
        ~isequal(pthIQ, 0) && ...
        ~isequal(flIQ, 0))
        fprintf("Xem ket qua tan cong bang cach nen anh\n");

        img_quality = imread([pthIQ, fIQ]);
        header = sprintf('Chat luong anh %d%c', quality, '%');
        subplot(1, 2, 2), imshow(img_quality), title(header);

        fprintf("Ket thuc xem ket qua tan cong bang cach nen anh\n");
    end
catch ME
    fprintf("Error trong qua trinh kiem tra peak signal-to-noise ratio\n");
    rethrow(ME);
end
