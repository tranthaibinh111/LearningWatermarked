clc;
clear;

% Goc xoay hinh
rotate = 9;

try
    % Add path common function
    addpath('../common_function'); 
    
    [fWM, pthWM] = doc_hinh('Chon anh watermarked');
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end
    
    fprintf('Doc watermarking image\n');
    wm = imread([pthWM, fWM]);
    subplot(1, 2, 1), imshow(wm), title('Watermarking');
    fprintf('Ket thuc doc watermarking image\n');

    fprintf('Thuc thi xoay hinh\n');
    wm_rotate = imrotate(wm, 9);

    header = sprintf('Xoay hinh voi goc %d do', rotate);
    [fIR, pthIR, flIR] = viet_hinh(header, wm_rotate);
    fprintf("Ket thuc nghiem tan cong bang cach nen anh\n");

    if (~isequal(fIR, 0) && ...
        ~isequal(pthIR, 0) && ...
        ~isequal(flIR, 0))
        fprintf("Xem ket qua tan cong bang cach xoay hinh\n");

        img_rotate = imread([pthIR, fIR]);
        header = sprintf('Xoay hinh voi goc %d do', rotate);
        subplot(1, 2, 2), imshow(img_rotate), title(header);

        fprintf("Ket thuc xem ket qua tan cong bang cach xoay hinh\n");
    end
catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
