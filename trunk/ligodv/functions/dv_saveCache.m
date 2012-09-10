function dv_saveCache(handles)

% DV_SAVECACHE save a file cache to disk.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

% get file cache
fcache = dv_getFileCache(handles);

% save objects
if fcache.nfiles > 0
  
  %% Get filename
  defaultFile = '/home/hewitson/.dv6cache.mat';
  [filename, pathname] = uiputfile({'*.mat', 'MAT-file input'; '*.ffl', 'VIRGO ffl file'}, defaultFile);
  outfilename = [pathname filename];
  if filename ~= 0
    
    % check file extension
    [pathstr,name,ext,vers] = fileparts(outfilename);

    switch lower(ext)
      case '.mat'
        save(outfilename, 'fcache');
      case '.ffl'
        
        dv_fcache2ffl(outfilename, fcache);
        
      otherwise
        error('### unknown file type');
    end
    
    
  end
else
  error('### Build file cache first.');  
end


% END