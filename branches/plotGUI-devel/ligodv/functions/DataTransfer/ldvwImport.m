function ldvwImport( handles )
%LDVWIMPORT Select and run and ldvwExport file, adding the new objects to
%the data pool

%   ldvw produces an m file which creates a data object structure which we
%   add to the data pool.

    global importDirectory;
    
    startDir = pwd;     % we need to temporarily change working dir

    if (~isempty(importDirectory))
        cd (importDirectory);
    end
    
    [filename, pathname] = uigetfile('ldvw_export*.m', 'LDVW export file');
    if ~(isequal(filename,0)|isequal(pathname,0))
        
        set(gcf,'Pointer','watch');
        try
            [fileDir,script,ext] = fileparts(filename);
            cd (pathname);
            fileDir = pwd;
            cleaner = onCleanup(@() resetCD(startDir,fileDir));

            newObjs = eval(script);
            % unset ids
            for j=1:newObjs.nobjs
                newObjs.objs(j).id = -j;
            end
            addToDataPool(handles, newObjs);
        catch ex
            sprintf("Error importing: %s\n",ex.message);
        end
        drawnow;
        set(gcf,'Pointer','arrow');
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
