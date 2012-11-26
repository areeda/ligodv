function varargout = testData(varargin)
% TESTDATA MATLAB code for testData.fig
%      TESTDATA, by itself, creates a new TESTDATA or raises the existing
%      singleton*.
%
%      H = TESTDATA returns the handle to a new TESTDATA or the handle to
%      the existing singleton*.
%
%      TESTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTDATA.M with the given input arguments.
%
%      TESTDATA('Property','Value',...) creates a new TESTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testData

% Last Modified by GUIDE v2.5 25-Nov-2012 13:02:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testData_OpeningFcn, ...
                   'gui_OutputFcn',  @testData_OutputFcn, ...
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


% --- Executes just before testData is made visible.
function testData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testData (see VARARGIN)

% Choose default command line output for testData
handles.output = hObject;
h=varargin{1};
handles.ldvHandles = h;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testData wait for user response (see UIRESUME)
% uiwait(handles.testDataGenFigure);


% --- Outputs from this function are returned to the command line.
function varargout = testData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in goBtn.
function goBtn_Callback(hObject, eventdata, handles)
% hObject    handle to goBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    generateTestData(handles);
    close;

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close;


function fsTxt_Callback(hObject, eventdata, handles)
% hObject    handle to fsTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fsTxt as text
%        str2double(get(hObject,'String')) returns contents of fsTxt as a double


% --- Executes during object creation, after setting all properties.
function fsTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fsTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durTxt_Callback(hObject, eventdata, handles)
% hObject    handle to durTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durTxt as text
%        str2double(get(hObject,'String')) returns contents of durTxt as a double


% --- Executes during object creation, after setting all properties.
function durTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigFrqTxt_Callback(hObject, eventdata, handles)
% hObject    handle to sigFrqTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigFrqTxt as text
%        str2double(get(hObject,'String')) returns contents of sigFrqTxt as a double


% --- Executes during object creation, after setting all properties.
function sigFrqTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigFrqTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function harmonicTxt_Callback(hObject, eventdata, handles)
% hObject    handle to harmonicTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harmonicTxt as text
%        str2double(get(hObject,'String')) returns contents of harmonicTxt as a double


% --- Executes during object creation, after setting all properties.
function harmonicTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harmonicTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decayCB.
function decayCB_Callback(hObject, eventdata, handles)
% hObject    handle to decayCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of decayCB



function qVal_Callback(hObject, eventdata, handles)
% hObject    handle to qVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qVal as text
%        str2double(get(hObject,'String')) returns contents of qVal as a double


% --- Executes during object creation, after setting all properties.
function qVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
