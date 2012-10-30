function handlesout = ldv_init(handles)

% DV_INIT Setup of various things at startup.
% 
% M Hewitson 26-07-06
% 
% $Id$


settings = getappdata(handles.main, 'settings');
setappdata(handles.main, 'FullChannelList', []);

%% Set dv mode
set(handles.dvmode, 'String', settings.general.modes);
set(handles.dvmode, 'Value', 1);
ldv_setdvmode(handles);

%% Default settings for Frame File mode
set(handles.ff_dirstruct, 'String', settings.ff.dir_structs);
set(handles.ff_dirstruct, 'Value', 2);


%% Default settings for Ligo NDS Server Mode
set(handles.gd_dataTypeSelect, 'String', settings.gd.data_types);
set(handles.gd_dataTypeSelect, 'Value', 1);
ldv_setdatatype(handles);
set(handles.gd_serverSelect, 'String', settings.gd.servers);
set(handles.gd_serverSelect, 'Value', 1);
ldv_setserverdetails(handles);
set(handles.gd_stat, 'String', settings.gd.stats);
set(handles.gd_stat, 'Value', 3);

%% Default settings for time panel
set(handles.timeInputMode, 'String', settings.time.modes);
set(handles.timeInputMode, 'Value', 1);
ldv_settimepanel(handles);

%% Set N times structure
times.t = [];
times.ntimes = 0;
setappdata(handles.main, 'times', times);

%% Setup the data objects structure

dobjs.objs    = [];
dobjs.nobjs   = 0;
dobjs.counter = 0;
setappdata(handles.main, 'dobjs', dobjs);
ldv_setnobjsdisplay(handles, dobjs);

%% Setup preprocessing panel

% set units
set(handles.preprocUnits, 'String', settings.units);
set(handles.preprocUnits, 'Value', 1);
tempunit = ldv_setunit(handles);

% set resample rate
set(handles.preprocResampleR, 'String', settings.resample.factors);
set(handles.preprocResampleR, 'Value', 1);



%% Setup analysis panel

set(handles.plotType, 'String', settings.analyses);
set(handles.plotType, 'Value', 1);
ldv_setplottype(handles);



% set frequencies structure
freqs.nfreqs = 0;
freqs.f      = [];
setappdata(handles.main, 'freqs', freqs);
set(handles.plotSpectrumNfreqs, 'String', ['#freqs=',num2str(freqs.nfreqs)]);

%% Set tooltips

ldv_settooltips(handles);

% get and set latest time from system Unix clock 
latest = ldv_getlatest(handles);
ldv_setlatest(handles, latest);
ldv_setstartlatest(handles);
ldv_setstoplatest(handles);

%% global objects, we want convenient calls from all functions & methods


% Factory default configuration is what we just did
% all other configurations are used inside the Preferences class but this
% one is special in that we want to capture a 'clean' untouched version.

global factDefConfig;
    factDefConfig = Configuration('Factory Default','As programmed in ldv_init.m');
    factDefConfig.getCurrent(handles);
    
    p = Preferences.instance();
    p.setHandles(handles);
    p.setDefault();     % if we have defaults defined set them now

%% Return a new handles structure with all the additions.
handlesout = handles;

% END
