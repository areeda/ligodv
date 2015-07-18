% LDVPARAMS Set parameters for ligoDV.
%
% J Smith and M Hewitson
%
% $Id$

%% General settings
% current version number used for update check NB: 1.13b1 < 1.13 (the
% released version).
global curVersion;
curVersion = '1.15b2';

% Where to report problems
global contact;
contact='ligodv@gravity.phys.uwm.edu';
% if we are a pre-release we always want to nag if an upgrade is available
Help.checkForUpdate(true);

% initialize things we want to remember
global chanSelectVals;  % keep the dialog settings from last time
chanSelectVals=struct;

global importDirectory; % where we're importing ldvw files from
importDirectory='';


% Debug level
ldv_settings.general.debugLevel       = 1;
% Path to the functions directory (should be updated for ligoDV root)
ldv_settings.general.functions_path   = './functions';
% Data retrieval mode options
ldv_settings.general.modes            = {'NDS2 Server','NDS Server'};

% Default colors for plot data lines                        
ldv_settings.general.colors  = {[0.2 0.2 0.8],... % dark blue
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
                          
% ldv_settings.general.markers = {                          

%% Settings for preprocessing panel

ldv_settings.units = {'Counts','Volts'};

ldv_settings.resample.factors = { '1/1', '1/2', '1/4', '1/8', '1/16', '1/32', '1/64',...
                              '1/128', '1/256', '1/512', '1/1024'};
ldv_settings.resample.L  = 24;


%% Settings for filtering and post-processing

ldv_settings.primelength = 3;


%% Settings for Analyses/plot panel
%
%

ldv_settings.analyses = { 'Time-series', 'Spectrum', 'Coherence',...
                      'TF/CPSD', 'Spectrogram', 'Cross-correlation',...
                      'Histogram','XY-scatter','Omega Scan'}; 

% settings.units    = {'V', '1'};

ldv_settings.windows  = {'Kaiser', 'Hanning', 'Bartlett', 'Blackmanharris', 'Flattop', 'none'};

ldv_settings.colormaps = {'jet', 'hsv', 'bone', 'hot', 'gray'};

%% Settings for time panel
%
%

ldv_settings.time.modes   = {'UTC', 'GPS'};


%% Settings for LIGO NDS mode
%
%

% Data types
ldv_settings.gd.data_types = { 'raw data',...
                           'second trends',...
                           'minute trends',...
                           'reduced data',...
                          };

% Possible default servers
ldv_settings.gd.servers = {'nds.ligo.caltech.edu:31200',...
                       'nds.ligo-la.caltech.edu:31200'...
                       'nds.ligo-wa.caltech.edu:31200'...
                      };

% Trend file statistic types
ldv_settings.gd.stats = {'max','min','mean','rms','n','max,min','max,mean,min'};
                    

%% Settings for Frame File mode
% 
% 
username = char(java.lang.System.getProperties.getProperty('user.name')); 
ldv_settings.ff.dir_structs   = {'flat', 'GEO'};
ldv_settings.ff.path          = '/tmp';
ldv_settings.ff.defaultCache  = ['/home/' username 'dv6cache.mat'];
ldv_settings.ff.fcache.nfiles = 0;
ldv_settings.ff.fcache.files  = [];

% A file has:
% .path
% .gpstime
% .length



%% Settings for filter dialog box

ldv_settings.fdlg.inputmodes = {'standard types', 'pole/zero edit'};

ldv_settings.fdlg.viewfs = {'16384', '8192', '4096', '2048', '1024',...
                        '512', '256', '128', '64', '32', '16',...
                        '8', '4', '2', '1'};

 


