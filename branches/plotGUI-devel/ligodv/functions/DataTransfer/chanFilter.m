function varargout = chanFilter(varargin)
% CHANFILTER MATLAB code for chanFilter.fig
%      CHANFILTER by itself, creates a new CHANFILTER or raises the
%      existing singleton*.
%
%      H = CHANFILTER returns the handle to a new CHANFILTER or the handle to
%      the existing singleton*.
%
%      CHANFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANFILTER.M with the given input arguments.
%
%      CHANFILTER('Property','Value',...) creates a new CHANFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chanFilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chanFilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chanFilter

% Last Modified by GUIDE v2.5 12-Sep-2012 08:20:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chanFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @chanFilter_OutputFcn, ...
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

% --- Executes just before chanFilter is made visible.
function chanFilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chanFilter (see VARARGIN)

% Choose default command line output for chanFilter
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

% Insert custom Title and Text if specified by the user
% Hint: when choosing keywords, be sure they are not easily confused 
% with existing figure properties.  See the output of set(figure) for
% a list of figure properties.
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'title'
          set(hObject, 'Name', varargin{index+1});
         case 'string'
          set(handles.text1, 'String', varargin{index+1});
        end
    end
end

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

%-----added by jsa to remember values from last call
global chanSelectVals;  % save the selections for next time

if (isfield(chanSelectVals, 'filtStr'))
    set(handles.fsPopup,'value',chanSelectVals.fsIndex);
    set(handles.ifoPopup,'value',chanSelectVals.ifoIndex);
    set(handles.subsysPopup,'value',chanSelectVals.subsysIndex);
    set(handles.fsComp,'value',chanSelectVals.fsCompVal);
    set(handles.nameFiltText,'String',chanSelectVals.filtStr);
end
%----------------------------------------

% Make the GUI modal
set(handles.ChanFilter,'WindowStyle','modal')

% UIWAIT makes chanFilter wait for user response (see UIRESUME)
uiwait(handles.ChanFilter);

% --- Outputs from this function are returned to the command line.
function varargout = chanFilter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global chanSelectVals;  % save the selections for next time

v=get(handles.fsPopup,'value');
s=get(handles.fsPopup,'String');
chanSelectVals.fsIndex=v;
fs=s(v);

v=get(handles.ifoPopup,'value');
s=get(handles.ifoPopup,'String');
chanSelectVals.ifoIndex = v;
ifo=s(v);

v=get(handles.subsysPopup,'value');
s=get(handles.subsysPopup,'String');
chanSelectVals.subsysIndex = v;
subsys=s(v);

v=get(handles.fsComp,'value');
s=get(handles.fsComp,'String');
chanSelectVals.fsCompVal = v;
fsComp=s(v);

filtStr= get(handles.nameFiltText,'String');
chanSelectVals.filtStr = filtStr;

vals = struct( ...
    'cmd',  handles.output,...
    'fs', fs, ...
    'ifo', ifo, ...
    'subsys', subsys, ...
    'fscomp', fsComp, ...
    'filtstr', filtStr ...
    );

varargout{1} = vals;    % return them to caller
% The figure can be deleted now
delete(handles.ChanFilter);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.ChanFilter);

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.ChanFilter);


% --- Executes when user attempts to close ChanFilter.
function ChanFilter_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ChanFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over ChanFilter with no controls selected.
function ChanFilter_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ChanFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.ChanFilter);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.ChanFilter);
end    


% --- Executes on button press in srchBtn.
function srchBtn_Callback(hObject, eventdata, handles)
% hObject    handle to srchBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.ChanFilter);

% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Help.show('ChanFilter');


function nameFiltText_Callback(hObject, eventdata, handles)
% hObject    handle to nameFiltText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameFiltText as text
%        str2double(get(hObject,'String')) returns contents of nameFiltText as a double


% --- Executes during object creation, after setting all properties.
function nameFiltText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameFiltText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ifoPopup.
function ifoPopup_Callback(hObject, eventdata, handles)
% hObject    handle to ifoPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ifoPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ifoPopup


% --- Executes during object creation, after setting all properties.
function ifoPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ifoPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subsysPopup.
function subsysPopup_Callback(hObject, eventdata, handles)
% hObject    handle to subsysPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subsysPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subsysPopup


% --- Executes during object creation, after setting all properties.
function subsysPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subsysPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fsComp.
function fsComp_Callback(hObject, eventdata, handles)
% hObject    handle to fsComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fsComp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fsComp


% --- Executes during object creation, after setting all properties.
function fsComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fsComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fsPopup.
function fsPopup_Callback(hObject, eventdata, handles)
% hObject    handle to fsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fsPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fsPopup


% --- Executes during object creation, after setting all properties.
function fsPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ChanFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChanFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
