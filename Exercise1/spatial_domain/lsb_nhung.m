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
    
    % Chon anh nhung
    [fMessage, pthMessage] = doc_hinh('Chon anh nhung');
    if (isequal(fMessage,0) && ...
        isequal(fMessage, 0))
        fprintf('Hinh nhu ban khong chon message\n');
        return;
    end

    % Cai dat mang figure
    f1 = figure('Name', 'Thuc hien doc anh goc va message');
    f2 = figure('Name', 'Thuc hien bitplane voi anh goc');
    f3 = figure('Name', 'Thuc hien bitplane voi message');
    f4 = figure('Name', 'Thuc hien nhung LSB');

    % Doc vat mang
    fprintf('Doc origin image\n');
    orig = imread([pthOrigin, fOrigin]);
    fprintf('Ket thuc doc origin image\n');

    % Doc anh nhung
    fprintf('Doc message image\n');
    message = imread([pthMessage, fMessage]);
    fprintf('Ket thuc doc message image\n');

    % Show vat mang va anh nhúng
    figure(f1), subplot(1,2,1), imshow(orig), title('Origin');
    figure(f1), subplot(1,2,2), imshow(message), title('Message');

    % Thuc thi lay cac bit trong vat mang
    fprintf('Thuc thi lay bit cho origin image\n');
    [B8,B7,B6,B5,B4,B3,B2,B1] = bitplane(orig);
    figure(f2), subplot(2,4,1), imshow(B8), title('Bit plane 8');
    figure(f2), subplot(2,4,2), imshow(B7), title('Bit plane 7');
    figure(f2), subplot(2,4,3), imshow(B6), title('Bit plane 6');
    figure(f2), subplot(2,4,4), imshow(B5), title('Bit plane 5');
    figure(f2), subplot(2,4,5), imshow(B4), title('Bit plane 4');
    figure(f2), subplot(2,4,6), imshow(B3), title('Bit plane 3');
    figure(f2), subplot(2,4,7), imshow(B2), title('Bit plane 2');
    figure(f2), subplot(2,4,8), imshow(B1), title('Bit plane 1');
    fprintf('Ket thuc thi lay bit cho origin image\n');

    % Thuc thi lay cac bit trong vat nhung
    fprintf('Thuc thi lay bit cho asset image\n');
    [BW8,BW7,BW6,BW5,BW4,BW3,BW2,BW1] = bitplane(message);
    figure(f3), subplot(2,4,1), imshow(BW8), title('Bit plane 8');
    figure(f3), subplot(2,4,2), imshow(BW7), title('Bit plane 7');
    figure(f3), subplot(2,4,3), imshow(BW6), title('Bit plane 6');
    figure(f3), subplot(2,4,4), imshow(BW5), title('Bit plane 5');
    figure(f3), subplot(2,4,5), imshow(BW4), title('Bit plane 4');
    figure(f3), subplot(2,4,6), imshow(BW3), title('Bit plane 3');
    figure(f3), subplot(2,4,7), imshow(BW2), title('Bit plane 2');
    figure(f3), subplot(2,4,8), imshow(BW1), title('Bit plane 1');
    fprintf('Ket thuc thi lay bit cho asset image\n');

    % Thuc thi nhung
    fprintf('Thuc thi watermarking\n');
    watermarked = B8+B7+B6+B5+B4+BW8/2^5+BW7/2^5+BW6/2^5;
    figure(f4), imshow(watermarked), title('Watermarked');
    fprintf('Ket thuc thi watermarking\n');

    % Luu ke qua thuc thi nhung
    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu anh Watermarked', watermarked);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf('Co loi trong qua trinh nhung du lieu\n');
    rethrow(ME);
end

