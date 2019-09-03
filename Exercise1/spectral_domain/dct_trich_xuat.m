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
    
    % Chon anh watermared
    [fWatermarked, pthWatermarked] = doc_hinh('Chon watermarked');
    if (isequal(fWatermarked,0) && ...
        isequal(pthWatermarked, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end
    
    % Chon file excel ghi lai cac diem nhung
    [fCSV, pthCSV] = doc_excel('Chon diem nhung');
    if (isequal(fCSV,0) && ...
        isequal(pthCSV, 0))
        fprintf('Hinh nhu ban khong chon file diem nhung\n');
        return;
    end

    % Cai dat mang figure
    f = figure('Name', 'Thuc hien triet xuat DCT');

    % Doc origin
    fprintf('Doc origin image\n');
    origin = imread([pthOrigin, fOrigin]);
    fprintf('Ket thuc doc origin image\n');

    % Chuyen doi hinh anh mau thanh hinh anh xam
    fprintf('Thuc chuyen anh mau thanh anh xam\n');
    if (size(origin, 3) == 3)
        I = rgb2gray(origin);           
    else
        I = origin;
    end
    subplot(2, 2, 1), imshow(I), title('Origin Gray');
    fprintf('Ket thuc chuyen anh mau thanh anh xam\n');

    % Doc watermarked
    fprintf('Doc watermarked\n');
    watermarked = imread([pthWatermarked, fWatermarked]);
    subplot(2, 2, 2), imshow(watermarked), title('Watermarked');
    fprintf('Ket thuc doc watermarked\n');

    % Doc diem nhung
    fprintf('Doc watermarked point\n');
    points = xlsread([pthCSV, fCSV]);
    % Lay kich thuoc phi csv
    [m, n] = size(points);
    wmsz = m * 1;
    % Gia tri cung voi FS
    Fs = 44100; 
    fprintf('Ket thuc doc watermarked point\n');

    % Thuc thi trich xuat am thanh tu watermarked
    fprintf('Thuc thi tach tin hieu tu watermarked\n');
    % Lay DCT tu origin
    D = dct2(I);
    % Lay DCT tu watermarked
    D_w = dct2(watermarked); 
    % Khai bao matrix zero cho am thanh
    signal = zeros(1, wmsz, 'double');
    % Thuc thi trich xuat am thanh tu watermarked
    for k = 1:wmsz         
        d_w = D_w(points(k, 1),points(k, 2));
        d = D(points(k, 1), points(k, 2));
        signal(k) = (d_w / d - 1) / 25;
    end

    % The hien am thanh duoc trich xuat
    subplot(2, 2, 3)
    plot(signal)
    xlabel('Time')
    ylabel('Audio Signal')
    title('Extracted Watermark Signal');
    fprintf('Ket thuc thi tach tin hieu tu watermarked\n');

    fprintf('Luu ke qua thuc thi\n');
    ghi_audio('Luu am thanh triet xuat', signal, Fs, 'BitsPerSample', 24);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
