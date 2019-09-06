clc;
clear;

try
    % Add path common function
    addpath('../common_function'); 
    % Cai dat mang figure
    f = figure('Name', 'Thuc tinh peak signal-to-noise ratio');
    
    [fOrigin, pthOrigin] = doc_hinh('Chon anh goc');
    if (isequal(fOrigin, 0) && ...
        isequal(pthOrigin, 0))
        fprintf('Hinh nhu ban khong chon origin\n');
        return;
    end
    
    [fWM, pthWM] = doc_hinh('Chon anh watermarking');   
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end
    
    fprintf('Doc origin image\n');
    orig = imread([pthOrigin, fOrigin]);
    figure(f), subplot(1, 3, 1), imshow(orig), title('Origin Gray');
    fprintf('Ket thuc doc origin image\n');
    fprintf('Doc watermarking image\n');
    wm = imread([pthWM, fWM]);
    figure(f), subplot(1, 3, 2), imshow(wm), title('Watermarking');
    fprintf('Ket thuc doc watermarking image\n');

    fprintf('Tinh peak signal-to-noise ratio cho watermarking\n');
    [peaksnr, snr] = psnr(wm, orig);
    if isequal(peaksnr, Inf)
        peaksnr = 1.00;
    end

    result = sprintf('%0.2f%c', peaksnr, '%');
    [r,c] = size(wm);
    psnr_img = insertText( ...
        wm, ...
        [int32(r*0.125) int32(c*0.125)], ...
        result, ...
        'FontSize', 18, ...
        'BoxColor', 'green', ...
        'TextColor', 'black');

    fprintf('Ket qua tinh peak signal-to-noise ratio: %s\n', result);
    figure(f)
    subplot(1, 3, 3)
    imshow(psnr_img)
    title('Ket qua tinh peak signal-to-noise ratio');
    fprintf('Ket thuc tinh peak signal-to-noise ratio cho watermarking\n');

    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu peak signal-to-noise ratio', psnr_img);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh kiem tra peak signal-to-noise ratio\n");
    rethrow(ME);
end