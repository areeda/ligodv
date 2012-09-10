function varargout = dv_freqsDLG(varargin)
% DV_FREQSDLG M-file for dv_freqsDLG.fig
%      DV_FREQSDLG, by itself, creates a new DV_FREQSDLG or raises the existing
%      singleton*.
%
%      H = DV_FREQSDLG returns the handle to a new DV_FREQSDLG or the handle to
%      the existing singleton*.
%
%      DV_FREQSDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DV_FREQSDLG.M with the given input arguments.
%
%      DV_FREQSDLG('Property','Value',...) creates a new DV_FREQSDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dv_freqsDLG_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dv_freqsDLG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dv_freqsDLG

% Last Modified by GUIDE v2.5 14-Feb-2012 09:44:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dv_freqsDLG_OpeningFcn, ...
                   'gui_OutputFcn',  @dv_freqsDLG_OutputFcn, ...
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


% --- Executes just before dv_freqsDLG is made visible.
function dv_freqsDLG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dv_freqsDLG (see VARARGIN)

% Choose default command line output for dv_freqsDLG
handles.output = hObject;

% set tooltips
fqdlg_settooltips(handles);

% setup frequencies
freqs = varargin{2};
setappdata(handles.main, 'freqs', freqs);

% rebuild freqs list
fqdlg_setFreqsList(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dv_freqsDLG wait for user response (see UIRESUME)
uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = dv_freqsDLG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% try 
  freqs = getappdata(handles.main, 'freqs');
  varargout{1} = freqs;
  delete(handles.main);
% end

% --- Executes on selection change in fdlg_freqList.
function fdlg_freqList_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_freqList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fdlg_freqList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fdlg_freqList


% --- Executes during object creation, after setting all properties.
function fdlg_freqList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_freqList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_closeBtn.
function fdlg_closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.main);

% --- Executes on button press in fdlg_clearListBtn.
function fdlg_clearListBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_clearListBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fqdlg_clearFreqs(handles);


% --- Executes on button press in fdlg_deleteBtn.
function fdlg_deleteBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_deleteBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fqdlg_deleteSelectedFreqs(handles);

% --- Executes on button press in fdlg_addBtn.
function fdlg_addBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_addBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fqdlg_addFrequency(handles);


function fdlg_fInput_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_fInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fdlg_fInput as text
%        str2double(get(hObject,'String')) returns contents of fdlg_fInput as a double
fqdlg_addFrequency(handles);

% --- Executes during object creation, after setting all properties.
function fdlg_fInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fdlg_fInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fqdlg_f0_Callback(hObject, eventdata, handles)
% hObject    handle to fqdlg_f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fqdlg_f0 as text
%        str2double(get(hObject,'String')) returns contents of fqdlg_f0 as a double


% --- Executes during object creation, after setting all properties.
function fqdlg_f0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fqdlg_f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdlg_addHarmonicsBtn.
function fdlg_addHarmonicsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_addHarmonicsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fqdlg_addHarmonicSeries(handles);


function fqdlg_Nf_Callback(hObject, eventdata, handles)
% hObject    handle to fqdlg_Nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fqdlg_Nf as text
%        str2double(get(hObject,'String')) returns contents of fqdlg_Nf as a double


% --- Executes during object creation, after setting all properties.
function fqdlg_Nf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fqdlg_Nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fdlg_addL1Btn.
function fdlg_addL1Btn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_addL1Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fqdlg_addL1Callines(handles);

% --- Executes on button press in fdlg_addH2Btn.
function fdlg_addH2Btn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_addH2Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fqdlg_addH2Callines(handles);

% --- Executes on button press in fdlg_addH1Btn.
function fdlg_addH1Btn_Callback(hObject, eventdata, handles)
% hObject    handle to fdlg_addH1Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fqdlg_addH1Callines(handles);
