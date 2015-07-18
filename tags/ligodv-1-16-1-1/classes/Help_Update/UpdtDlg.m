function varargout = UpdtDlg(varargin)
% UPDTDLG MATLAB code for UpdtDlg.fig
%      UPDTDLG, by itself, creates a new UPDTDLG or raises the existing
%      singleton*.
%
%      H = UPDTDLG returns the handle to a new UPDTDLG or the handle to
%      the existing singleton*.
%
%      UPDTDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UPDTDLG.M with the given input arguments.
%
%      UPDTDLG('Property','Value',...) creates a new UPDTDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UpdtDlg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UpdtDlg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UpdtDlg

% Last Modified by GUIDE v2.5 06-Feb-2012 13:08:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UpdtDlg_OpeningFcn, ...
                   'gui_OutputFcn',  @UpdtDlg_OutputFcn, ...
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


% --- Executes just before UpdtDlg is made visible.
function UpdtDlg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UpdtDlg (see VARARGIN)

% Choose default command line output for UpdtDlg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UpdtDlg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UpdtDlg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in gotoWebBtn.
function gotoWebBtn_Callback(hObject, eventdata, handles)
% hObject    handle to gotoWebBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % open a browser to the DESCRIPTION of the new version with
    % instructions on how to download and install
    url = Help.getUpdatePage();
    web(url,'-browser');
    close;


% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close;      % now they know
