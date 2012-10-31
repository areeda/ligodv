
%% LIGODV M-file for ligoDV.fig - the main GUI interface for the Data Viewer
%      LIGODV, by itself, creates a new LIGODV or raises the existing
%      singleton*.
%
%      H = LIGODV returns the handle to a new LIGODV or the handle to
%      the existing singleton*.
%
%      LIGODV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIGODV.M with the given input arguments.
%
%      LIGODV('Property','Value',...) creates a new LIGODV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ligoDV_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ligoDV_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ligoDV

% Last Modified by GUIDE v2.5 27-Oct-2012 08:05:26

%%
function varargout = ligoDV(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ligoDV_OpeningFcn, ...
                   'gui_OutputFcn',  @ligoDV_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ligoDV is made visible.
function ligoDV_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ligoDV (see VARARGIN)

% Choose default command line output for ligoDV
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ligoDV wait for user response (see UIRESUME)
% uiwait(handles.main);


%-------------------------------------------------------------------------
% Some setup 
%-------------------------------------------------------------------------

% load settings file - this gets the 'settings' structure.
ldvparams;

% create log file
ldv_logfile;

% make settings structure
setappdata(handles.main, 'settings', settings);

% now we have the functions path the rest can go in init()
handles = ldv_init(handles);

%set the version string see ldvparams.m
global curVersion;
vstr = sprintf('ligoDV Release %s',curVersion);
set (handles.versionTxt,'String',vstr);

global contact;
vstr = sprintf('Contact: %s',contact);
set (handles.contactInfo,'String',vstr);


% Create a timer object to run our clock
global ligoDVFigHandles;
ligoDVFigHandles=handles;

updtCurTime();
global clockTimer;
clockTimer=timer('Name','clockTimer', ...
    'BusyMode', 'drop', 'Period',1,'StartDelay',3, 'ExecutionMode', 'fixedRate');
clockTimer.TimerFcn = @updtCurTime;
start(clockTimer);



% --- Outputs from this function are returned to the command line.
function varargout = ligoDV_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function gd_serverInputTxt_Callback(hObject, eventdata, handles)
% hObject    handle to gd_serverInputTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gd_serverInputTxt as text
%        str2double(get(hObject,'String')) returns contents of gd_serverInputTxt as a double


% --- Executes during object creation, after setting all properties.
function gd_serverInputTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_serverInputTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gd_serverSelect.
function gd_serverSelect_Callback(hObject, eventdata, handles)
% hObject    handle to gd_serverSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns gd_serverSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gd_serverSelect

ldv_setserverdetails(handles);



% --- Executes during object creation, after setting all properties.
function gd_serverSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_serverSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gd_dataTypeSelect.
function gd_dataTypeSelect_Callback(hObject, eventdata, handles)
% hObject    handle to gd_dataTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns gd_dataTypeSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gd_dataTypeSelect

ldv_setdatatype(handles)

% --- Executes during object creation, after setting all properties.
function gd_dataTypeSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_dataTypeSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dvmode.
function dvmode_Callback(hObject, eventdata, handles)
% hObject    handle to dvmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dvmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dvmode

ldv_setdvmode(handles);



% --- Executes during object creation, after setting all properties.
function dvmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dvmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function gd_portInputTxt_Callback(hObject, eventdata, handles)
% hObject    handle to gd_portInputTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gd_portInputTxt as text
%        str2double(get(hObject,'String')) returns contents of gd_portInputTxt as a double


% --- Executes during object creation, after setting all properties.
function gd_portInputTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_portInputTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function utcStartInput_Callback(hObject, eventdata, handles)
% hObject    handle to utcStartInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of utcStartInput as text
%        str2double(get(hObject,'String')) returns contents of utcStartInput as a double

ldv_utcstart(handles);
ldv_setdurationdisp(handles);

% --- Executes during object creation, after setting all properties.
function utcStartInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to utcStartInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gpsStartInput_Callback(hObject, eventdata, handles)
% hObject    handle to gpsStartInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gpsStartInput as text
%        str2double(get(hObject,'String')) returns contents of gpsStartInput as a double
ldv_gpsstart(handles);
ldv_setdurationdisp(handles);

% --- Executes during object creation, after setting all properties.
function gpsStartInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpsStartInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function utcStopInput_Callback(hObject, eventdata, handles)
% hObject    handle to utcStopInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of utcStopInput as text
%        str2double(get(hObject,'String')) returns contents of utcStopInput as a double
ldv_utcstop(handles);
ldv_setdurationdisp(handles);

% --- Executes during object creation, after setting all properties.
function utcStopInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to utcStopInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gpsStopInput_Callback(hObject, eventdata, handles)
% hObject    handle to gpsStopInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gpsStopInput as text
%        str2double(get(hObject,'String')) returns contents of gpsStopInput as a double
ldv_gpsstop(handles);
ldv_setdurationdisp(handles);

% --- Executes during object creation, after setting all properties.
function gpsStopInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpsStopInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in getLatestBtn.
function getLatestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to getLatestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

latest = ldv_getlatest(handles);
ldv_setlatest(handles, latest);

% --- Executes on selection change in timeInputMode.
function timeInputMode_Callback(hObject, eventdata, handles)
% hObject    handle to timeInputMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns timeInputMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeInputMode

ldv_settimepanel(handles);


% --- Executes during object creation, after setting all properties.
function timeInputMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeInputMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startSetLatestBtn.
function startSetLatestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to startSetLatestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_setstartlatest(handles);

% --- Executes on button press in stopSetLatestBtn.
function stopSetLatestBtn_Callback(hObject, eventdata, handles)
% hObject    handle to stopSetLatestBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ldv_setstoplatest(handles);


% --- Executes on button press in editTimesBtn.
function editTimesBtn_Callback(hObject, eventdata, handles)
% hObject    handle to editTimesBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


pos_size = get(handles.main,'Position');
dlg_pos = [pos_size(1)+pos_size(3)/5 pos_size(2)+pos_size(4)/5];
try 
  times = ldv_timesDLG(dlg_pos, getappdata(handles.main, 'times'));
  set(handles.ntimes_display, 'String', num2str(times.ntimes));
  setappdata(handles.main, 'times', times);
end




function commentInput_Callback(hObject, eventdata, handles)
% hObject    handle to commentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of commentInput as text
%        str2double(get(hObject,'String')) returns contents of commentInput as a double


% --- Executes during object creation, after setting all properties.
function commentInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to commentInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipanel18_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'Tag')   % Get Tag of selected object
    case 'singleTimeRB'
        % Code for when radiobutton1 is selected goes here.
    case 'timeListRB'
        % Code for when radiobutton2 is selected goes here.
    % Continue with more cases as necessary.
end


% --- Executes on selection change in channelList.
function channelList_Callback(hObject, eventdata, handles)
% hObject    handle to channelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns channelList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelList
ldv_listselectedchannels(handles);
% ldv_getChannelInfo(handles); % this used to make tooltip for a given channel - not needed since adding fs to chan list

% --- Executes during object creation, after setting all properties.
function channelList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getChannelListBtn.
function getChannelListBtn_Callback(hObject, eventdata, handles)
% hObject    handle to getChannelListBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_getChannelList(handles);


function channelSearchTxt_Callback(hObject, eventdata, handles)
% hObject    handle to channelSearchTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelSearchTxt as text
%        str2double(get(hObject,'String')) returns contents of channelSearchTxt as a double

ldv_searchchannels(handles);



% --- Executes during object creation, after setting all properties.
function channelSearchTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelSearchTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in includeControlChansChk.
function includeControlChansChk_Callback(hObject, eventdata, handles)
% hObject    handle to includeControlChansChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of includeControlChansChk



function gd_rdslevel_Callback(hObject, eventdata, handles)
% hObject    handle to gd_rdslevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gd_rdslevel as text
%        str2double(get(hObject,'String')) returns contents of gd_rdslevel as a double


% --- Executes during object creation, after setting all properties.
function gd_rdslevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_rdslevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gd_calversion_Callback(hObject, eventdata, handles)
% hObject    handle to gd_calversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gd_calversion as text
%        str2double(get(hObject,'String')) returns contents of gd_calversion as a double


% --- Executes during object creation, after setting all properties.
function gd_calversion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_calversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dataObjects.
function dataObjects_Callback(hObject, eventdata, handles)
% hObject    handle to dataObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns dataObjects contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dataObjects

% set info panel
ldv_setdobjinfo(handles);

% set combine objects math string
ldv_setcombinemath(handles)

% fill coherence primary channel list
ldv_fillCoherencePrimary(handles);

% fill TF primary channel list
ldv_fillTFPrimary(handles);

% fill XCorr primary channel list
ldv_fillXCorrPrimary(handles);

% fill XYscatter primary channel list
ldv_fillXYscatterPrimary(handles);

% fill Omegagram whitening channel list
ldv_fillPrimary(handles, handles.plotOmegagramWhitenChan);


% --- Executes during object creation, after setting all properties.
function dataObjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getDataBtn.
function getDataBtn_Callback(hObject, eventdata, handles)
% hObject    handle to getDataBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_getdataobject(handles);


% --- Executes on button press in deleteSelectedDobjsBtn.
function deleteSelectedDobjsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSelectedDobjsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_dobjsdeleteselected(handles);

% --- Executes on button press in clearAllDobjsBtn.
function clearAllDobjsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearAllDobjsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_dobjsclear(handles);


% --- Executes on button press in gd_queryServerBtn.
function gd_queryServerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to gd_queryServerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ldv_queryserver(handles);


% --- Executes on button press in dobjInfoEditFiltersBtn.
function dobjInfoEditFiltersBtn_Callback(hObject, eventdata, handles)
% hObject    handle to dobjInfoEditFiltersBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filters = ldv_editDOBJfilters(handles);

if filters.nfilts > 0
  % clear the old filter objects from this data object and
  % then add the new filters
  
  % delete old
  ldv_clearFilters(handles);
  
  % add new
  ldv_setFilters(handles, filters);
end

% --- Executes on button press in dobjsSetFiltersBtn.
function dobjsSetFiltersBtn_Callback(hObject, eventdata, handles)
% hObject    handle to dobjsSetFiltersBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos_size = get(handles.main,'Position');
dlg_pos = [pos_size(1)+pos_size(3)/5 pos_size(2)+pos_size(4)/5];
filters.nfilts = 0;
filters.filt   = [];
% try 
  filters = dv_filtersDLG(dlg_pos, filters);
% end

if filters.nfilts > 0
  % For each selected object, we take the filter descriptions
  % and build a filter object to attach to the data object.
  ldv_setFilters(handles, filters);
end

% --- Executes on button press in dobjClearFilters.
function dobjClearFilters_Callback(hObject, eventdata, handles)
% hObject    handle to dobjClearFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ldv_clearFilters(handles);


% --- Executes when main is resized.
function main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in newObjectBtn.
function newObjectBtn_Callback(hObject, eventdata, handles)
% hObject    handle to newObjectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dobjInfoTxt.
function dobjInfoTxt_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dobjInfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

title = get(handles.dobjInfoPanel, 'Title');
str   = get(hObject, 'String');
ldv_disp('--------------------------');
ldv_disp(' %s', title);
ldv_disp('--------------------------');
disp(str);


% --- Executes on button press in dobjInfoApplyFilters.
function dobjInfoApplyFilters_Callback(hObject, eventdata, handles)
% hObject    handle to dobjInfoApplyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dobjInfoApplyFilters


% --- Executes on selection change in plotType.
function plotType_Callback(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotType

ldv_setplottype(handles);


% --- Executes during object creation, after setting all properties.
function plotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotPlotBtn.
function plotPlotBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotPlotBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_plot(handles);

function plotTimeSeriesMathTxt_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesMathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotTimeSeriesMathTxt as text
%        str2double(get(hObject,'String')) returns contents of plotTimeSeriesMathTxt as a double


% --- Executes during object creation, after setting all properties.
function plotTimeSeriesMathTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesMathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotTimeSeriesPlots.
function plotTimeSeriesPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotTimeSeriesPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotTimeSeriesPlots

plotconfig = ldv_getselectionbox(handles.plotTimeSeriesPlots);

if strcmp(plotconfig,'subplots')
    % make link axes visible
    set(handles.plotLinkChk, 'Visible', 'on');
    set(handles.plotLinkChk, 'Value', 1);
else
    set(handles.plotLinkChk, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plotTimeSeriesPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotSpectrumPlots.
function plotSpectrumPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrumPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrumPlots

plotconfig = ldv_getselectionbox(handles.plotSpectrumPlots);

if strcmp(plotconfig,'subplots')
    % make link axes visible
    set(handles.plotLinkChk, 'Visible', 'on');
    set(handles.plotLinkChk, 'Value', 1);
else
    set(handles.plotLinkChk, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plotSpectrumPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotCoherencePlots.
function plotCoherencePlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotCoherencePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotCoherencePlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotCoherencePlots

plotconfig = ldv_getselectionbox(handles.plotCoherencePlots);

if strcmp(plotconfig,'subplots')
    % make link axes visible
    set(handles.plotLinkChk, 'Visible', 'on');
    set(handles.plotLinkChk, 'Value', 1);
else
    set(handles.plotLinkChk, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plotCoherencePlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotCoherencePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotTFPlots.
function plotTFPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotTFPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        plotTFPlots

% --- Executes during object creation, after setting all properties.
function plotTFPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTFPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotSpectrogramPlots.
function plotSpectrogramPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrogramPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrogramPlots

plotconfig = ldv_getselectionbox(handles.plotSpectrogramPlots);

if strcmp(plotconfig,'subplots')
    % make link axes visible
    set(handles.plotLinkChk, 'Visible', 'on');
    set(handles.plotLinkChk, 'Value', 1);
else
    set(handles.plotLinkChk, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plotSpectrogramPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotHistogramPlots.
function plotHistogramPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotHistogramPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotHistogramPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotHistogramPlots


% --- Executes during object creation, after setting all properties.
function plotHistogramPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotHistogramPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotHeterodynePlots.
function plotHeterodynePlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotHeterodynePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotHeterodynePlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotHeterodynePlots


% --- Executes during object creation, after setting all properties.
function plotHeterodynePlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotHeterodynePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotTimeSeriesMathEGs.
function plotTimeSeriesMathEGs_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesMathEGs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotTimeSeriesMathEGs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotTimeSeriesMathEGs

str = ldv_getselectionbox(hObject);
set(handles.plotTimeSeriesMathTxt, 'String', str);


% --- Executes during object creation, after setting all properties.
function plotTimeSeriesMathEGs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesMathEGs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in preprocResampleR.
function preprocResampleR_Callback(hObject, eventdata, handles)
% hObject    handle to preprocResampleR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns preprocResampleR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from preprocResampleR


% --- Executes during object creation, after setting all properties.
function preprocResampleR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprocResampleR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preprocMathInput_Callback(hObject, eventdata, handles)
% hObject    handle to preprocMathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preprocMathInput as text
%        str2double(get(hObject,'String')) returns contents of preprocMathInput as a double


% --- Executes during object creation, after setting all properties.
function preprocMathInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprocMathInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveObjectsBtn.
function saveObjectsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveObjectsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_savedobjs(handles);

% --- Executes on button press in loadObjectsBtn.
function loadObjectsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadObjectsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% existing data objects
dobjs = getappdata(handles.main, 'dobjs');
didx  = ldv_getselecteddobjs(handles);

% load data objects
indobjs = ldv_loaddobjs(handles);

% add to list
dobjs = ldv_dobjsunique(dobjs, indobjs, handles);

% set list of objects
setappdata(handles.main, 'dobjs', dobjs);
ldv_setnobjsdisplay(handles, dobjs);
ldv_setdobjslist(handles, dobjs, 1);



% --- Executes on selection change in gd_stat.
function gd_stat_Callback(hObject, eventdata, handles)
% hObject    handle to gd_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns gd_stat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gd_stat


% --- Executes during object creation, after setting all properties.
function gd_stat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gd_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dv_spectrumEditFreqs.
function dv_spectrumEditFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to dv_spectrumEditFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% current frequencies
freqs = getappdata(handles.main, 'freqs');
 
pos_size = get(handles.main,'Position');
dlg_pos  = [pos_size(1)+pos_size(3)/5 pos_size(2)+pos_size(4)/5];
freqs    = dv_freqsDLG(dlg_pos, freqs);

setappdata(handles.main, 'freqs', freqs);
set(handles.plotSpectrumNfreqs, 'String', ['#freqs=',num2str(freqs.nfreqs)]);


% --- Executes on button press in dv_correctFilters.
function dv_correctFilters_Callback(hObject, eventdata, handles)
% hObject    handle to dv_correctFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dv_correctFilters



function dobjsSearchTxt_Callback(hObject, eventdata, handles)
% hObject    handle to dobjsSearchTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dobjsSearchTxt as text
%        str2double(get(hObject,'String')) returns contents of dobjsSearchTxt as a double

ldv_dobjsSearch(handles);


% --- Executes during object creation, after setting all properties.
function dobjsSearchTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dobjsSearchTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSpectrumMarkFreqs.
function plotSpectrumMarkFreqs_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumMarkFreqs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrumMarkFreqs


% --- Executes on selection change in plotSpectrumScales.
function plotSpectrumScales_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrumScales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrumScales


% --- Executes during object creation, after setting all properties.
function plotSpectrumScales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotSpectrumNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrumNfft as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrumNfft as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrumNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotSpectrumNoverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrumNoverlap as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrumNoverlap as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrumNoverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotSpectrumWindows.
function plotSpectrumWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrumWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrumWindows


% --- Executes during object creation, after setting all properties.
function plotSpectrumWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dv_getPrimeData.
function dv_getPrimeData_Callback(hObject, eventdata, handles)
% hObject    handle to dv_getPrimeData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dv_getPrimeData


% --- Executes on button press in dv_applyFiltersOn.
function dv_applyFiltersOn_Callback(hObject, eventdata, handles)
% hObject    handle to dv_applyFiltersOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dv_setFilterState(handles, 'on');


% --- Executes on button press in dv_applyFiltersOff.
function dv_applyFiltersOff_Callback(hObject, eventdata, handles)
% hObject    handle to dv_applyFiltersOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dv_setFilterState(handles, 'off');



function plotUnitTxt_Callback(hObject, eventdata, handles)
% hObject    handle to plotUnitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotUnitTxt as text
%        str2double(get(hObject,'String')) returns contents of plotUnitTxt as a double


% --- Executes during object creation, after setting all properties.
function plotUnitTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotUnitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotUnitSelect.
function plotUnitSelect_Callback(hObject, eventdata, handles)
% hObject    handle to plotUnitSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotUnitSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotUnitSelect

ldv_setunit(handles);

% --- Executes during object creation, after setting all properties.
function plotUnitSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotUnitSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotCoherenceNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotCoherenceNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotCoherenceNfft as text
%        str2double(get(hObject,'String')) returns contents of plotCoherenceNfft as a double


% --- Executes during object creation, after setting all properties.
function plotCoherenceNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotCoherenceNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotCoherenceNoverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotCoherenceNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotCoherenceNoverlap as text
%        str2double(get(hObject,'String')) returns contents of plotCoherenceNoverlap as a double


% --- Executes during object creation, after setting all properties.
function plotCoherenceNoverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotCoherenceNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotCoherencePrimaryChan.
function plotCoherencePrimaryChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotCoherencePrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotCoherencePrimaryChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotCoherencePrimaryChan


% --- Executes during object creation, after setting all properties.
function plotCoherencePrimaryChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotCoherencePrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotCoherenceWindows.
function plotCoherenceWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotCoherenceWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotCoherenceWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotCoherenceWindows


% --- Executes during object creation, after setting all properties.
function plotCoherenceWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotCoherenceWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotTFNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotTFNfft as text
%        str2double(get(hObject,'String')) returns contents of plotTFNfft as a double


% --- Executes during object creation, after setting all properties.
function plotTFNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTFNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotTFNoverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotTFNoverlap as text
%        str2double(get(hObject,'String')) returns contents of plotTFNoverlap as a double


% --- Executes during object creation, after setting all properties.
function plotTFNoverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTFNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotTFWindows.
function plotTFWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotTFWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotTFWindows


% --- Executes during object creation, after setting all properties.
function plotTFWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTFWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotTFPrimaryChan.
function plotTFPrimaryChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotTFPrimaryChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotTFPrimaryChan


% --- Executes during object creation, after setting all properties.
function plotTFPrimaryChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTFPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotSpectrogramNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrogramNfft as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrogramNfft as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrogramNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotSpectrogramNoverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrogramNoverlap as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrogramNoverlap as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrogramNoverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotSpectrogramWindows.
function plotSpectrogramWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrogramWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrogramWindows


% --- Executes during object creation, after setting all properties.
function plotSpectrogramWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotSpectrogramColorMap.
function plotSpectrogramColorMap_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSpectrogramColorMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSpectrogramColorMap


% --- Executes during object creation, after setting all properties.
function plotSpectrogramColorMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSpectrogramInterpolate.
function plotSpectrogramInterpolate_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramInterpolate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrogramInterpolate


% --- Executes on button press in plotSpectrogramNormalise.
function plotSpectrogramNormalise_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramNormalise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrogramNormalise


% --- Executes on button press in plotSpectrogramLogY.
function plotSpectrogramLogY_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramLogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrogramLogY


% --- Executes on button press in exportObjectsBtn.
function exportObjectsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to exportObjectsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_exportdobjs(handles);

% --- Executes on button press in preprocWhitening.
function preprocWhitening_Callback(hObject, eventdata, handles)
% hObject    handle to preprocWhitening (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preprocWhitening


% --- Executes on button press in duplicateObjectsBtn.
function duplicateObjectsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to duplicateObjectsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_duplicatedobjs(handles);


% --- Executes on button press in plotSpectrogramEdges.
function plotSpectrogramEdges_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrogramEdges



function plotSpectrogramSigPixThresh_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramSigPixThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrogramSigPixThresh as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrogramSigPixThresh as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrogramSigPixThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrogramSigPixThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotTFOpenLoop.
function plotTFOpenLoop_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFOpenLoop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotTFOpenLoop



function nfEstBW_Callback(hObject, eventdata, handles)
% hObject    handle to nfEstBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfEstBW as text
%        str2double(get(hObject,'String')) returns contents of nfEstBW as a double


% --- Executes during object creation, after setting all properties.
function nfEstBW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfEstBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nfEstOutliers_Callback(hObject, eventdata, handles)
% hObject    handle to nfEstOutliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfEstOutliers as text
%        str2double(get(hObject,'String')) returns contents of nfEstOutliers as a double


% --- Executes during object creation, after setting all properties.
function nfEstOutliers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfEstOutliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nfEstChk.
function nfEstChk_Callback(hObject, eventdata, handles)
% hObject    handle to nfEstChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nfEstChk


% --- Executes on selection change in plotXCorrPlots.
function plotXCorrPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotXCorrPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXCorrPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXCorrPlots

plotconfig = ldv_getselectionbox(handles.plotXCorrPlots);

if strcmp(plotconfig,'subplots')
    % make link axes visible
    set(handles.plotLinkChk, 'Visible', 'on');
    set(handles.plotLinkChk, 'Value', 1);
else
    set(handles.plotLinkChk, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plotXCorrPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXCorrPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotXCorrWindows.
function plotXCorrWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotXCorrWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXCorrWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXCorrWindows


% --- Executes during object creation, after setting all properties.
function plotXCorrWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXCorrWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotXCorrPrimaryChan.
function plotXCorrPrimaryChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotXCorrPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXCorrPrimaryChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXCorrPrimaryChan


% --- Executes during object creation, after setting all properties.
function plotXCorrPrimaryChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXCorrPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on selection change in plotXCorrScaleopts.
function plotXCorrScaleopts_Callback(hObject, eventdata, handles)
% hObject    handle to plotXCorrScaleopts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXCorrScaleopts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXCorrScaleopts


% --- Executes during object creation, after setting all properties.
function plotXCorrScaleopts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXCorrScaleopts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotXCorrAuto.
function plotXCorrAuto_Callback(hObject, eventdata, handles)
% hObject    handle to plotXCorrAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotXCorrAuto

if get(hObject, 'Value')
  set(handles.plotXCorrPrimaryChan, 'Enable', 'off');
else
  set(handles.plotXCorrPrimaryChan, 'Enable', 'on');
end  


% --- Executes on button press in plotTFcpsd.
function plotTFcpsd_Callback(hObject, eventdata, handles)
% hObject    handle to plotTFcpsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotTFcpsd


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over gpsStartInput.
function gpsStartInput_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gpsStartInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function plotTimeSeriesAvLength_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesAvLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotTimeSeriesAvLength as text
%        str2double(get(hObject,'String')) returns contents of plotTimeSeriesAvLength as a double


% --- Executes during object creation, after setting all properties.
function plotTimeSeriesAvLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesAvLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotTimeSeriesAvChk.
function plotTimeSeriesAvChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesAvChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotTimeSeriesAvChk



function plotHistogramBins_Callback(hObject, eventdata, handles)
% hObject    handle to plotHistogramBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotHistogramBins as text
%        str2double(get(hObject,'String')) returns contents of plotHistogramBins as a double


% --- Executes during object creation, after setting all properties.
function plotHistogramBins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotHistogramBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotHistogramDetrend.
function plotHistogramDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to plotHistogramDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotHistogramDetrend



function plotHistogramLower_Callback(hObject, eventdata, handles)
% hObject    handle to plotHistogramLower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotHistogramLower as text
%        str2double(get(hObject,'String')) returns contents of plotHistogramLower as a double


% --- Executes during object creation, after setting all properties.
function plotHistogramLower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotHistogramLower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotHistogramUpper_Callback(hObject, eventdata, handles)
% hObject    handle to plotHistogramUpper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotHistogramUpper as text
%        str2double(get(hObject,'String')) returns contents of plotHistogramUpper as a double


% --- Executes during object creation, after setting all properties.
function plotHistogramUpper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotHistogramUpper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in launchSPtool.
function launchSPtool_Callback(hObject, eventdata, handles)
% hObject    handle to launchSPtool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_launchsptool(handles);



function preprocF0_Callback(hObject, eventdata, handles)
% hObject    handle to preprocF0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preprocF0 as text
%        str2double(get(hObject,'String')) returns contents of preprocF0 as a double


% --- Executes during object creation, after setting all properties.
function preprocF0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprocF0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preprocBW_Callback(hObject, eventdata, handles)
% hObject    handle to preprocBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preprocBW as text
%        str2double(get(hObject,'String')) returns contents of preprocBW as a double


% --- Executes during object creation, after setting all properties.
function preprocBW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprocBW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preprocHet.
function preprocHet_Callback(hObject, eventdata, handles)
% hObject    handle to preprocHet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preprocHet


% --- Executes on button press in plotSpectrumLineDetect.
function plotSpectrumLineDetect_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumLineDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrumLineDetect



function plotSpectrumLineThresh_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumLineThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotSpectrumLineThresh as text
%        str2double(get(hObject,'String')) returns contents of plotSpectrumLineThresh as a double


% --- Executes during object creation, after setting all properties.
function plotSpectrumLineThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSpectrumLineThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotXlims_Callback(hObject, eventdata, handles)
% hObject    handle to plotXlims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotXlims as text
%        str2double(get(hObject,'String')) returns contents of plotXlims as a double


% --- Executes during object creation, after setting all properties.
function plotXlims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXlims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSaveBtn.
function plotSaveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotSaveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotSaveChk.
function plotSaveChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotSaveChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSaveChk



function plotDataSelect_Callback(hObject, eventdata, handles)
% hObject    handle to plotDataSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotDataSelect as text
%        str2double(get(hObject,'String')) returns contents of plotDataSelect as a double


% --- Executes during object creation, after setting all properties.
function plotDataSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotDataSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSpectrumLogFreq.
function plotSpectrumLogFreq_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumLogFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrumLogFreq


% --- Executes on selection change in plotLPSDPlots.
function plotLPSDPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotLPSDPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotLPSDPlots


% --- Executes during object creation, after setting all properties.
function plotLPSDPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotLPSDScales.
function plotLPSDScales_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotLPSDScales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotLPSDScales


% --- Executes during object creation, after setting all properties.
function plotLPSDScales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDScales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotLPSDNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotLPSDNfft as text
%        str2double(get(hObject,'String')) returns contents of plotLPSDNfft as a double


% --- Executes during object creation, after setting all properties.
function plotLPSDNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotLPSDNoverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotLPSDNoverlap as text
%        str2double(get(hObject,'String')) returns contents of plotLPSDNoverlap as a double


% --- Executes during object creation, after setting all properties.
function plotLPSDNoverlap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDNoverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu43.
function popupmenu43_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu43 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu43


% --- Executes during object creation, after setting all properties.
function popupmenu43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotLPSDLineDetect.
function plotLPSDLineDetect_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDLineDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotLPSDLineDetect



function plotLPSDLineThresh_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDLineThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotLPSDLineThresh as text
%        str2double(get(hObject,'String')) returns contents of plotLPSDLineThresh as a double


% --- Executes during object creation, after setting all properties.
function plotLPSDLineThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDLineThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26



function plotLPSDnavmin_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDnavmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotLPSDnavmin as text
%        str2double(get(hObject,'String')) returns contents of plotLPSDnavmin as a double


% --- Executes during object creation, after setting all properties.
function plotLPSDnavmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDnavmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotLPSDnavmax_Callback(hObject, eventdata, handles)
% hObject    handle to plotLPSDnavmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotLPSDnavmax as text
%        str2double(get(hObject,'String')) returns contents of plotLPSDnavmax as a double


% --- Executes during object creation, after setting all properties.
function plotLPSDnavmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotLPSDnavmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ff_dirstruct.
function ff_dirstruct_Callback(hObject, eventdata, handles)
% hObject    handle to ff_dirstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ff_dirstruct contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ff_dirstruct


% --- Executes during object creation, after setting all properties.
function ff_dirstruct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ff_dirstruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ff_dirpath_Callback(hObject, eventdata, handles)
% hObject    handle to ff_dirpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ff_dirpath as text
%        str2double(get(hObject,'String')) returns contents of ff_dirpath as a double


% --- Executes during object creation, after setting all properties.
function ff_dirpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ff_dirpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ff_browse.
function ff_browse_Callback(hObject, eventdata, handles)
% hObject    handle to ff_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_dirbrowse(handles);


% --- Executes on button press in ff_cache.
function ff_cache_Callback(hObject, eventdata, handles)
% hObject    handle to ff_cache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_buildFileCache(handles);


% --- Executes on button press in ff_saveCache.
function ff_saveCache_Callback(hObject, eventdata, handles)
% hObject    handle to ff_saveCache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_saveCache(handles);


% --- Executes on button press in ff_loadCache.
function ff_loadCache_Callback(hObject, eventdata, handles)
% hObject    handle to ff_loadCache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_loadCache(handles);


% --- Executes on button press in ff_queryCache.
function ff_queryCache_Callback(hObject, eventdata, handles)
% hObject    handle to ff_queryCache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_queryCache(handles)


% --- Executes on selection change in plotBicoherePlots.
function plotBicoherePlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicoherePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotBicoherePlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotBicoherePlots


% --- Executes during object creation, after setting all properties.
function plotBicoherePlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicoherePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotBicohereNfft_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotBicohereNfft as text
%        str2double(get(hObject,'String')) returns contents of plotBicohereNfft as a double


% --- Executes during object creation, after setting all properties.
function plotBicohereNfft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicohereNfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotBicohereNf_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereNf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotBicohereNf as text
%        str2double(get(hObject,'String')) returns contents of plotBicohereNf as a double


% --- Executes during object creation, after setting all properties.
function plotBicohereNf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicohereNf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotBicohereWindows.
function plotBicohereWindows_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotBicohereWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotBicohereWindows


% --- Executes during object creation, after setting all properties.
function plotBicohereWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicohereWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotBicohereColorMap.
function plotBicohereColorMap_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotBicohereColorMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotBicohereColorMap


% --- Executes during object creation, after setting all properties.
function plotBicohereColorMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicohereColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotBicohereInterpolate.
function plotBicohereInterpolate_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereInterpolate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotBicohereInterpolate


% --- Executes on button press in checkbox30.
function checkbox30_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox30


% --- Executes on button press in plotBicohereLogY.
function plotBicohereLogY_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereLogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotBicohereLogY


% --- Executes on button press in checkbox32.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox32


% --- Executes on selection change in plotBicoherePrimaryChan.
function plotBicoherePrimaryChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicoherePrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotBicoherePrimaryChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotBicoherePrimaryChan


% --- Executes during object creation, after setting all properties.
function plotBicoherePrimaryChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotBicoherePrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotBicohereAuto.
function plotBicohereAuto_Callback(hObject, eventdata, handles)
% hObject    handle to plotBicohereAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotBicohereAuto

if get(hObject, 'Value')
  set(handles.plotBicoherePrimaryChan, 'Enable', 'off');
else
  set(handles.plotBicoherePrimaryChan, 'Enable', 'on');
end  


% --- Executes on button press in ff_clearCache.
function ff_clearCache_Callback(hObject, eventdata, handles)
% hObject    handle to ff_clearCache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dv_clearCache(handles);


% --- Executes on button press in plotSpectrumMinMax.
function plotSpectrumMinMax_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumMinMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrumMinMax

% switch to single plot mode
if get(hObject, 'Value')
  set(handles.plotSpectrumPlots, 'Value', 1);
  set(handles.plotSpectrumPlots, 'String', {'single'});
  set(handles.plotSpectrumLogFreq, 'Value', 0);
  set(handles.plotSpectrumLogFreq, 'Enable', 'off');
else
  set(handles.plotSpectrumPlots, 'String', {'single', 'stacked', 'subplots'});
  set(handles.plotSpectrumPlots, 'Value', 2);
  set(handles.plotSpectrumLogFreq, 'Enable', 'on');
end



function ff_lastLines_Callback(hObject, eventdata, handles)
% hObject    handle to ff_lastLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ff_lastLines as text
%        str2double(get(hObject,'String')) returns contents of ff_lastLines as a double


% --- Executes during object creation, after setting all properties.
function ff_lastLines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ff_lastLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotSpectrumRMS.
function plotSpectrumRMS_Callback(hObject, eventdata, handles)
% hObject    handle to plotSpectrumRMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotSpectrumRMS


% --- Executes on button press in calibrateChk.
function calibrateChk_Callback(hObject, eventdata, handles)
% hObject    handle to calibrateChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibrateChk



function plotYlims_Callback(hObject, eventdata, handles)
% hObject    handle to plotYlims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotYlims as text
%        str2double(get(hObject,'String')) returns contents of plotYlims as a double


% --- Executes during object creation, after setting all properties.
function plotYlims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotYlims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in combineObjsBtn.
function combineObjsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to combineObjsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_combinedobjs(handles);


% --- Executes on button press in plotExportChk.
function plotExportChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotExportChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotExportChk



function combineObjsMathTxt_Callback(hObject, eventdata, handles)
% hObject    handle to combineObjsMathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of combineObjsMathTxt as text
%        str2double(get(hObject,'String')) returns contents of combineObjsMathTxt as a double


% --- Executes during object creation, after setting all properties.
function combineObjsMathTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combineObjsMathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotXYscatterPlots.
function plotXYscatterPlots_Callback(hObject, eventdata, handles)
% hObject    handle to plotXYscatterPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXYscatterPlots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXYscatterPlots


% --- Executes during object creation, after setting all properties.
function plotXYscatterPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXYscatterPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit66_Callback(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit66 as text
%        str2double(get(hObject,'String')) returns contents of edit66 as a double


% --- Executes during object creation, after setting all properties.
function edit66_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit66 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit67_Callback(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit67 as text
%        str2double(get(hObject,'String')) returns contents of edit67 as a double


% --- Executes during object creation, after setting all properties.
function edit67_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit67 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu53.
function popupmenu53_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu53 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu53


% --- Executes during object creation, after setting all properties.
function popupmenu53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotXYscatterPrimaryChan.
function plotXYscatterPrimaryChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotXYscatterPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotXYscatterPrimaryChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotXYscatterPrimaryChan


% --- Executes during object creation, after setting all properties.
function plotXYscatterPrimaryChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotXYscatterPrimaryChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in preprocUnits.
function preprocUnits_Callback(hObject, eventdata, handles)
% hObject    handle to preprocUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns preprocUnits contents as cell array
%        contents{get(hObject,'Value')} returns selected item from preprocUnits


% --- Executes during object creation, after setting all properties.
function preprocUnits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preprocUnits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reloadChannelList.
function reloadChannelList_Callback(hObject, eventdata, handles)
% hObject    handle to reloadChannelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ldv_reloadChannelList(handles);


% --- Executes on button press in plotLinkChk.
function plotLinkChk_Callback(hObject, eventdata, handles)
% hObject    handle to plotLinkChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotLinkChk


% --- Executes on button press in helpServerBtn.
function helpServerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpServerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Help.show('ServerInfo');

% --- Executes on key press with focus on helpServerBtn and none of its controls.
function helpServerBtn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to helpServerBtn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in helpTimeSetBtn.
function helpTimeSetBtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpTimeSetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Help.show('TimeIntervals');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over helpTimeSetBtn.
function helpTimeSetBtn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to helpTimeSetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in helpPreprocess.
function helpPreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to helpPreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Help.show('Preprocess');

% --- Executes on button press in helpAnalsysPlot.
function helpAnalsysPlot_Callback(hObject, eventdata, handles)
% hObject    handle to helpAnalsysPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Help.show('AnalysisPlot');


% --- Executes on button press in helpDatapool.
function helpDatapool_Callback(hObject, eventdata, handles)
% hObject    handle to helpDatapool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
    Help.show('Datapool');


% --- Executes on button press in helpChanList.
function helpChanList_Callback(hObject, eventdata, handles)
% hObject    handle to helpChanList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    Help.show('ChannelList');



% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ligodv_wiki_Callback(hObject, eventdata, handles)
% hObject    handle to ligodv_wiki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Help.home();

% --------------------------------------------------------------------
function check_for_updates_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to check_for_updates_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Help.checkForUpdate(false); % false means confirm current or newer always


% --------------------------------------------------------------------
function preferences_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to preferences_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    p=Preferences.instance();
    p.setHandles(handles);      % make sure Preferences knows our handles
    p.showDlg();

% --------------------------------------------------------------------
function quit_cmd_Callback(hObject, eventdata, handles)
% hObject    handle to quit_cmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close all;

%---------------------------------------------------------------------
function updtCurTime(obj, event, string_arg)
% called by a button press or a timer event, this updates the current
% time being displayed
    global ligoDVFigHandles;
    latest = ldv_getlatest(ligoDVFigHandles);
    ldv_setlatest(ligoDVFigHandles, latest);
    


% --- Executes when user attempts to close main.
function main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global clockTimer;

try
    if (~isempty(clockTimer))
        stop(clockTimer);
    end
catch e
    disp('error deleting clock');
end

delete(hObject);



function dobjInfoTxt_Callback(hObject, eventdata, handles)
% hObject    handle to dobjInfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dobjInfoTxt as text
%        str2double(get(hObject,'String')) returns contents of dobjInfoTxt as a double


% --- Executes on key press with focus on dobjInfoTxt and none of its controls.
function dobjInfoTxt_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to dobjInfoTxt (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dobjInfoTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dobjInfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function dobjInfoTxt_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to dobjInfoTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on includeControlChansChk and none of its controls.
function includeControlChansChk_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to includeControlChansChk (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in plotOmegagramColorMap.
function plotOmegagramColorMap_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotOmegagramColorMap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotOmegagramColorMap


% --- Executes during object creation, after setting all properties.
function plotOmegagramColorMap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramColorMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotOmegagramWhitenChan.
function plotOmegagramWhitenChan_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramWhitenChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotOmegagramWhitenChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotOmegagramWhitenChan


% --- Executes during object creation, after setting all properties.
function plotOmegagramWhitenChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramWhitenChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramAspectRatio_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramAspectRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramAspectRatio as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramAspectRatio as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramAspectRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramAspectRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramWhiteningDuration_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramWhiteningDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramWhiteningDuration as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramWhiteningDuration as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramWhiteningDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramWhiteningDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramEnergyLoss_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramEnergyLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramEnergyLoss as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramEnergyLoss as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramEnergyLoss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramEnergyLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramFAR_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramFAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramFAR as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramFAR as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramFAR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramFAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plotOmegagramNormMenu.
function plotOmegagramNormMenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramNormMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotOmegagramNormMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotOmegagramNormMenu


% --- Executes during object creation, after setting all properties.
function plotOmegagramNormMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramNormMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramFreqRange_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramFreqRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramFreqRange as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramFreqRange as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramFreqRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramFreqRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotOmegagramQrange_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramQrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotOmegagramQrange as text
%        str2double(get(hObject,'String')) returns contents of plotOmegagramQrange as a double


% --- Executes during object creation, after setting all properties.
function plotOmegagramQrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOmegagramQrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotOmegagramSquaredColorbar.
function plotOmegagramSquaredColorbar_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramSquaredColorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotOmegagramSquaredColorbar


% --- Executes on button press in plotOmegagramLogY.
function plotOmegagramLogY_Callback(hObject, eventdata, handles)
% hObject    handle to plotOmegagramLogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotOmegagramLogY


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over reloadChannelList.
function reloadChannelList_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to reloadChannelList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on reloadChannelList and none of its controls.
function reloadChannelList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to reloadChannelList (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in searchChanBtn.
function searchChanBtn_Callback(hObject, eventdata, handles)
% hObject    handle to searchChanBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  vals = chanFilter();
  
  disp(vals);
  if (strcmpi(vals.cmd,'search'))
      ldv_getChannelList2(handles,vals);
  end
  


% --------------------------------------------------------------------
function plots_Callback(hObject, eventdata, handles)
% hObject    handle to plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function odcPlotMI_Callback(hObject, eventdata, handles)
% hObject    handle to odcPlotMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    CallOdcPlot(handles);
    


% --------------------------------------------------------------------
function coherenceMI_Callback(hObject, eventdata, handles)
% hObject    handle to coherenceMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function histogramMI_Callback(hObject, eventdata, handles)
% hObject    handle to histogramMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function omegaScanMI_Callback(hObject, eventdata, handles)
% hObject    handle to omegaScanMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function spectrogram_Callback(hObject, eventdata, handles)
% hObject    handle to spectrogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    spectrogramParam();

% --------------------------------------------------------------------
function spectrumMI_Callback(hObject, eventdata, handles)
% hObject    handle to spectrumMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    spectrumParam();

% --------------------------------------------------------------------
function timeSeriesMI_Callback(hObject, eventdata, handles)
% hObject    handle to timeSeriesMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    timeSeriesParam();

% --------------------------------------------------------------------
function tfCpsdMI_Callback(hObject, eventdata, handles)
% hObject    handle to tfCpsdMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function xyScatterMI_Callback(hObject, eventdata, handles)
% hObject    handle to xyScatterMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function bicoherenceMI_Callback(hObject, eventdata, handles)
% hObject    handle to bicoherenceMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function testdataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to testdataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sawtoothMI_Callback(hObject, eventdata, handles)
% hObject    handle to sawtoothMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateSawtooth(handles);


% --------------------------------------------------------------------
function singlesineTestMI_Callback(hObject, eventdata, handles)
% hObject    handle to singlesineTestMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateSinglesine(handles);


% --------------------------------------------------------------------
function impulseTestMI_Callback(hObject, eventdata, handles)
% hObject    handle to impulseTestMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateImpulse(handles);

% --------------------------------------------------------------------
function squareTestMI_Callback(hObject, eventdata, handles)
% hObject    handle to squareTestMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateSquareWave(handles);

% --------------------------------------------------------------------
function whiteNoiseTestMI_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseTestMI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateWhiteNoise(handles);


% --------------------------------------------------------------------
function ldvwImport_Callback(hObject, eventdata, handles)
% hObject    handle to ldvwImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ldvwImport(handles);
    drawnow;
