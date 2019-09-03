clc;
clear;

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
    [~, ~, wm_ext] = fileparts(fWM);
    header = sprintf('Watermarking voi doi *.%s', wm_ext);
    subplot(1, 2, 1), imshow(wm), title(header);
    fprintf('Ket thuc doc watermarking image\n');

    fprintf('Thuc hien luu anh voi chat luong khac\n');
    [fIM, pthIM, flIM] = viet_hinh('Luu hinh voi chat luong khac', wm);
    fprintf("Ket thuc hien l?u anh voi chat luong khac\n");

    if (~isequal(fIM, 0) && ...
        ~isequal(pthIM, 0) && ...
        ~isequal(flIM, 0))
        fprintf("Xem ket qua tan cong bang cach xoay hinh\n");

        img_model = imread([pthIM, fIM]);
        [~, ~, wm_model_ext] = fileparts(fIM);
        header = sprintf('Anh moi voi doi *.%s', wm_model_ext);
        subplot(1, 2, 2), imshow(img_model), title(header);

        fprintf("Ket thuc xem ket qua tan cong bang cach xoay hinh\n");
    end
catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
