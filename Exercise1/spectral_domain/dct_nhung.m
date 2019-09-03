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
    
    % Chon audio message
    [fAudio, pthAudio] = doc_audio('Chon audio nhung');    
    if (isequal(fAudio,0) && ...
        isequal(pthAudio,0))
        fprintf('Hinh nhu ban khong chon message\n');
        return;
    end

    % Cai dat mang figure
    f = figure('Name', 'Thuc hien nhung DCT');

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
    figure(f), subplot(2, 2, 1), imshow(I), title('Origin Gray');
    fprintf('Ket thuc chuyen anh mau thanh anh xam\n');

    % Doc audio message
    fprintf('Doc audio messge\n');
    [signal, Fs] = audioread([pthAudio, fAudio]);
    [m, n] = size(signal);
    wmsz = m * n;
    % hien bieu do am thanh
    figure(f)
    subplot(2, 2, 2)
    plot(signal)
    xlabel('Time')
    ylabel('Audio Signal')
    title('Watermarking Signal');
    fprintf('Ket thuc doc audio message\n');

    % Thuc thi dct nhung message vao origin
    fprintf('Thuc thi nhung tin hieu vao image\n');
    [r, c] = size(I);
    % Lay DCT cua origin
    D = dct2(I);
    % Chuyen thanh matrix hinh anh thanh mang 1 chieu
    D_vec = reshape(D, 1, r*c);
    % Sap xep lai theo thu tu giam dan
    [~, Idx] = sort(abs(D_vec), 'descend');
    % Chuyen matrix am thanh thanh mang 1 chieu
    W = reshape(signal, 1, wmsz);
    % Lay cac cac diem lon 
    Idx2 = Idx(2:wmsz+1);
    % tim vi tri trong matrix image de nhung
    IND = zeros(wmsz,2);
    for k = 1:wmsz
        % Cot trong hinh anh
        x = floor(Idx2(k) / r) + 1;
        if (x > r)
            x = r;
        end

        % Dong trong hinh anh
        y = mod(Idx2(k), r);
        if (y == 0)
            y = r;
        end

        IND(k, 1) = y;
        IND(k, 2) = x;
    end

    D_w = D;
    for k = 1:wmsz
        try
            % Chen am thanh vao DCT voi ti le ne trong so = 1/10 hoac 1/50
            D_w(IND(k,1), IND(k,2)) =  ...
                D_w(IND(k,1), IND(k,2)) + ...
                25.0 * D_w(IND(k,1),IND(k,2)) .* W(k);
        catch ME
            fprintf('Loi khi thuc thi nhung tai (%d,%d)', IND(k,1), IND(k,2));
            disp(ME);
        end
    end

    points = IND;
    dct_w = D_w;
    % DCT nghich dao de lay watermarked
    watermarked = uint8(idct2(dct_w));
    figure(f), subplot(2, 2, 3), imshow(watermarked), title('Watermarked');
    fprintf('ket thuc thi nhung tin hieu vao image\n');

    % Luu lai ket qua thuc thi nhung
    fprintf('Luu ke qua thuc thi\n');
    viet_hinh('Luu anh Watermarked', watermarked);
    viet_excel('Luu lai cai diem nhung', points);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
