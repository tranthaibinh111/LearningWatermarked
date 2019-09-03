function [fname, pthname, flindex] = viet_excel(title, toBeSaved)
    [fname, pthname, flindex] = uiputfile( ...
        { ...
            '*.csv'; ...
            '*.xls'; ...
            '*.xlsx'; ...
            '*.xlsb'; ...
            '*.xlsm'; ...
        }, ...
        title, ...
        '*.xlsx');
    
    if (~isequal(fname,0) && ...
        ~isequal(pthname, 0))
        file = fullfile(pthname, fname);
        xlswrite(file, toBeSaved);
    end
end