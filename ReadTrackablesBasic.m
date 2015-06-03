function markerdata=ReadTrackablesBasic(varargin)
% function data = ReadTrackables(filename)
% function data = ReadTrackables(filename,fillin)
% function data = ReadTrackables(filename,fillin,numheadrow)
%
% This is a function designed to read the output format from NaturalPoint's
% "TrackingTools" software, used to generate 3D marker trajectories from
% the OptiTrack camera system. 
%
% The function scans the file to determine the number of trackables, frames
% and markers, then reads ONLY the raw marker trajectories (not the
% estimated rigid body locations) and saves this data to file.  A new
% header is created to identify each trackable and marker individually.
%
% An option is included to use cubic spline interpolation for the data. A
% maximum gap of 6 missing frames is allowed - otherwise, the gap is not
% filled.  Furthermore, at least 3 consecutive data points must be provided
% or the data will be discarded and not filled.
%
% INPUTS:
%       filename = some .csv filename
%       fillin = flag to interpolate or not (1 = yes, 0 = no (default))
%       numheadrow = 43 (default) 
%                  = number of rows before first "trackable" definition
%                    in header (this comes after the "info" labels)
% OUTPUTS:
%       a .csv file with the same name as the supplied file, but adding a
%       tag "_processed.csv". This file only contains raw (point cloud)
%       marker trajectories, and are sorted by trackable. 
%
% **NOTE: this file has not been tested when some point cloud markers are
% NOT attached to trackables. For best results, each marker should be part
% of a rigid "trackable" object.
%
% Scott Brandon, 1 Nov 2011



switch nargin
    case 1
        filename = varargin{1};
        nheadrow = 43;
        fillin = 0;
    case 2
        filename = varargin{1};
        fillin = varargin{2};
        nheadrow = 43;
    case 3
        filename = varargin{1};
        fillin = varargin{2};
        nheadrow = varargin{3};        
end

%% Define Test Variables
% clear all
% close all
% filename = 'squat track_2011.csv';
% filename = 'Trial00025.csv';
 nheadrow = 43;
% fillin = 0;


%% Step in...
% fid = fopen(filename);
%     indat = textscan(fid, '%s', 'delimiter',',','TreatAsEmpty','-1.#IND0000000000000000');
% fclose(fid);

fid = fopen(filename);
    indat = textscan(fid, '%s', 'delimiter',',');
fclose(fid);
%%
% %% Make sure this is the correct file type:
% if ~strcmp(indat{1}(2),'NaturalPoint Trackable Export Data') %if the type of data is NOT trackable export data
%     errmsg = ['Sorry, this does not appear to be an OptiTrack Trackables ',...
%                 'Export File. Please select a new file, and ensure that ',...
%                 'trackables were used during data collection.  The file must ',...
%                 'say "NaturalPoint Trackable Export Data" in first row of ',...
%                 'the header.'];
%     errordlg(errmsg,'Improper Data File')
%     return
% end
    
% % _________________________________________________________________________
%       If it made it this far, we have the right file format.  
% _________________________________________________________________________

%% Find number of frames
a = 0;
i=0;
while a == 0
    i=i+1;
    a = strcmp(indat{1}(i),'framecount'); 
end
nframe = str2num(indat{1}{i+1});

%% Find number of trackables
b = 0;
% i=0; %keep i continuous, as these items are sequential.
while b == 0
    i=i+1;
    b = strcmp(indat{1}(i),'trackablecount');
end
ntrack = str2num(indat{1}{i+1});

%% Read in Trackable Names
c = 0;
% i=0; %keep i continuous, as these items are sequential.
while c < ntrack
    i=i+1;
    if strcmp(indat{1}(i),'trackable')
        c=c+1;
        tname{c}=indat{1}{i+1};
        nmark(c)=str2num(indat{1}{i+3});
    end
end

%% Find index of first frame of data
d = 0;
% i=0; %keep i continuous, as these items are sequential.
while d == 0
    i=i+1;
    d = strcmp(indat{1}(i),'frame');
end
datastart = 46; %first frame

%% Read in data using dlmread
%Read raw marker coordinates
C1 = 4; %for the previous version of tracking tools (2.0.1) C1 = 5
    
%start reading actual data
    usedat = dlmread(filename,',',nheadrow+ntrack,4); 
    %usedat(1:ntrack+1:end,:)=[]; %eliminate last-squares tracked data - we want raw marker data

%     %Sort Data into a separate cell array for each trackable, since they could
%     %all have different numbers of markers, and therefore columns.
%     for tn = 1:ntrack
%         trow = [];
%         trow = find(usedat(:,1)==tn); %find the rows corresponding to only a single trackable
%         ncol = nmark(tn)*3; %3 columns for each marker for this trackable
%         trackdat{tn}=usedat(trow,[ncol+C1:ncol+ncol+C1-1]);
%     end

%capture raw marker data
markerdat=[];
for i=1:size(usedat,1)
    if isequal(usedat(i,1),1)==0 && isequal(usedat(i,1),2)==0
        markerdat=[markerdat;usedat(i,:)];
    end
end

%now separate into marker trajectories
for j=1:markerdat(1,1)
    k=1;
    eval(strcat('markerdata{',num2str(j),'}=markerdat(:,',num2str(k+1),':',num2str(k+3),');'))
    k=k+3;
end
