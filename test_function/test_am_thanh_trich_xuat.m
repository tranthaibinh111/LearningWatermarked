clc;
clear;

try
    % Add path common function
    addpath('../common_function');   
    
    % Chon audio goc
    [fAudio, pthAudio] = doc_audio('Chon audio nhung');
    if (isequal(fAudio, 0) && ...
        isequal(pthAudio, 0))
        fprintf('Hinh nhu ban khong chon am thanh goc\n');
        return;
    end
    
    % Chon audio trich xuat tu watermarked
    [fExtractAudio, pthExtractAudio] = doc_audio('Chon audio trich xuat');
    if (isequal(fAudio, 0) && ...
        isequal(pthAudio, 0))
        fprintf('Hinh nhu ban khong chon am thanh trich xuat goc\n');
        return;
    end

    % Cai dat mang figure
    f = figure('Name', 'Thuc hien so sanh am thanh goc va am thanh trich xuat');

    % Doc audio goc
    fprintf('Doc audio goc\n');
    [signal, ~] = audioread([pthAudio, fAudio]);
    [m, n] = size(signal);
    wmsz = m * n;
    % hien bieu do am thanh
    figure(f)
    subplot(2, 2, 1)
    plot(signal)
    xlabel('Time')
    ylabel('Audio Signal')
    title('Origin Signal');
    fprintf('Ket thuc doc audio goc\n');

    % Doc audio trich xuat
    fprintf('Doc audio trich xuat\n');
    [extractSignal, ~] = audioread([pthExtractAudio, fExtractAudio]);
    % hien bieu do am thanh
    figure(f)
    subplot(2, 2, 2)
    plot(extractSignal)
    xlabel('Time')
    ylabel('Audio Signal')
    title('Extract Signal');
    fprintf('Ket thuc doc audio trich xuat\n');

    % Doc audio trich xuat
    fprintf('Thuc thi so sanh\n');
    % Chuyen mxn -> 1xn
    asset = reshape(signal, 1, wmsz);
    extract = reshape(extractSignal, 1, wmsz);

    store = zeros(1, wmsz, 'double');
    for k = 1:wmsz
        if (isequal(extract(k), 0))
            store(k) = 0;
        else
            store(k) = extract(k).*asset(k) / sqrt(extract(k).*extract(k));
        end
    end

    % Hien thi bieu do so sanh
    figure(f)
    subplot(2, 2, 3)
    plot(1:k, store)
    ylabel('Watermark detector response')
    xlabel('Sample Audio');
    fprintf('Ket thuc so sanh\n');
catch ME
    fprintf("Error trong qua trinh phan tich do trung khop giua am thanh goc va am thanh trich xuat\n");
    rethrow(ME);
end
