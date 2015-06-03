%% Data Pre-processing script for OptiTrack data
% Written by KJ Deluzio Oct. 2011

%% clear workspace
clear, close all

% Choose file and import data
[filename,pathname] = uigetfile('*.csv','Select the CSV data file');
pathfilename = [pathname,filename];

% We will make this the current directory
cd(pathname);

% filename = 'ad-ab.csv';
% We'll use csvread to read the data because it's in comma separated format
% The row and column arguments are zero based. 
% In the Optitrak data there are 43 header lines
% and the first column is also text - so we ignore these. 
% In the 'processed data (through Trajectorize - there are only two header
% rows and the first column is data. We can tell if it is processed because
% the filename is *processed.csv

if length(filename) > 13 & strcmp(filename(end-12:end),'processed.csv')
    data = csvread(pathfilename,2)
    [nframes,ncolumns] = size (data);
    n_markers = (ncolumns-1)/3;
    coords = data(:,2:ncolumns);
else % data must be unprocessed (raw) optitrak data with 43 header rows
    data = csvread(pathfilename,43,1);
    % The data format is a row for each frame of data and the column are:
    % Col 1 - frame id (integer)
    % Col 2 - timestamp (seconds)
    % Col 3 - number of trackable rigid bodies (0 if just tracking markers)
    % Col 4 - number of markers visible
    % Col 5:end - x,y,z,ID for each marker
    [nframes,ncolumns] = size(data);
    n_markers = (ncolumns - 4)/4;
    coords = data(:,5:ncolumns);
    % The markers are not identified so we strip these
    coords(:,4:4:end) = [];
end



% Now we create a picture of the markers
plot3Dpoints(coords(1,:))
hold on
% plot3(coords(1,:))
axis equal
grid on

%% Identify the clusters of markers
% Proximal segment - this is the fixed segment and is defined by two
%                    coordinate systems: 
%   Fixed_marker, Fm = a technical coordinate system based on three markers
%   Fixed_anatomical, Fa = an anatomical coordinate system based on anatomical
%                      landmarks
% Distal segment - this is the moving segment and is defined by two
%                  coordinate systems: 
%   Moving_marker, Mm = a technical coordinate system based on three markers
%   Moving_anatomical, Ma = an anatomical coordinate system based on anatomical
%                      landmarks

% Use the picture to identify the 3 markers on the fixed segment and the
% three markers on the moving segment. To do this edit the following code
% so that the the stars, *, are replaced with the correct marker number

%================================
%   EDIT THIS SECTION 
fixed_1 = 'm1'; % most proximal marker on fixed segment
fixed_2 = 'm2'; % marker direcly distal to fixed_1
fixed_3 = 'm3';

axis_4 = 'm4'; %Mayan's addition
axis_5 = 'm5';

moving_1 = 'm6'; % most proximal marker on moving segment
moving_2 = 'm7'; % marker directly distal to moving_1
moving_3 = 'm8';
%==================================

fixed_1_zcolumn = str2double(fixed_1(2:end))*3;
fixed_2_zcolumn = str2double(fixed_2(2:end))*3;
fixed_3_zcolumn = str2double(fixed_3(2:end))*3;
moving_1_zcolumn = str2double(moving_1(2:end))*3;
moving_2_zcolumn = str2double(moving_2(2:end))*3;
moving_3_zcolumn = str2double(moving_3(2:end))*3;

axis_4_zcolumn = str2double(axis_4(2:end))*3;   %mayan's addition
axis_5_zcolumn = str2double(axis_5(2:end))*3;

% We will select the 10th frame of data
frame = 10;

fixed_1 = coords(frame,fixed_1_zcolumn - 2:fixed_1_zcolumn); %m1
fixed_2 = coords(frame,fixed_2_zcolumn - 2:fixed_2_zcolumn); %m2
fixed_3 = coords(frame,fixed_3_zcolumn - 2:fixed_3_zcolumn); %m3
moving_1 = coords(frame,moving_1_zcolumn - 2:moving_1_zcolumn); %m6
moving_2 = coords(frame,moving_2_zcolumn - 2:moving_2_zcolumn);%m7
moving_3 = coords(frame,moving_3_zcolumn - 2:moving_3_zcolumn);%m8

axis_4 = coords(frame,axis_4_zcolumn - 2:axis_4_zcolumn); %m4
axis_5 = coords(frame,axis_5_zcolumn - 2:axis_5_zcolumn); %m5

m1 = fixed_1;
m2 = fixed_2;
m3 = fixed_3;
m4 = axis_4;
m5 = axis_5;
m6 = moving_1;
m7 = moving_2;
m8 = moving_3;

% now create pose matrices for fixed and moving bodies;
[i_fm,j_fm,k_fm] = create_rhcs(fixed_1,fixed_2,fixed_3);
[i_mm,j_mm,k_mm] = create_rhcs(moving_1,moving_2,moving_3);
Fm = eye(4);
Fm(2:4,1) = fixed_1';  % origin is set at fixed_1
Fm(2:4,2) = i_fm';      % transpose is necessary because they are row vectors
Fm(2:4,3) = j_fm';
Fm(2:4,4) = k_fm';

Mm = eye(4);
Mm(2:4,1) = moving_2';  % origin is set at moving_2
Mm(2:4,2) = i_mm';
Mm(2:4,3) = j_mm';
Mm(2:4,4) = k_mm';

%% Check to see that reference frames are right handed coordinate systems
% rotation submatrix of each pose matrix should = 1
det(Fm(2:4,2:4))
det(Mm(2:4,2:4))

%% Create Anatomical (functional) reference frames
% a medial and lateral marker identify the flexion-extension axis, and the
% vertical axis is defined by two of the markers on each rigid body aligned
% with the vertical axis;

%==============================
% EDIT THIS SECTION    

% you need to create 3 unit vectors (i_fa j_fa and k_fa) and an 
% origin (fa_origin) for the fixed segment and three 
% unit vectors (i_ma j_ma k_ma) and an origin (ma_origin)for the moving segment
% m1 = coords(1,1:3)

v2 = m5 - m4;
% v2 = axis_5-axis_4;
v1 = m1 - m2;
% v1 = fixed_1 - fixed_2;
v3 = cross(v2,v1);
v4 = cross(v3,v2);

i_fa = v4/norm(v4); % make sure this is a 1x3 unit vector
j_fa = v3/norm(v3); % make sure this is a 1x3 unit vector
k_fa = v2/norm(v2); % make sure this is a 1x3 unit vector
fa_origin =[0.5*m4(1)+0.5*m5(1);(0.5*m4(2)+0.5*m5(2))+0.05;0.5*m4(3)+0.5*m5(3)]


v5 = m6 - m8;
% v5 = moving_1 - moving_3;
v6 = cross(v2,v5);
v7 = cross(v6,v2);

i_ma = v7/norm(v7);  % make sure this is a 1x3 unit vector
j_ma = v6/norm(v6);  % make sure this is a 1x3 unit vector
k_ma = v2/norm(v2);  % make sure this is a 1x3 unit vector
ma_origin =[0.5*m4(1)+0.5*m5(1);(0.5*m4(2)+0.5*m5(2))-0.05;0.5*m4(3)+0.5*m5(3)]  ;

% vf1 = m1-m2;
% vf2 = m1-m3;
% vf3 = cross(vf1,vf2)

% fixed marker coordinates

v1 = m1 - m2;
v2 = m3 - m2;
v3 = cross(v1,v2);
v4 = cross(v3,v1);
ifm = v1/norm(v1);
jfm = v4/norm(v4);
kfm = v3/norm(v3);
Rfm = [ifm',jfm',kfm'];

orig_fm = m2;

Fm = eye(4);
Fm(2:4,1) = orig_fm';
Fm(2:4,2) = Rfm(:,1);
Fm(2:4,3) = Rfm(:,2);
Fm(2:4,4) = Rfm(:,3);

showcs_Z(Fm,0.07)

% moving marker coordinates

v1 = m6 - m7;
v2 = m8 - m7;
v3 = cross(v1,v2);
v4 = cross(v3,v1);
imm = v1/norm(v1);
jmm = v4/norm(v4);
kmm = v3/norm(v3);
Rmm = [imm',jmm',kmm'];

orig_mm = m6;

Mm = eye(4);
Mm(2:4,1) = orig_mm';
Mm(2:4,2) = Rmm(:,1);
Mm(2:4,3) = Rmm(:,2);
Mm(2:4,4) = Rmm(:,3);

showcs_Z(Mm,0.07)

% %===============================

% now use these to create pose matrices
Fa = eye(4);
Fa(2:4,1) = fa_origin';
Fa(2:4,2) = i_fa';
Fa(2:4,3) = j_fa';
Fa(2:4,4) = k_fa';

showcs_Z(Fa,0.07)

Ma = eye(4);
Ma(2:4,1) = ma_origin';
Ma(2:4,2) = i_ma';
Ma(2:4,3) = j_ma';
Ma(2:4,4) = k_ma';

showcs_Z(Ma,0.07)

% check to see that these are orthogonal right handed coordinate systems
det(Fa(2:4,2:4))
det(Ma(2:4,2:4))

w = 0.02
text(Fm(2,1),Fm(3,1)-w,Fm(4,1),'  Fm')
text(Fa(2,1),Fa(3,1)-w,Fa(4,1),'  Fa')
text(Mm(2,1),Mm(3,1)-w,Mm(4,1),'  Mm')
text(Ma(2,1),Ma(3,1)-w,Ma(4,1),'  Ma')
xlabel('x')
ylabel('y')
zlabel('z')

%%  Transformation Matrices

TFmFa = inv(Fm)*Fa

TMmMa = inv(Mm)*Ma

TFaMa = inv(Fa)*Ma

theta = -asind(TFaMa(4,2))  %ab ad

phi = atan2(TFaMa(3,2),TFaMa(2,2)) %flex ex

psi = asind(TFaMa(4,3)/cosd(theta))  %ext int rot




