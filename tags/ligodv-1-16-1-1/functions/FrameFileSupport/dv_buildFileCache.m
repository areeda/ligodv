function dv_buildFileCache(handles)

% DV_BUILDFILECACHE builds a cache of all files stored in the specfied
% directory. For each file we keep the filepath, the start time, and the
% duration. This information is held in the array of structures
% settings.ff.file() where each file(i) has fields:
% 
%   file.path
%   file.startgps
%   file.duration
% 

  ldv_settings = getappdata(handles.main, 'ldv_settings');
  fcache   = ldv_settings.ff.fcache

  % get the root dir
  root_dir = dv_ff_getframedir(handles);
  fcache.rootdir = root_dir;
  
  if strcmp(root_dir, fcache.rootdir)==0
    fcache.rootdir = root_dir;
    fcache.files   = [];
    fcache.nfiles  = 0;
  end

  gwf_files = [];
  gwf_files = filescan(root_dir, '.gwf');
  
  nfiles = length(gwf_files);
  dv_disp('* found %d files', nfiles);
 
  % now build file structure array
  fcache.files   = buildFileStruct(handles, gwf_files, fcache.files);
  fcache.rootdir = root_dir;
  fcache.nfiles  = nfiles;
  
  fcache.files.path
  % set cache
  dv_setFileCache(handles, fcache);
  dv_ffSetNfiles(handles);
end

%--------------------------------------------------------------------------
function ffiles = buildFileStruct(handles, gwf_files, ffiles)
% Build array of file structures from frame file list
% 

%   ffiles = files;
  Nf = length(ffiles);
  nfiles = length(gwf_files);
  h = waitbar(0, 'Scanning frame files...');
  for j=1:nfiles
    
    cfile = char(gwf_files(j,:));
    % check if we have this file already
    filefound = 0;
    for k=1:Nf
      if strcmp(ffiles(k).path, cfile)
        filefound = 1;
        %dv_disp('    - %s already cached', cfile);
      end      
    end
    
    if ~filefound
      Nf = Nf + 1;
      % add file path
      ffiles(Nf).path = cfile;

      [start, dur, nframes] = scanFile(cfile);

      % add start time
      ffiles(Nf).start = start;

      % add duration
      ffiles(Nf).duration = dur;

      % add num frames
      ffiles(Nf).nframes = nframes;

      % compute frame length
      ffiles(Nf).frlen = dur/nframes;
    end
    waitbar(j/nfiles, h);
  end

  close(h);
  
end


%--------------------------------------------------------------------------
function [start, dur, nframes] = scanFile(filename)
% Get some details from the frame file 
% 

info    = mFrInfo(filename, 'INFO');
start   = info.gpsstart;
dur     = info.duration;
nframes = info.nframes;


end

% END