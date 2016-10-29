function csvImport( handles )
%Add data from a csv file to the data pool
%   Detailed explanation goes here


global importDirectory;
    
    startDir = pwd;     % we need to temporarily change working dir

    if (~isempty(importDirectory))
        cd (importDirectory);
    end
    fileTypes = { '*.csv', 'Comma separated values file'; ...
        };
        
    [filename, pathname] = uigetfile(fileTypes, 'Choose a csv file');
    if ~(isequal(filename,0)|isequal(pathname,0))
        
        watchon;
        try
            [fileDir,name,ext] = fileparts(filename);
            cd (pathname);
            importDirectory=pathname;   % let them start here next time
            fileDir = pwd;
            cleaner = onCleanup(@() resetCD(startDir,fileDir));

            y = csvread(filename);
            dobj = DataObject;
            dobj.setChanName(name);
            dobj.setServer('localFile');
            dobj.setFs(2048);
            dobj.setId(-1);
            dobj.setStart(0);
            siz=size(y);
            l = siz(1);
            if (siz(2) > 1)
            end
            dobj.setStop(l);
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


