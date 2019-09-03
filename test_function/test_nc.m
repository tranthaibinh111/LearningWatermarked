clc;
clear;

try
    % Add path common function
    addpath('../common_function'); 
    % Cai dat mang figure
    f = figure('Name', 'Thuc tinh Normalise Correlation');
    
    [fOrigin, pthOrigin] = doc_hinh('Chon anh goc');
    if (isequal(fOrigin, 0) && ...
        isequal(pthOrigin, 0))
        fprintf('Hinh nhu ban khong chon origin\n');
        return;
    end
    
    fprintf('Doc origin image\n');
    orig = imread([pthOrigin, fOrigin]);
    figure(f), subplot(1, 3, 1), imshow(orig), title('Origin Gray');
    fprintf('Ket thuc doc origin image\n');
    
    [fWM, pthWM] = doc_hinh('Chon anh watermarking');   
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end    

    fprintf('Doc watermarking image\n');
    wm = imread([pthWM, fWM]);
    figure(f), subplot(1, 3, 2), imshow(wm), title('Watermarking');
    fprintf('Ket thuc doc watermarking image\n');

    fprintf('Tinh normalise correlation cho watermarking\n');
    [m, n] = size(orig);
    nu = 0;
    de = 0;
    
    for i = 1:m
        for j = 1:n
            nu = nu + (orig(i,j) * wm(i,j));
            de = de + orig(i,j) * orig(i,j);
        end
    end   

    nc = nu / de;
    result = sprintf('%0.2f%c', nc, '%');
    psnr_img = insertText( ...
        wm, ...
        [int32(m*0.125) int32(n*0.125)], ...
        result, ...
        'FontSize', 10, ...
        'BoxColor', 'green', ...
        'TextColor', 'black');

    fprintf('Ket qua tinh normalise correlation: %s\n', result);
    figure(f)
    subplot(1, 3, 3)
    imshow(psnr_img)
    title('Ket qua tinh normalise correlation');
    fprintf('Ket thuc tinh normalise correlation cho watermarking\n');

    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu normalise correlation', psnr_img);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh tinh normalise correlation\n");
    rethrow(ME);
end