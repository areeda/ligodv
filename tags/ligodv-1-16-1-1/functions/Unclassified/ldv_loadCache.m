function ldv_loadCache(varargin)

% LDV_LOADCACHE loads a file cache from a .mat file and sets is as current.
% 
% ldv_loadCache(handles)
% ldv_loadCache(handles, filename)
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

handles = varargin{1};
if nargin > 1
  [pathname,filename,ext,vers] = fileparts(varargin{2});
  % build file name
  infilename = [pathname '/' filename ext];
else
  % get filename
  [filename, pathname] = uigetfile({'*.mat', 'MAT-file input'; '*.ffl', 'VIRGO ffl file'});
  % build file name
  infilename = [pathname '/' filename];
end

% if isequal(filename,0)|isequal(pathname,0)
%   error('### File not found');
% else
  
  if filename ~= 0
    % get file extension
    [pathstr,name,ext,vers] = fileparts(infilename);

    switch lower(ext)
      case '.mat'
        in = load(infilename);
        dv_setFileCache(handles, in.fcache);
        dv_ff_setframedir(handles, in.fcache.rootdir);
        dv_ffSetNfiles(handles);
      case '.ffl'
        lastLinesStr = get(handles.ff_lastLines, 'String');
        if isempty(lastLinesStr)
          lastLines = -1;
        else
          lastLines = str2num(lastLinesStr);
        end
        fcache = dv_ffl2fcache(infilename, lastLines);
        dv_setFileCache(handles, fcache);
        dv_ffSetNfiles(handles);

      otherwise
        error('### unknown file type');
    end

  end  
end




% END