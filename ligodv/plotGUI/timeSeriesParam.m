function varargout = timeSeriesParam(varargin)
% TIMESERIESPARAM MATLAB code for timeSeriesParam.fig
%      TIMESERIESPARAM, by itself, creates a new TIMESERIESPARAM or raises the existing
%      singleton*.
%
%      H = TIMESERIESPARAM returns the handle to a new TIMESERIESPARAM or the handle to
%      the existing singleton*.
%
%      TIMESERIESPARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMESERIESPARAM.M with the given input arguments.
%
%      TIMESERIESPARAM('Property','Value',...) creates a new TIMESERIESPARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timeSeriesParam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timeSeriesParam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help timeSeriesParam

% Last Modified by GUIDE v2.5 26-Oct-2012 08:35:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timeSeriesParam_OpeningFcn, ...
                   'gui_OutputFcn',  @timeSeriesParam_OutputFcn, ...
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


% --- Executes just before timeSeriesParam is made visible.
function timeSeriesParam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timeSeriesParam (see VARARGIN)

% Choose default command line output for timeSeriesParam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes timeSeriesParam wait for user response (see UIRESUME)
% uiwait(handles.timeSeriesParamFig);


% --- Outputs from this function are returned to the command line.
function varargout = timeSeriesParam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pcfgSingleBtn.
function pcfgSingleBtn_Callback(hObject, eventdata, handles)
% hObject    handle to pcfgSingleBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pcfgSingleBtn


% --- Executes on button press in pfcStackedBtn.
function pfcStackedBtn_Callback(hObject, eventdata, handles)
% hObject    handle to pfcStackedBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pfcStackedBtn


% --- Executes on button press in pcfgSubpltBtn.
function pcfgSubpltBtn_Callback(hObject, eventdata, handles)
% hObject    handle to pcfgSubpltBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pcfgSubpltBtn


% --- Executes on button press in plotBtn.
function plotBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ldvMsgbox('Function not implemented yet','You are dreaming');

% --- Executes on button press in queueBtn.
function queueBtn_Callback(hObject, eventdata, handles)
% hObject    handle to queueBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ldvMsgbox('Function not implemented yet','You are dreaming');

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close(handles.timeSeriesParamFig);


function mathFnTxt_Callback(hObject, eventdata, handles)
% hObject    handle to mathFnTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mathFnTxt as text
%        str2double(get(hObject,'String')) returns contents of mathFnTxt as a double


% --- Executes during object creation, after setting all properties.
function mathFnTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mathFnTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in examplePM.
function examplePM_Callback(hObject, eventdata, handles)
% hObject    handle to examplePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns examplePM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from examplePM
    contents = cellstr(get(hObject,'String'));
    val = contents{get(hObject,'Value')};
    set(handles.mathFnTxt,'String',val);
    

% --- Executes during object creation, after setting all properties.
function examplePM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to examplePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in timeAvgCB.
function timeAvgCB_Callback(hObject, eventdata, handles)
% hObject    handle to timeAvgCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timeAvgCB



function timeAvgTxt_Callback(hObject, eventdata, handles)
% hObject    handle to timeAvgTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeAvgTxt as text
%        str2double(get(hObject,'String')) returns contents of timeAvgTxt as a double


% --- Executes during object creation, after setting all properties.
function timeAvgTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeAvgTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlimTxt_Callback(hObject, eventdata, handles)
% hObject    handle to xlimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlimTxt as text
%        str2double(get(hObject,'String')) returns contents of xlimTxt as a double


% --- Executes during object creation, after setting all properties.
function xlimTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylimTxt_Callback(hObject, eventdata, handles)
% hObject    handle to ylimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylimTxt as text
%        str2double(get(hObject,'String')) returns contents of ylimTxt as a double


% --- Executes during object creation, after setting all properties.
function ylimTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in defaultBtn.
function defaultBtn_Callback(hObject, eventdata, handles)
% hObject    handle to defaultBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in loadconfigPM.
function loadconfigPM_Callback(hObject, eventdata, handles)
% hObject    handle to loadconfigPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns loadconfigPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loadconfigPM


% --- Executes during object creation, after setting all properties.
function loadconfigPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadconfigPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
