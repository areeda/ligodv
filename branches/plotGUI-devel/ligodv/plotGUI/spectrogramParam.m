function varargout = spectrogramParam(varargin)
% SPECTROGRAMPARAM MATLAB code for spectrogramParam.fig
%      SPECTROGRAMPARAM, by itself, creates a new SPECTROGRAMPARAM or raises the existing
%      singleton*.
%
%      H = SPECTROGRAMPARAM returns the handle to a new SPECTROGRAMPARAM or the handle to
%      the existing singleton*.
%
%      SPECTROGRAMPARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTROGRAMPARAM.M with the given input arguments.
%
%      SPECTROGRAMPARAM('Property','Value',...) creates a new SPECTROGRAMPARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrogramParam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrogramParam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrogramParam

% Last Modified by GUIDE v2.5 26-Oct-2012 08:41:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrogramParam_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrogramParam_OutputFcn, ...
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


% --- Executes just before spectrogramParam is made visible.
function spectrogramParam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrogramParam (see VARARGIN)

% Choose default command line output for spectrogramParam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spectrogramParam wait for user response (see UIRESUME)
% uiwait(handles.spectrogramParamFig);


% --- Outputs from this function are returned to the command line.
function varargout = spectrogramParam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in windowPM.
function windowPM_Callback(hObject, eventdata, handles)
% hObject    handle to windowPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns windowPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from windowPM


% --- Executes during object creation, after setting all properties.
function windowPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorPM.
function colorPM_Callback(hObject, eventdata, handles)
% hObject    handle to colorPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colorPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorPM


% --- Executes during object creation, after setting all properties.
function colorPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in interpCB.
function interpCB_Callback(hObject, eventdata, handles)
% hObject    handle to interpCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interpCB


% --- Executes on button press in normCB.
function normCB_Callback(hObject, eventdata, handles)
% hObject    handle to normCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normCB


% --- Executes on button press in logyCB.
function logyCB_Callback(hObject, eventdata, handles)
% hObject    handle to logyCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logyCB


% --- Executes on button press in edgeDetectCB.
function edgeDetectCB_Callback(hObject, eventdata, handles)
% hObject    handle to edgeDetectCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edgeDetectCB


% --- Executes on button press in correctFiltCB.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to correctFiltCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of correctFiltCB


% --- Executes on button press in correctFiltCB.
function correctFiltCB_Callback(hObject, eventdata, handles)
% hObject    handle to correctFiltCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of correctFiltCB



function secPerFftTxt_Callback(hObject, eventdata, handles)
% hObject    handle to secPerFftTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secPerFftTxt as text
%        str2double(get(hObject,'String')) returns contents of secPerFftTxt as a double


% --- Executes during object creation, after setting all properties.
function secPerFftTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secPerFftTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function overlapTxt_Callback(hObject, eventdata, handles)
% hObject    handle to overlapTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlapTxt as text
%        str2double(get(hObject,'String')) returns contents of overlapTxt as a double


% --- Executes during object creation, after setting all properties.
function overlapTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bwTxt_Callback(hObject, eventdata, handles)
% hObject    handle to bwTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bwTxt as text
%        str2double(get(hObject,'String')) returns contents of bwTxt as a double


% --- Executes during object creation, after setting all properties.
function bwTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bwTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
    close(handles.spectrogramParamFig);

% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ldvMsgbox('Function not implemented yet','You are dreaming');

% --- Executes on button press in setDefaultBtn.
function setDefaultBtn_Callback(hObject, eventdata, handles)
% hObject    handle to setDefaultBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    ldvMsgbox('Function not implemented yet','You are dreaming');

% --- Executes on selection change in loadconfigMenu.
function loadconfigMenu_Callback(hObject, eventdata, handles)
% hObject    handle to loadconfigMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns loadconfigMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from loadconfigMenu


% --- Executes during object creation, after setting all properties.
function loadconfigMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadconfigMenu (see GCBO)
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
    ldvMsgbox('Function not implemented yet','You are dreaming');


function outlierTxt_Callback(hObject, eventdata, handles)
% hObject    handle to outlierTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outlierTxt as text
%        str2double(get(hObject,'String')) returns contents of outlierTxt as a double


% --- Executes during object creation, after setting all properties.
function outlierTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outlierTxt (see GCBO)
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



function yLimTxt_Callback(hObject, eventdata, handles)
% hObject    handle to yLimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yLimTxt as text
%        str2double(get(hObject,'String')) returns contents of yLimTxt as a double


% --- Executes during object creation, after setting all properties.
function yLimTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLimTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in scalePM.
function scalePM_Callback(hObject, eventdata, handles)
% hObject    handle to scalePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scalePM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scalePM


% --- Executes during object creation, after setting all properties.
function scalePM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalePM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
