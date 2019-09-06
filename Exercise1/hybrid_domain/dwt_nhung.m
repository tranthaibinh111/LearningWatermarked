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
    f1 = figure('Name', 'Thuc hien DWT voi anh goc');
    f2 = figure('Name', 'Thuc hien DWT voi anh message');
    f3 = figure('Name', 'Thuc hien nhung DWT');

    % Doc vat mang
    fprintf('Lay anh origin\n');
    orig = imread([pthOrigin, fOrigin]);
    fprintf('Ket thuc lay anh origin\n');

    % Doc anh nhung
    fprintf('Doc message image\n');
    message = imread([pthMessage, fMessage]);
    fprintf('Ket thuc doc message image\n');

    % Thuc thi hybrid domain
    fprintf('Thuc thi dwt2\n');

    % Vat mang
    [oA, oH, oV, oD] = dwt2(orig, 'bior1.1');
    figure(f1), subplot(2,2,1), imshow(abs(oA),[]), title('Origin Approximation');
    figure(f1), subplot(2,2,2), imshow(abs(oH),[0 60]), title('Origin Horizontal');
    figure(f1), subplot(2,2,3), imshow(abs(oV),[0 60]), title('Origin Vertical');
    figure(f1), subplot(2,2,4), imshow(abs(oD),[0 60]), title('Origin Diagonal');

    % Vat nhung
    [wA, wH, wV, wD] = dwt2(message, 'bior1.1');
    figure(f2), subplot(2,2,1), imshow(abs(wA),[]), title('Message Approximation');
    figure(f2), subplot(2,2,2), imshow(abs(wH),[0 60]), title('Message Horizontal');
    figure(f2), subplot(2,2,3), imshow(abs(wV),[0 60]), title('Message Vertical');
    figure(f2), subplot(2,2,4), imshow(abs(wD),[0 60]), title('Message Diagonal');

    fprintf('Ket thuc thi dwt2\n');

    % Thuc thi nhung du lieu
    fprintf('Thuc thi nhung du lieu\n');
    wA = oA + (0.03*wA);
    watermarked = idwt2(wA, oH, oV, oD, 'bior1.1');
    figure(f3), imshow(uint8(watermarked)), title('Watermarked');
    fprintf('Ket thuc thi nhung du lieu\n');

    % Luu lai anh Watermarked
    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu Watermarked', uint8(watermarked));
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf('Error trong qua trinh nhung du lieu\n');
    rethrow(ME);
end
