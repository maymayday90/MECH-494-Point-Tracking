% MECH 494 HW#2
% By: Andrew Meyer
% Due: Oct 23rd 12:00PM
close all
clear
clc
%%
%Question 1a

phi = 15; % Define angle

Rx = [cosd(phi),-sind(phi),0; %Plug angle into equation for rotation 
        sind(phi),cosd(phi),0; %about x axis (from lecture)
        0,0,1];    
display('The rotation matrix around the x-axis of 15 degrees')
Rx

%%
%Question 1b

psi = 45; % Define angle

Rz = [1,0,0;                    %Plug angle into equation for rotation 
        0,cosd(psi),-sind(psi); %about z axis (from lecture)
        0,sind(psi),cosd(psi)];    
display('The rotation matrix around the z-axis of 45 degrees')
Rz

%%
%Question 1c

theta = -30; % Define angle

Ry = [cosd(theta),0,sind(theta);    %Plug angle into equation for rotation
        0,1,0;                      %about y axis (from lecture)
        -sind(theta),0,cosd(theta)];    
display('The rotation matrix around the x-axis of -30 degrees')
Ry

%%
%Question 2a

R1 = Rx*Rz*Ry;      % Ordered combination of rotations 1-3-2
display('The rotation matrix R1')
R1

%%
%Question 2b

K2j = acosd(R1(3,2));   %For global K to local j
display('Angle between global K and local j')
K2j

%%
%Question 2c

R2 = Ry*Rz*Rx;      % Ordered combination of rotations 2-3-1
display('The rotation matrix R2')
R2

%%
%Question 2d

I2k = acosd(R1(1,3));      %For global I to local k
display('Angle between global I and local k')
I2k

%%
%Question 2e

R21 = R2'*R1;
display('The rotation matrix of R2 relative to R1')
R21

%%
%Question 3

phi = 15; % Define angles for location 1
psi = 45;
theta = -30;

R1x = [cosd(phi),-sind(phi),0;   % Define rotations, as done in 
        sind(phi),cosd(phi),0;   % question 1.
        0,0,1]; 
R1z = [1,0,0;
        0,cosd(psi),-sind(psi);
        0,sind(psi),cosd(psi)];  
R1y = [cosd(theta),0,sind(theta);
        0,1,0;
        -sind(theta),0,cosd(theta)]; 
    
R1 = R1x*R1z*R1y;  % Multiply in the correct sequence
    
T1 = eye(4);    % Start with identity matrix
T1(2:4,2:4) = R1;   %Fill in rotation values
T1


phi = 15; % Define angles for location 2
psi = 45;
theta = -30;

R2x = [cosd(phi),-sind(phi),0;  % Define rotations, as done in 
        sind(phi),cosd(phi),0;  % question 1.
        0,0,1]; 
R2z = [1,0,0;
        0,cosd(psi),-sind(psi);
        0,sind(psi),cosd(psi)];  
R2y = [cosd(theta),0,sind(theta);
        0,1,0;
        -sind(theta),0,cosd(theta)]; 
    
R2 = R2y*R2x*R2z;  % Multiply in the correct sequence

T2 = eye(4);   % Start with identity matrix
T2(2:4,2:4) = R2;  %Fill in rotation values
T2(2:4,1) = [7,-3,4]';  %Put in the tranlation vector
T2

%%
%Part a)i)
PL = [1,3,2,5]'; %Initial point
P1G = T1*PL      %Transform

%%
%Part a)ii)
P2G = T2*PL      %Transform

%%
%Part b)

inv_T1(2:4,1)=-transpose(T1(2:4,2:4))*T1(2:4,1); % Invert T1 pose
inv_T1(2:4,2:4)=transpose(T1(2:4,2:4));          % so it can be used
inv_T1(1,1:4)=[1 0 0 0];                         % to find D12

D12 = T2*inv_T1; % Calculate D12 (from lecture)
D12


%%
%Question 4

R = [0.42,-0.86,-0.31;  % Given rotation matrix
    0.89,0.45,-0.04;
    0.17,-0.25,0.95];

%Part a)
% Euler angles
display('Euler angles based on given rotation matrix')
theta = -asind(R(3,1))          
phi = atand(R(2,1)/R(1,1))
psi = atand(R(3,2)/R(3,3))

%%
%Part b)
U = [R(3,2)-R(2,3) R(1,3)-R(3,1) R(2,1)-R(1,2)]';
display('Helical Axis Unit Vector, from T12')
u=U/norm(U)

display('Rotation around the helical axis, by R')
alpha=acosd(0.5*(trace(R)-1))

% As can be seen from the angles in part a), the knee has undergone a large
% amount of flexion, with slight amounts of ad/adduction and
% internal/external rotation. 




