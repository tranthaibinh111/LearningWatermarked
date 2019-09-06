clc;
clear;

% thuc thi nhung voi cac du lieu cai dat
bsize = 8;
quant = bsize;
msize = 32;

try
    % Add path common function
    addpath('../common_function');
    % Cai dat mang figure
    f = figure('Name', 'Thuc hien nhung');
    
    [fOrigin, pthOrigin] = doc_hinh('Chon anh goc');
    if (isequal(fOrigin, 0) && ...
        isequal(fOrigin, 0))
        fprintf('Hinh nhu ban khong chon origin\n');
        return;
    end
    
    % get origin
    fprintf('Doc origin image\n');
    origin = imread([pthOrigin, fOrigin]);
    figure(f), subplot(2, 2, 1), imshow(origin), title('Origin');
    fprintf('Ket thuc doc origin image\n');
    
    % Chon anh nhung
    [fMessage, pthMessage] = doc_hinh('Chon anh nhung');
    if (isequal(fMessage,0) && ...
        isequal(fMessage, 0))
        fprintf('Hinh nhu ban khong chon message\n');
        return;
    end
    
    % Doc anh nhung
    fprintf('Doc message image\n');
    message = imread([pthMessage, fMessage]);
    figure(f), subplot(2, 2, 2), imshow(message), title('Message');
    fprintf('Ket thuc doc message image\n');

    % EmbedWatermark
    fprintf('Thuc thi EmbedWatermark %dx%d\n', bsize, bsize);

    w = bsize; h = bsize; %window size
    x = size(origin, 1) / w;
    y = size(origin, 2) / h; 
    m = w * ones(1, x);
    n = h * ones(1, y);
    c = mat2cell(origin, m, n);
    
    for i = 1:msize
        for j = 1:msize
            if isequal(message(i,j), 255)
                bitvalue = 0;
            else
                bitvalue = 1;
            end
            
            c{i,j} = EmbedWatermark(c{i,j}, bitvalue, quant);
        end
    end

    watermarking = cell2mat(c);
    header = sprintf('Watermarking block %dx%d\n', bsize, bsize);
    figure(f), subplot(2, 2, 3), imshow(watermarking), title(header);
    fprintf('Ket thuc thi EmbedWatermark %dx%d\n', bsize, bsize);

    fprintf('Luu ke qua thuc thi\n');
    header = sprintf('Luu anh Watermarking block %dx%d\n', bsize, bsize);
    viet_hinh(header, watermarking);
    fprintf('Ket thuc luu ke qua thuc thi\n');
catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
