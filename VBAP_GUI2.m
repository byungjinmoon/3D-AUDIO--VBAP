function varargout = VBAP_GUI2(varargin)
% VBAP_GUI2 MATLAB code for VBAP_GUI2.fig
%      VBAP_GUI2, by itself, creates a new VBAP_GUI2 or raises the existing
%      singleton*.
%
%      H = VBAP_GUI2 returns the handle to a new VBAP_GUI2 or the handle to
%      the existing singleton*.
%
%      VBAP_GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VBAP_GUI2.M with the given input arguments.
%
%      VBAP_GUI2('Property','Value',...) creates a new VBAP_GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VBAP_GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VBAP_GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VBAP_GUI2

% Last Modified by GUIDE v2.5 02-Dec-2018 17:58:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VBAP_GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @VBAP_GUI2_OutputFcn, ...
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


% --- Executes just before VBAP_GUI2 is made visible.
function VBAP_GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VBAP_GUI2 (see VARARGIN)

% Choose default command line output for VBAP_GUI2
handles.output = hObject;
% ah = axes('unit', 'normalized', 'position',[0 0 1 1]);
% bg = imread('VBAP.png');imagesc(bg);  
% set(ah,'handlevisibility','off', 'visible','off')
global VS_elevation
VS_elevation=0;
axes(handles.axes2);
imshow('VBAP.png');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VBAP_GUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VBAP_GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VS_azimuth


x=0;
y=0;
x=handles.figure1.CurrentPoint(1);
y=handles.figure1.CurrentPoint(2);
y=y*(90/30);
x=-(x-45);
y=y-45;
handles.text1.String = num2str(x);
handles.text2.String = num2str(y);
r=sqrt((x.^2+y.^2));
VS_azimuth=acos(y/r)*180/pi;

if (x<0)
    VS_azimuth=-VS_azimuth;
end

handles.text8.String = num2str(VS_azimuth);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global VS_azimuth
global player
global VS_elevation

azimuth = [ -80 -65 -55 -45 :5 : 45 55 65 80]; 
%%
%the directions are defined as azimuth elevation;
loudspeakers=[0 0; 50 0; 130 0 ; -130 0; -50 0 ;  40  45; 180 45; -40 45];
ls_num=size(loudspeakers,1);
%panning vector
panvec=[VS_azimuth,VS_elevation];
%Define the 0triangles from the loudspeakers
ls_triangles=[1 2 6; 2 3 6; 3 4 7 ; 4 5 8; 5 1 8; 1 6 8; 3 6 7; 4 7 8; 6 7 8];

%actives_louds(azimuth, elevation)
for i=1 : size(ls_triangles(:,1))
    active_louds=loudspeakers(ls_triangles(i,:),:);
        for j=1 : size(active_louds(:,1))
            azimuth=active_louds(j,1);
            elevation=active_louds(j,2);
            %ls_matrix = x,y,z 3*3 matrix
            ls_matrix(j,1)=sin((90-elevation)/180*pi)*cos(azimuth/180*pi);
            ls_matrix(j,2)=sin((90-elevation)/180*pi)*sin(azimuth/180*pi);
            ls_matrix(j,3)=cos((90-elevation)/180*pi);
        end
    azimuth=panvec(1,1);
    elevation=panvec(1,2);
    p_matrix(1)=sin((90-elevation)/180*pi)*cos(azimuth/180*pi);
    p_matrix(2)=sin((90-elevation)/180*pi)*sin(azimuth/180*pi);
    p_matrix(3)=cos((90-elevation)/180*pi);
    
    
 g= p_matrix*inv(ls_matrix);

if min(g)>-0.01
tempg=g/sqrt(sum(g.^2));
gains=zeros(1,ls_num);
gains(1,ls_triangles(i,:))=tempg;
   break
          end

end
%%
%loudspeakers=[0 0; 50 0; 130 0 ; -130 0; -50 0 ;  40  45; 180 45; -40 45];

load('hrir_final.mat');
[x,fs]=audioread('home.mp3');
% x=x';
x=x(1:fs*3);
%[0,0]
h_l=squeeze(hrir_l(13,8,:));
y_left(:,1)=filter(h_l,1,x);
h_r=squeeze(hrir_r(13,8,:));
y_right(:,1)=filter(h_r,1,x);
%[50 0]
h_l=squeeze(hrir_l(3,8,:));
y_left(:,2)=filter(h_l,1,x);
h_r=squeeze(hrir_r(3,8,:));
y_right(:,2)=filter(h_r,1,x);
%[130 0]
h_l=squeeze(hrir_l(4,22 ,:));
y_left(:,3)=filter(h_l,1,x);
h_r=squeeze(hrir_r(4,22,:));
y_right(:,3)=filter(h_r,1,x);
%[-130 0]
h_l=squeeze(hrir_l(22,22 ,:));
y_left(:,4)=filter(h_l,1,x);
h_r=squeeze(hrir_r(22,22,:));
y_right(:,4)=filter(h_r,1,x);
%[ -50 0]
h_l=squeeze(hrir_l(23,8 ,:));
y_left(:,5)=filter(h_l,1,x);
h_r=squeeze(hrir_r(23,8,:));
y_right(:,5)=filter(h_r,1,x);
%[ 40  45]
h_l=squeeze(hrir_l(4,16 ,:));
y_left(:,6)=filter(h_l,1,x);
h_r=squeeze(hrir_r(4,16,:));
y_right(:,6)=filter(h_r,1,x);
%[ 180 45]
h_l=squeeze(hrir_l(13,32 ,:));
y_left(:,7)=filter(h_l,1,x);
h_r=squeeze(hrir_r(13,32,:));
y_right(:,7)=filter(h_r,1,x);
%[ -40 45]
h_l=squeeze(hrir_l(22,16 ,:));
y_left(:,8)=filter(h_l,1,x);
h_r=squeeze(hrir_r(22,16,:));
y_right(:,8)=filter(h_r,1,x);
%%
sum_L=0;
sum_R=0;

for i=1 : 8
    sum_L=sum_L+y_left(:,i)*gains(i);
    sum_R=sum_R+y_right(:,i)*gains(i);
end

output=[sum_L sum_R];
% sound(output,fs);
player=audioplayer(output,fs);
play(player);
% x=x;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
global VS_elevation

% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VS_elevation= get(handles.edit2 , 'String');
VS_elevation=str2num(VS_elevation);


% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
