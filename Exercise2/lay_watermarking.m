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
    f = figure('Name', 'Thuc hien trich xuat');
    
    [fWM, pthWM] = doc_hinh('Chon anh Watermarked');
    if (isequal(fWM, 0) && ...
        isequal(pthWM, 0))
        fprintf('Hinh nhu ban khong chon watermarked\n');
        return;
    end
    
    % get origin
    fprintf('Doc watermarking image\n');
    wm = imread([pthWM, fWM]);
    figure(f), subplot(1, 2, 1), imshow(wm), title('Watermarking');
    fprintf('Ket thuc doc watermarking image\n');

    % ExtractWatermark
    fprintf('Thuc thi ExtractWatermark %dx%d\n', bsize, bsize);
    w = bsize; h = bsize; %window size
    x = size(wm, 1) / w;
    y = size(wm, 2) / h; 
    m = w * ones(1, x);
    n = h * ones(1, y);
    c = mat2cell(wm, m, n);

    extract = zeros(msize, msize, 'uint8');
    for i = 1:msize
        for j = 1:msize
            [bitvalue, ~] = ExtractWatermark(c{i,j}, quant);
            if isequal(bitvalue, 0)
                extract(i,j) = 255;
            else
                extract(i,j) = 0;
            end
        end
    end
    
    figure(f), subplot(1, 2, 2), imshow(extract), title('Message trich xuat');
    
    fprintf('Extract Watermarking block %dx%d\n', bsize, bsize);
    viet_hinh('Luu Message trich xuat', extract);
    fprintf('Ket thuc thi ExtractWatermark %dx%d\n', bsize, bsize);

catch ME
    fprintf("Error trong qua trinh nhung du lieu\n");
    rethrow(ME);
end
