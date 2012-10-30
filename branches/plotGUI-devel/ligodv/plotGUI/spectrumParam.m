function varargout = spectrumParam(varargin)
% SPECTRUMPARAM MATLAB code for spectrumParam.fig
%      SPECTRUMPARAM, by itself, creates a new SPECTRUMPARAM or raises the existing
%      singleton*.
%
%      H = SPECTRUMPARAM returns the handle to a new SPECTRUMPARAM or the handle to
%      the existing singleton*.
%
%      SPECTRUMPARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRUMPARAM.M with the given input arguments.
%
%      SPECTRUMPARAM('Property','Value',...) creates a new SPECTRUMPARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spectrumParam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spectrumParam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spectrumParam

% Last Modified by GUIDE v2.5 26-Oct-2012 08:34:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spectrumParam_OpeningFcn, ...
                   'gui_OutputFcn',  @spectrumParam_OutputFcn, ...
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


% --- Executes just before spectrumParam is made visible.
function spectrumParam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spectrumParam (see VARARGIN)

% Choose default command line output for spectrumParam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spectrumParam wait for user response (see UIRESUME)
% uiwait(handles.spectrumParamFig);


% --- Outputs from this function are returned to the command line.
function varargout = spectrumParam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotPB.
function plotPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiwait(msgbox('Function not implemented yet','You are dreaming','modal'));

% --- Executes on button press in queuePB.
function queuePB_Callback(hObject, eventdata, handles)
% hObject    handle to queuePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiwait(msgbox('Function not implemented yet','You are dreaming','modal'));

% --- Executes on button press in cancelPB.
function cancelPB_Callback(hObject, eventdata, handles)
% hObject    handle to cancelPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in savePB.
function savePB_Callback(hObject, eventdata, handles)
% hObject    handle to savePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiwait(msgbox('Function not implemented yet','You are dreaming','modal'));

% --- Executes on button press in setDefaultPB.
function setDefaultPB_Callback(hObject, eventdata, handles)
% hObject    handle to setDefaultPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uiwait(msgbox('Function not implemented yet','You are dreaming','modal'));

% --- Executes on selection change in selconfigPM.
function selconfigPM_Callback(hObject, eventdata, handles)
% hObject    handle to selconfigPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selconfigPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selconfigPM


% --- Executes during object creation, after setting all properties.
function selconfigPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selconfigPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% --- Executes on selection change in scalingPM.
function scalingPM_Callback(hObject, eventdata, handles)
% hObject    handle to scalingPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns scalingPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scalingPM


% --- Executes during object creation, after setting all properties.
function scalingPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalingPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in rmsCB.
function rmsCB_Callback(hObject, eventdata, handles)
% hObject    handle to rmsCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rmsCB



function secpfftTxt_Callback(hObject, eventdata, handles)
% hObject    handle to secpfftTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secpfftTxt as text
%        str2double(get(hObject,'String')) returns contents of secpfftTxt as a double


% --- Executes during object creation, after setting all properties.
function secpfftTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secpfftTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function olapTxt_Callback(hObject, eventdata, handles)
% hObject    handle to olapTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of olapTxt as text
%        str2double(get(hObject,'String')) returns contents of olapTxt as a double


% --- Executes during object creation, after setting all properties.
function olapTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to olapTxt (see GCBO)
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



function threshTxt_Callback(hObject, eventdata, handles)
% hObject    handle to threshTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshTxt as text
%        str2double(get(hObject,'String')) returns contents of threshTxt as a double


% --- Executes during object creation, after setting all properties.
function threshTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tlimitTxt_Callback(hObject, eventdata, handles)
% hObject    handle to tlimitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tlimitTxt as text
%        str2double(get(hObject,'String')) returns contents of tlimitTxt as a double


% --- Executes during object creation, after setting all properties.
function tlimitTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tlimitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flimitTxt_Callback(hObject, eventdata, handles)
% hObject    handle to flimitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flimitTxt as text
%        str2double(get(hObject,'String')) returns contents of flimitTxt as a double


% --- Executes during object creation, after setting all properties.
function flimitTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flimitTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in logfaxisCB.
function logfaxisCB_Callback(hObject, eventdata, handles)
% hObject    handle to logfaxisCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logfaxisCB


% --- Executes on button press in correctfiltCB.
function correctfiltCB_Callback(hObject, eventdata, handles)
% hObject    handle to correctfiltCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of correctfiltCB


% --- Executes on button press in noisefloorestCB.
function noisefloorestCB_Callback(hObject, eventdata, handles)
% hObject    handle to noisefloorestCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noisefloorestCB


% --- Executes on button press in markFreqCB.
function markFreqCB_Callback(hObject, eventdata, handles)
% hObject    handle to markFreqCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of markFreqCB


% --- Executes on button press in detectlinesCB.
function detectlinesCB_Callback(hObject, eventdata, handles)
% hObject    handle to detectlinesCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detectlinesCB



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
