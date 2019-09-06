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
    
    [fM, pthM] = doc_hinh('Chon anh trich xuat');   
    if (isequal(fM, 0) && ...
        isequal(pthM, 0))
        fprintf('Hinh nhu ban khong chon anh trich xuat\n');
        return;
    end    

    fprintf('Doc anh trich xuat\n');
    message = imread([pthM, fM]);
    figure(f), subplot(1, 3, 2), imshow(message), title('Anh trich xuat');
    fprintf('Ket thuc doc anh trich xuat\n');

    fprintf('Tinh normalise correlation cho anh trich xuat\n');
    [m, n] = size(orig);
    nu = double(0);
    de = double(0);
    
    for i = 1:m
        for j = 1:n
            nu = nu + double(orig(i,j)) * double(message(i,j));
            de = de + double(orig(i,j)) * double(orig(i,j));
        end
    end   

    nc = (nu / de) * 100;
    result = sprintf('%0.2f%c', nc, '%');
    psnr_img = insertText( ...
        message, ...
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
    fprintf('Ket thuc tinh normalise correlation cho anh trich xuat\n');

    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu normalise correlation', psnr_img);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh tinh normalise correlation\n");
    rethrow(ME);
end