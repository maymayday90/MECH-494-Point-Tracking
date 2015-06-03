function varargout = test2(varargin)
% TEST2 MATLAB code for test2.fig
%      TEST2, by itself, creates a new TEST2 or raises the existing
%      singleton*.
%
%      H = TEST2 returns the handle to a new TEST2 or the handle to
%      the existing singleton*.
%
%      TEST2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST2.M with the given input arguments.
%
%      TEST2('Property','Value',...) creates a new TEST2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test2

% Last Modified by GUIDE v2.5 27-Nov-2012 20:55:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test2_OpeningFcn, ...
                   'gui_OutputFcn',  @test2_OutputFcn, ...
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

% --- Executes just before test2 is made visible.
function test2_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.axes1,'XLim',[-2 2]);
set(handles.axes1,'Ylim',[-2 2]);

setappdata(handles.axes1,'A_ang',randi(120,1));
setappdata(handles.axes1,'B_ang',120+randi(120,1));
setappdata(handles.axes1,'C_ang',240+randi(120,1));

setappdata(gcf,'recordbutton',0);

handles.guifig = gcf;
intval = 0.01;
handles.tmr = timer('TimerFcn',{@TmrFcn,handles.guifig},'BusyMode','Queue','ExecutionMode','FixedRate','Period',intval);
%timer updating after every 0.1 secs
guidata(handles.guifig,handles);

handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = test2_OutputFcn(hObject, eventdata, handles) 
coords = get(handles.axes1,'CurrentPoint');
fprintf('x=%1.2f and y=%1.2f \n ',coords(1),coords(2))
varargout{1} = handles.output;

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
setappdata(gcbf,'scrollcount',0);
animator start

% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
set(gcf, 'WindowScrollWheelFcn', @figScroll);
function figScroll(src, evnt)
count = evnt.VerticalScrollCount;
numba = getappdata(gcbf,'scrollcount');
numba = numba + count;
setappdata(gcbf,'scrollcount',numba);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
get(handles.tmr)
pts = getappdata(gca,'pts')
test = getappdata(handles.axes1,'tiime')

% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
start(handles.tmr);
% datacollect = [P1(1); P1(2); P2(1); P2(2); P3(1); P3(2)];
guidata(hObject, handles);

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
stop(handles.tmr)

%Timer Function
function TmrFcn(src,event,handles) %Timer function
handles = guidata(handles);
thyme = get(handles.tmr,'TasksExecuted');
tiime = thyme * 0.01;
set(handles.text2,'String',tiime);
setappdata(handles.axes1,'tiime',thyme);

% csvwrite('csvlist.dat',pts);
% set(handles.edit1,'String',num2str(x)); %assuming x is type 'double'

guidata(handles.guifig, handles);

% --- Executes on button press of recordbutton.
function recordbutton_Callback(hObject, eventdata, handles)
rec_button_check = getappdata(gcf,'recordbutton');
if rec_button_check == 0
    set(handles.recordstatus,'String','on');
    set(handles.recordstatus,'ForegroundColor',[0 0.5 0])
    setappdata(gcf,'recordbutton',1)
elseif rec_button_check == 1
    set(handles.recordstatus,'String','off');
    set(handles.recordstatus,'ForegroundColor',[0.5 0 0])
    setappdata(gcf,'recordbutton',0)
else 
end 
