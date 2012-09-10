% LDVPARAMS Set parameters for ligoDV.
%
% J Smith and M Hewitson
%
% $Id$

%% General settings
% 
% 


% add paths to all our subdirectories
myFilename = mfilename('fullpath'); % full path to this m-file which must be
                                    % in ligodv root for this to work
[ligodvRootPath] = fileparts(myFilename);   %path to directory with this file

addpath(genpath(ligodvRootPath));   % genpath finds all subdirectories

% add paths to NDS2 mex files
matlabRel=version('-release');
nds2Path = getenv('NDS2_LOCATION');
comp = computer;        % some paths vary depending on OS

ndsErr=0;
ermsg = '';

% do some validation of paths.  This code should be good enough to
% determine if the paths have been set correctly but is not complete enough
% to validate the whole NDS/NDS2 installation
if (isempty(nds2Path))
    ermsg=sprintf('\nNDS2 libraries were not found.\n\n%s\n%s\n', ...
        'The easiest way to fix this is to set the environment variable "NDS2_LOCATION"\n',...
        'If you continue you will not have access to remote data');
    ndsErr = 1;
elseif regexpi(comp,'pcwin')
    mexPath = strcat(nds2Path,'/lib/matlab/',matlabRel);
    addpath(mexPath);
else
    mexPath = strcat(nds2Path,'/lib/matlab',matlabRel);
    addpath(mexPath);
    jarPath = strcat(nds2Path,'/share/java/nds.jar');
    if (exist(jarPath) == 2)
        javaaddpath(jarPath);
    else
        ermsg('\nSWIG-Java bindings not found\n');
        ndsErr=1;
    end
end
n2gd = exist('NDS2_GetData');
n2cl = exist('NDS2_GetChannels');
ngd = exist('NDS_GetData');
ncl = exist('NDS_GetChannels');
if (n2gd ~= 3 || n2cl~=3 || ngd ~= 3 || ncl ~=3)
    ermsg = sprintf('%s\n%s\n\n%s\n\n%s',...
        'The NDS2_LOCATION environment variable is set incorrectly.',...
        'Or the NDS2 client "mex" files are not installed properly.',...
        'You may not be able to transfer data from ligo servers',...
        'Do you want to run ligoDV anyway?');
    ndsErr = 1;
end

if (ndsErr == 1)
    answer = questdlg(ermsg,'NDS2 Not Found','Continue','Exit','Help','Exit');
    if (strcmp(answer,'Exit'))
        error(ermsg);
    elseif (strcmp(answer,'Help'))
        Help.show2('NDS2_Install#Troubleshooting');
        error(ermsg);
    else
        warning(ermsg);
    end
end
%% note the javaaddpath above will clear the global variables
% current version number used for update check NB: 1.13b1 < 1.13 (the
% released versuib).
global curVersion;
curVersion = '1.14a2';

% Where to report problems
global contact;
contact='ligodv@gravity.phys.uwm.edu';
% if we are a pre-release we always want to nag if an upgrade is available
Help.checkForUpdate(true);


% Debug level
settings.general.debugLevel       = 1;
% Path to the functions directory (should be updated for ligoDV root)
settings.general.functions_path   = './functions';
% Data retrieval mode options
settings.general.modes            = {'NDS2 Server','NDS Server'};

% Default colors for plot data lines                        
settings.general.colors  = {[0.2 0.2 0.8],... % dark blue
                            [0.8 0.2 0.2],... % dark red
                            [0.2 0.9 0.2],... % light green
                            [0.517, 0, 0.8]... % dark purple
                            [255 128 0]/255,...  % orange
                            [0 207 255]/255,... % cyan
                            [0.102 0.456 0.102],... % dark green
                            [0 0 0],... % black
                            [0.888 0.163 0.9],... % magenta
                            [143 0 0]/255,... % brown
                            [255 207 0]/255,... % gold
                            [0.9 0.266 0.593],...  % pink
                            [0.555, 0.549, 0.561],... % gray
                            [0.676,0.8,0],... % lime green
                            [0.9 0.685 0.685],... % salmon
                            [1 0 0],... % bright red
                            [0 0.443 0.8],... % bright blue
                            };                        
                          
% settings.general.markers = {                          

%% Settings for preprocessing panel

settings.units = {'Counts','Volts'};

settings.resample.factors = { '1/1', '1/2', '1/4', '1/8', '1/16', '1/32', '1/64',...
                              '1/128', '1/256', '1/512', '1/1024'};
settings.resample.L  = 24;


%% Settings for filtering and post-processing

settings.primelength = 3;


%% Settings for Analyses/plot panel
%
%

settings.analyses = { 'Time-series', 'Spectrum', 'Coherence',...
                      'TF/CPSD', 'Spectrogram', 'Cross-correlation',...
                      'Histogram','XY-scatter','Omega Scan'}; 

% settings.units    = {'V', '1'};

settings.windows  = {'Kaiser', 'Hanning', 'Bartlett', 'Blackmanharris', 'Flattop', 'none'};

settings.colormaps = {'jet', 'hsv', 'bone', 'hot', 'gray'};

%% Settings for time panel
%
%

settings.time.modes   = {'UTC', 'GPS'};


%% Settings for LIGO NDS mode
%
%

% Data types
settings.gd.data_types = { 'raw data',...
                           'second trends',...
                           'minute trends',...
                          };

% Possible default servers
settings.gd.servers = {'nds.ligo.caltech.edu:31200',...
                       'nds.ligo-la.caltech.edu:31200'...
                       'nds.ligo-wa.caltech.edu:31200'...
                      };

% Trend file statistic types
settings.gd.stats = {'max','min','mean','rms','n','max,min','max,mean,min'};
                    

%% Settings for Frame File mode
% 
% 
username = char(java.lang.System.getProperties.getProperty('user.name')); 
settings.ff.dir_structs   = {'flat', 'GEO'};
settings.ff.path          = '/tmp';
settings.ff.defaultCache  = ['/home/' username 'dv6cache.mat'];
settings.ff.fcache.nfiles = 0;
settings.ff.fcache.files  = [];

% A file has:
% .path
% .gpstime
% .length



%% Settings for filter dialog box

settings.fdlg.inputmodes = {'standard types', 'pole/zero edit'};

settings.fdlg.viewfs = {'16384', '8192', '4096', '2048', '1024',...
                        '512', '256', '128', '64', '32', '16',...
                        '8', '4', '2', '1'};

 


