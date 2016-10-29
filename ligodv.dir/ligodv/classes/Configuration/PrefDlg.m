function varargout = PrefDlg(varargin)
% PREFDLG MATLAB code for PrefDlg.fig
%      PREFDLG, by itself, creates a new PREFDLG or raises the existing
%      singleton*.
%
%      H = PREFDLG returns the handle to a new PREFDLG or the handle to
%      the existing singleton*.
%
%      PREFDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFDLG.M with the given input arguments.
%
%      PREFDLG('Property','Value',...) creates a new PREFDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PrefDlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PrefDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PrefDlg

% Last Modified by GUIDE v2.5 09-Feb-2012 08:23:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PrefDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @PrefDlg_OutputFcn, ...
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


% --- Executes just before PrefDlg is made visible.
function PrefDlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PrefDlg (see VARARGIN)

% Choose default command line output for PrefDlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% There doesn't seem to be a GUIDE way to set the table to select rows
% So, let's try accessing the Java object

% Set the list of existing configurations
    setConfigLB(handles);
    
% UIWAIT makes PrefDlg wait for user response (see UIRESUME)
% uiwait(handles.prefDlg);


% --- Outputs from this function are returned to the command line.
function varargout = PrefDlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in configList.
function configList_Callback(hObject, eventdata, handles)
% hObject    handle to configList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns configList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from configList

% --- Executes during object creation, after setting all properties.
function configList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Preferences.instance().save();
    setConfigLB(handles);


% --- Executes on button press in makeDefBtn.
function makeDefBtn_Callback(hObject, eventdata, handles)
% hObject    handle to makeDefBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Preferences.instance().saveDefault();
    setConfigLB(handles);

% --- Executes on button press in applyBtn.
function applyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to applyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    sel = get(handles.configLB, 'Value');
    didit = Preferences.instance().apply(sel);
    if (didit)
        close;      % an error from apply does not close the dialog
    end
    

% --- Executes on button press in delBtn.
function delBtn_Callback(hObject, eventdata, handles)
% hObject    handle to delBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    sel = get(handles.configLB, 'Value');
    Preferences.instance().remove(sel);
    setConfigLB(handles);
    

% --- Executes on button press in resetBtn.
function resetBtn_Callback(hObject, eventdata, handles)
% hObject    handle to resetBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Preferences.instance().reset();
    close;


% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    close;


% --- Executes on button press in helpPB.
function helpPB_Callback(hObject, eventdata, handles)
% hObject    handle to helpPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Help.show('Preferences_Dialog');


% --- Executes on selection change in configLB.
function configLB_Callback(hObject, eventdata, handles)
% hObject    handle to configLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns configLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from configLB


% --- Executes during object creation, after setting all properties.
function configLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setConfigLB(handles)
% set the contents of the list box to the available configurations
% deal with deleted configurations and an empty list
    lstData = Preferences.instance().getUIListData();
    lst = handles.configLB;
    len = length(lstData);
    if (len < 1)
        lstData = {'-'};
    end
    set(lst, 'String', lstData);
    v = get(lst, 'Value');
    if (v > len)
        set(lst, 'Value', 1);
    end
    
