function [dct_w, points] = thuc_hien_nhung(origin_gray, signal)
    if (wmsz > 0)
        [r, c] = size(I);
        % get DCT of the Asset
        D = dct2(I);
        % putting all DCT values in a vector
        D_vec = reshape(D, 1, r*c);
        % re-ordering all the absolute values
        [~, Idx] = sort(abs(D_vec), 'descend');
        % watermark signal
        W = reshape(signal, 1, wmsz);
        % choosing biggest values other than the DC value
        Idx2 = Idx(2:wmsz+1);
        % finding associated row-column order for vector values
        IND = zeros(wmsz,2);
        for k = 1:wmsz
            % associated column in the image
            x = floor(Idx2(k) / r) + 1;
            if (x > r)
                x = r;
            end
            
            % associated row in the image
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
            % insert the WM signal into the DCT values (? = 0.1)
            D_w(IND(k,1), IND(k,2)) =  ...
                D_w(IND(k,1), IND(k,2)) + ...
                .1 * D_w(IND(k,1),IND(k,2)) .* W(k);
            catch ME
                fprintf('Loi khi thuc thi nhung tai (%d,%d)', IND(k,1), IND(k,2));
                disp(ME);
            end
        end
        
        points = IND;
        dct_w = D_w;
    else
        fprintf('Loi khi thuc thi nhung do signal %dx%d', x, y);
    end
end

