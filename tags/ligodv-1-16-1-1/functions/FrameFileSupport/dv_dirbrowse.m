function dv_dirbrowse(handles)

% DV_DIRBROWSE browse for a directory name and set this in the appropriate
% places.
% 
% set ff_dirpath
% 
% M Hewitson
% 
% $Id$
% 

% get the directory
directory_name = uigetdir('/data/scratch/rawframes/');

% set string in the ff_dirpath
dv_ff_setframedir(handles, directory_name)

% END