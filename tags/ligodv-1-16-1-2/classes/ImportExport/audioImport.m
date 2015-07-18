function wavImport( handles )
%WAVIMPORT Select and import data from a .wav (sound) file into the data
%pool

global importDirectory;
    
    startDir = pwd;     % we need to temporarily change working dir

    if (~isempty(importDirectory))
        cd (importDirectory);
    end
    fileTypes = { '*.wav', 'Microsoft WAV file'; ...
        '*.mp3', 'MPEG part 3'; ...
        '*.mp4', 'MPEG-4'; ...
        '*.m4a', 'MPEG-4'; ...
        '*.ogg', 'OGG'; ...
        '*.flac', 'FLAC'; ...
        '*.*', 'All files'
        };
        
    [filename, pathname] = uigetfile(fileTypes, 'Choose a sound file');
    if ~(isequal(filename,0)|isequal(pathname,0))
        
        watchon;
        try
            [fileDir,name,ext] = fileparts(filename);
            cd (pathname);
            importDirectory=pathname;   % let them start here next time
            fileDir = pwd;
            cleaner = onCleanup(@() resetCD(startDir,fileDir));

            [y,fs] = audioread(filename);
            dobj = DataObject;
            dobj.setChanName(name);
            dobj.setServer('localFile');
            dobj.setFs(fs);
            dobj.setId(-1);
            dobj.setStart(0);
            siz=size(y);
            l = siz(1);
            if (siz(2) == 2)
                % turn stereo into mono
                y=y(:,1) + y(:,2);
            end
            l0=l/fs;
            l1 = ceil(l0);
            % make sure we have an integer number of seconds in data
            if (l1 > l0)
                e=l1*fs;
                y(e,1)=0;
            end
            dobj.setStop(l1);
            dobj.setX(y);
            
            add1toDataPool(handles, dobj.getDataPoolObj);
        catch ex
            fprintf('Error importing: %s\n',ex.message);
        end
        drawnow;
        watchoff;
    end
    importDirectory=pwd;
    
    cd(startDir);   % return us to original working dir
end

%on exit in case of an error.
function resetCD(returnDir,tempDir)
    if strcmp(tempDir,pwd)
       cd(returnDir);
    end
end

