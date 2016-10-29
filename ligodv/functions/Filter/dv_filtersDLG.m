function varargout = dv_filtersDLG(varargin)
% DV_FILTERSDLG M-file for dv_filtersDLG.fig
%      DV_FILTERSDLG, by itself, creates a new DV_FILTERSDLG or raises the existing
%      singleton*.
%
%      H = DV_FILTERSDLG returns the handle to a new DV_FILTERSDLG or the handle to
%      the existing singleton*.
%
%      DV_FILTERSDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DV_FILTERSDLG.M with the given input arguments.
%
%      DV_FILTERSDLG('Property','Value',...) creates a new DV_FILTERSDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dv_filtersDLG_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dv_filtersDLG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dv_filtersDLG

% Last Modified by GUIDE v2.5 17-Feb-2012 16:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dv_filtersDLG_OpeningFcn, ...
                   'gui_OutputFcn',  @dv_filtersDLG_OutputFcn, ...
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


% --- Executes just before dv_filtersDLG is made visible.
function dv_filtersDLG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dv_filtersDLG (see VARARGIN)

% Choose default command line output for dv_filtersDLG
handles.output = hObject;

% load settings file - this gets the 'settings' structure.
ldvparams;

% add functions/ to path
% addpath(ldv_settings.general.functions_path)

% make settings structure
setappdata(handles.main, 'ldv_settings', ldv_settings);

% now we have the functions path the rest can go in init()
handles = fdlg_init(handles);

% set tooltips
fdlg_settooltips(handles);


% setup filters
filters = varargin{2};
setappdata(handles.main, 'filters', filters);
% rebuild filter list
fdlg_setFilterList(handles);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dv_filtersDLG wait for user response (see UIRESUME)
uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = dv_filtersDLG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try 
  filters = getappdata(handles.main, 'filters');
  varargout{1} = filters;
  delete(handles.main);
catch e
  msg =   'Click apply to apply filters.';
  mymsg = sprintf(msg);
  mb = msgbox(mymsg, 'Filters not applied', 'warn');
  waitfor(mb);
  error(msg);
end


% --- Executes on selection change in fdlg_entryMode.
function fdlg_entryMode_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_entryMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fdlg_entryMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdlg_entryMode

fdlg_setEntryMode(handles);


% --- Executes during object creation, after setting all properties.
function fdlg_entryMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_entryMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fdlg_filterList.
function fdlg_filterList_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_filterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fdlg_filterList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdlg_filterList
fdlg_filterSelected(handles);


% --- Executes during object creation, after setting all properties.
function fdlg_filterList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_filterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_deleteSelected.
function fdlg_deleteSelected_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_deleteSelected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fdlg_deleteSelected(handles);

% --- Executes on button press in fdlg_clearList.
function fdlg_clearList_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_clearList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fdlg_deleteAll(handles);

% --- Executes on button press in fdlg_saveFilter.
function fdlg_saveFilter_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_saveFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fdlg_saveFilters(handles);

% --- Executes on button press in fdlg_loadFilter.
function fdlg_loadFilter_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_loadFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get current filters
filters = getappdata(handles.main, 'filters');
% load new filters
newfilters = fdlg_loadFilters(handles);
filters.nfilts = filters.nfilts+newfilters.nfilts;
filters.filt = [filters.filt newfilters.filt];
% add to filter structure
setappdata(handles.main, 'filters', filters);
% rebuild filter list
fdlg_setFilterList(handles);


% --- Executes on selection change in fdlg_fsSelect.
function fdlg_fsSelect_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_fsSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fdlg_fsSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdlg_fsSelect


% --- Executes during object creation, after setting all properties.
function fdlg_fsSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_fsSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_viewFilter.
function fdlg_viewFilter_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_viewFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fdlg_viewFilters(handles);


% --- Executes on button press in fdlg_closeBtn.
function fdlg_closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.main);

% --- Executes on button press in fdlg_exportFilter.
function fdlg_exportFilter_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_exportFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fdlg_exportFilters(handles);

% --- Executes on selection change in fdlg_inputStandardTypes.
function fdlg_inputStandardTypes_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardTypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fdlg_inputStandardTypes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdlg_inputStandardTypes

fdlg_setStandardType(handles);


% --- Executes during object creation, after setting all properties.
function fdlg_inputStandardTypes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardTypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fdlg_inputStandardF1_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputStandardF1 as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputStandardF1 as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputStandardF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fdlg_inputStandardF2_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputStandardF2 as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputStandardF2 as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputStandardF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fdlg_inputStandardOrder_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputStandardOrder as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputStandardOrder as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputStandardOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fdlg_inputStandardGain_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputStandardGain as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputStandardGain as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputStandardGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_inputStandardAddBtn.
function fdlg_inputStandardAddBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputStandardAddBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fdlg_addStandardFilter(handles);



function fdlg_inputPZpoles_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputPZpoles as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputPZpoles as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputPZpoles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_inputPZAddBtn.
function fdlg_inputPZAddBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZAddBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fdlg_inputPZAdd(handles);



function fdlg_inputPZzeros_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZzeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputPZzeros as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputPZzeros as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputPZzeros_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZzeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fdlg_inputPZgain_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_inputPZgain as text
%        str2double(get(hObject,'String')) returns contents of fdlg_inputPZgain as a double


% --- Executes during object creation, after setting all properties.
function fdlg_inputPZgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_inputPZgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_combineFilters.
function fdlg_combineFilters_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_combineFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fdlg_combineFilters
if (get(hObject, 'Value') == get(hObject, 'MAX'))
else
end
    
    
