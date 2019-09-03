function [fname, pthname, flindex] = ghi_audio(title, signal, Fs, Name, Value)  
    % Cai dat gia tri default
    switch nargin
      case 3
        Name = 'BitsPerSample';
        Value = 16;
      case 5
      otherwise
        error('3 inputs are accepted.')
    end
    
    [fname, pthname, flindex] = uiputfile( ...
        { ...
            '*.mp3'; ...
            '*.mp4'; ...
            '*.wav'; ...
            '*.flac'; ...
        }, ...
        title, ...
        '*.flac');
    
    if (~isequal(fname,0) && ...
        ~isequal(pthname, 0))
        filename = fullfile(pthname, fname);
        audiowrite(filename, signal, Fs, Name, Value);
        
        clear signal Fs
    end
end

