function varargout = dv_newobjectDLG(varargin)
% DV_NEWOBJECTDLG M-file for dv_newobjectDLG.fig
%      DV_NEWOBJECTDLG, by itself, creates a new DV_NEWOBJECTDLG or raises the existing
%      singleton*.
%
%      H = DV_NEWOBJECTDLG returns the handle to a new DV_NEWOBJECTDLG or the handle to
%      the existing singleton*.
%
%      DV_NEWOBJECTDLG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DV_NEWOBJECTDLG.M with the given input arguments.
%
%      DV_NEWOBJECTDLG('Property','Value',...) creates a new DV_NEWOBJECTDLG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dv_newobjectDLG_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dv_newobjectDLG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dv_newobjectDLG

% Last Modified by GUIDE v2.5 08-Aug-2006 16:38:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dv_newobjectDLG_OpeningFcn, ...
                   'gui_OutputFcn',  @dv_newobjectDLG_OutputFcn, ...
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


% --- Executes just before dv_newobjectDLG is made visible.
function dv_newobjectDLG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dv_newobjectDLG (see VARARGIN)

% Choose default command line output for dv_newobjectDLG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dv_newobjectDLG wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = dv_newobjectDLG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
