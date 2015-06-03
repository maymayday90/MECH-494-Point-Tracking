%% MECH 536 - Assignment 1
%Vanessa Thomson
%Student No. 70413133

close all
clear all
clc

data = xlsread('AccelerationData'); %read in data

t = data(:,1);                      %time
a = data(:,2);                      %acceleration

offset = mean([mean(a(1:1952)) mean(a(3554:4752))]);
a_offset = (a-offset)*9.81;         %zero acceleration data. Conver to m/s^2


%% Question 4


v = cumtrapz(t,a_offset);           %integrate acceleration to get velocity

figure
% hold on
plot(t,a_offset,'r')                  %plot zeroed acceleration
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')

figure
plot(t,v,'b')                         %plot velocity
xlabel('Time (s)')
ylabel('Velocity (m/s)')

v_offset = mean(v(4274:4752))       
v_zeroed = -(v-v_offset);           %known: velocity at end of trial = 0
                                    %make downward velocity positive                               
figure
plot(t,v_zeroed)                      %plot adjusted velocity
xlabel('Time')
ylabel('Velocity (m/s)')

v_max = max(v_zeroed)

d = cumtrapz(t,v_zeroed);           %integrate velocity to get distance

figure
plot(t,-d+max(d),'g')                         %plot distance
xlabel('Time (s)')
ylabel('Distance (m)')



%% Bonus Question


a_impulse = a_offset(1952:3554);
A = fft(a_impulse);
A_mag = abs(A);
fs = 1000;
x = linspace(0,1000,length(a_impulse));
figure
plot(x,A_mag)
xlabel('Frequency (Hz)')
ylabel('Magnitude (Power Spectral Density)')
figure
plot(x(1:30), A_mag(1:30))
xlabel('Frequency (Hz)')
ylabel('Magnitude (Power Spectral Density)')
