clc;
clear;

try
    % Add path common function
    addpath('../../common_function');
    
    % Chon anh goc
    [fOrigin, pthOrigin] = doc_hinh('Chon anh goc');
    if (isequal(fOrigin,0) && ...
        isequal(pthOrigin, 0))
        fprintf('Hinh nhu ban khong chon origin\n');
        return;
    end
    
    % Chon inage watermarked
    [fWatermarked, pthWatermarked] = doc_hinh("Chon anh Watermarked");
    if (isequal(fWatermarked,0) && ...
        isequal(pthWatermarked, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end

    % Cai dat mang figure
    f = figure('Name', 'Thuc hien triet xuat DWT');

    % Doc vat mang
    fprintf('Lay anh origin\n');
    orig = imread([pthOrigin, fOrigin]);
    figure(f), subplot(2,2,1), imshow(orig), title('Origin');
    fprintf('Ket thuc lay anh origin\n');

    % Doc anh nhung
    fprintf('Doc watermarked image\n');
    watermarked = imread([pthWatermarked, fWatermarked]);
    figure(f), subplot(2,2,2), imshow(watermarked), title('Watermarked');
    fprintf('Ket thuc doc watermarked image\n');

    % Thuc thi hybrid domain
    fprintf('Thuc thi dwt2\n');

    % Vat mang
    [oA, oH, oV, oD] = dwt2(orig, 'bior1.1');

    % Vat nhung
    [wA, wH, wV, wD] = dwt2(watermarked, 'bior1.1');

    fprintf('Ket thuc thi dwt2\n');

    % Thuc thi trich xuat du lieu
    fprintf('Thuc thi trich xuat du lieu\n');
    messageA = (wA - oA) / 0.03;
    figure(f), subplot(2,2,3), imshow(uint8(messageA)), title('Asset Approximation');
    fprintf('Ket thuc thi trich xuat du lieu\n');

    % Luu lai anh Asset 
    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu trich xuat du lieu', uint8(messageA));
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf('Error trong qua trinh triet xuat du lieu\n');
    rethrow(ME);
end
