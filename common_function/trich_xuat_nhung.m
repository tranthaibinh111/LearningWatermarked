function signal = trich_xuat_nhung(origin_gray, watermarking, wmsz, points)
    %get DCT of the Asset
    D = dct2(origin_gray);
    %will contain watermark signal extracted from the image
    D_w = dct2(watermarking); 
    W = zeros(1, wmsz, 'double');
    for k = 1:wmsz
        % watermark extraction
        d_w = D_w(points(k, 1),points(k, 2));
        d = D(points(k, 1), points(k, 2));
        W(k) = (d_w / d - 1) *10;
    end
    
    signal = W;
end

