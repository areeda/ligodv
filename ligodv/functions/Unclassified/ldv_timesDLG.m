function varargout = ldv_timesDLG(varargin)
% LDV_TIMESDLG M-file for ldv_timesDLG.fig
%      LDV_TIMESDLG, by itself, creates a new LDV_TIMESDLG or raises the existing
%      singleton*.
%
%      H = LDV_TIMESDLG returns the handle to a new LDV_TIMESDLG or the handle to
%      the existing singleton*.
%
%      LDV_TIMESDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LDV_TIMESDLG.M with the given input arguments.
%
%      LDV_TIMESDLG('Property','Value',...) creates a new LDV_TIMESDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dv_timesDLG_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ldv_timesDLG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ldv_timesDLG

% Last Modified by GUIDE v2.5 08-Feb-2012 09:49:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ldv_timesDLG_OpeningFcn, ...
                   'gui_OutputFcn',  @ldv_timesDLG_OutputFcn, ...
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


% --- Executes just before ldv_timesDLG is made visible.
function ldv_timesDLG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ldv_timesDLG (see VARARGIN)


% Choose default command line output for ldv_timesDLG
% handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set tooltips
tdlg_settooltips(handles);

% Get old lines list from dataviewer
setappdata(handles.main, 'times', varargin{2});
tdlg_settimeslist(handles);

% setappdata(handles.main, 'oldtimes', varargin{2});
% setLinesList(handles);
% oldtimes = varargin{2};


% UIWAIT makes ldv_timesDLG wait for user response (see UIRESUME)
uiwait(handles.main);
% 
% if ~ishandle(handles.main)
%   lines = oldlines;
% else
%   % otherwise, we got here because the user pushed one of the two buttons.
%   % retrieve the latest copy of the 'handles' struct, and return the answer.
%   % Also, we need to delete the window.
%   lines = getappdata(handles.main, 'lines');
% %   varargout{1} = lines;
%   delete(handles.main);
% end



% --- Outputs from this function are returned to the command line.
function varargout = ldv_timesDLG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
times = getappdata(handles.main, 'times');
varargout{1} = times;
delete(handles.main);


% --- Executes on button press in tdlg_closeBtn.
function tdlg_closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.main);


% --- Executes on selection change in tdlg_timesList.
function tdlg_timesList_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_timesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tdlg_timesList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tdlg_timesList

tdlg_timeselect(handles);


% --- Executes during object creation, after setting all properties.
function tdlg_timesList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_timesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tdlg_clearListBtn.
function tdlg_clearListBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_clearListBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set empty times list
times.t      = [];
times.ntimes = 0;
setappdata(handles.main, 'times', times);
% set the list display
tdlg_settimeslist(handles);

% --- Executes on button press in tdlg_deleteSelectedBtn.
function tdlg_deleteSelectedBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_deleteSelectedBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get selected time obhects
idx = get(handles.tdlg_timesList, 'Value');

% get times objects
times  = getappdata(handles.main, 'times');
ntimes = length(idx);
nidx   = 1:times.ntimes;

% delete selected
timesout.t = [];
timesout.ntimes = 0;
for j=1:times.ntimes
  
  if idx~=j
    
    timesout.ntimes = timesout.ntimes + 1;
    timesout.t(timesout.ntimes).startgps = times.t(j).startgps;
    timesout.t(timesout.ntimes).stopgps  = times.t(j).stopgps;
    timesout.t(timesout.ntimes).comment  = times.t(j).comment;
    
  end
  
end

% set the new times
setappdata(handles.main, 'times', timesout);
tdlg_settimeslist(handles);





function tdlg_utcStart_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_utcStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tdlg_utcstart(handles);
tdlg_setduration(handles);



% Hints: get(hObject,'String') returns contents of tdlg_utcStart as text
%        str2double(get(hObject,'String')) returns contents of tdlg_utcStart as a double


% --- Executes during object creation, after setting all properties.
function tdlg_utcStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_utcStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tdlg_utcStop_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_utcStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tdlg_utcStop as text
%        str2double(get(hObject,'String')) returns contents of tdlg_utcStop as a double
tdlg_utcstop(handles);
tdlg_setduration(handles);


% --- Executes during object creation, after setting all properties.
function tdlg_utcStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_utcStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tdlg_gpsStart_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_gpsStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tdlg_gpsStart as text
%        str2double(get(hObject,'String')) returns contents of tdlg_gpsStart as a double
tdlg_gpsstart(handles);
tdlg_setduration(handles);


% --- Executes during object creation, after setting all properties.
function tdlg_gpsStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_gpsStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tdlg_gpsStop_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_gpsStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tdlg_gpsStop as text
%        str2double(get(hObject,'String')) returns contents of tdlg_gpsStop as a double
tdlg_gpsstop(handles);
tdlg_setduration(handles);


% --- Executes during object creation, after setting all properties.
function tdlg_gpsStop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_gpsStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tdlg_comment_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tdlg_comment as text
%        str2double(get(hObject,'String')) returns contents of tdlg_comment as a double


% --- Executes during object creation, after setting all properties.
function tdlg_comment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdlg_comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tdlg_addBtn.
function tdlg_addBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_addBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get new times struct
times = tdlg_addtime(handles);
% set as application data
setappdata(handles.main, 'times', times);
% update times list
tdlg_settimeslist(handles);

% --- Executes on button press in tdlg_lastHourBtn.
function tdlg_lastHourBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_lastHourBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get a set of times
times = tdlg_getlasthour(handles);

% set list
setappdata(handles.main, 'times', times);
tdlg_settimeslist(handles);

% --- Executes on button press in tdlg_lastDayBtn.
function tdlg_lastDayBtn_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_lastDayBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get a set of times
times = tdlg_getlastday(handles);

% set list
setappdata(handles.main, 'times', times);
tdlg_settimeslist(handles);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tdlg_saveList.
function tdlg_saveList_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_saveList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tdlg_saveList(handles);

% --- Executes on button press in tdlg_loadList.
function tdlg_loadList_Callback(hObject, eventdata, handles)
% hObject    handle to tdlg_loadList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

times = tdlg_loadList(handles);
% set list
setappdata(handles.main, 'times', times);
tdlg_settimeslist(handles);
