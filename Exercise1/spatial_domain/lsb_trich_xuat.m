clc;
clear;

feature('DefaultCharacterSet');

try
    % Add path common function
    addpath('../../common_function');

    % Chon inage watermarked
    [fWatermarked, pthWatermarked] = doc_hinh("Chon anh Watermarked");
    if (isequal(fWatermarked,0) && ...
        isequal(pthWatermarked, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end

    % Cai dat mang figure
    f = figure('Name', 'Thuc hien triet xuat LSB');

    % Doc watermarked
    fprintf('Doc watermarked image\n');
    watermarked = imread([pthWatermarked, fWatermarked]);
    figure(f), subplot(1,2,1), imshow(watermarked), title('Watermarked');
    fprintf('Ket thuc doc watermarked image\n');

    % Lay thong tin cac bit trong watermarked
    fprintf('Triet xuat message tu watermarked\n');
    [W8,W7,W6,W5,W4,W3,W2,W1] = bitplane(watermarked);
    message = W3 * 2^5 + W2 * 2^5 + W1 * 2^5;
    figure(f), subplot(1,2,2), imshow(message), title('Triet xuat du lieu');
    fprintf('Ket thuc triet xuat mesage tu watermarked\n');

    % Luu ket qua triet xuat
    fprintf('Luu ket qua thuc thi\n');
    viet_hinh('Luu anh triet xuat tu Watermarked', message);
    fprintf('Ket thuc luu ket qua thuc thi\n');
catch ME
    fprintf('Co loi trong qua trinh triet xuat du lieu tu Watermarked\n');
    rethrow(ME);
end

