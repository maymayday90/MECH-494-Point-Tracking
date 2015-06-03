%%
%Abduction_______________________________________
close all
clear all
clc

a = dlmread('AbductionStatic.csv');
DataA = a(:,5:36);
statictesta=DataA(50,:);

%Body1
a1=statictesta(:,1:3);
a3=statictesta(:,5:7);
a2=statictesta(:,9:11);

%Body2
a4=statictesta(:,25:27);
a6=statictesta(:,17:19);
a5=statictesta(:,21:23);

%Axis
a7=statictesta(:,13:15);
a8=statictesta(:,29:31);

hold all
% grid on 
axis equal

%Plotting Individual Points
plot3(a1(1),a1(2),a1(3),'.','Color', 'b');
plot3(a2(1),a2(2),a2(3),'.','Color', 'b');
plot3(a3(1),a3(2),a3(3),'.','Color', 'b');
plot3(a4(1),a4(2),a4(3),'.','Color', 'r');
plot3(a5(1),a5(2),a5(3),'.','Color', 'r');
plot3(a6(1),a6(2),a6(3),'.','Color', 'r');
plot3(a7(1),a7(2),a7(3),'.','Color', 'k');
plot3(a8(1),a8(2),a8(3),'.','Color', 'k');
%_______________________________________________________


%%
%Flexion________________________________________________

b = dlmread('FlexionStatic.csv');
DataB = b(:,5:36);
statictestb=DataB(50,:);

%Body1
f1=statictestb(:,1:3);
f2=statictestb(:,5:7);
f3=statictestb(:,21:23);


%Body2
f4=statictestb(:,13:15);
f5=statictestb(:,17:19);
f6=statictestb(:,9:11);

%Axis
f7=statictestb(:,25:27);
f8=statictestb(:,29:31);


%Plotting Individual Points
%plot3(f1(1),f1(2),f1(3),'.','Color', 'b');
%plot3(f2(1),f2(2),f2(3),'.','Color', 'b');
%plot3(f3(1),f3(2),f3(3),'.','Color', 'b');
%plot3(f4(1),f4(2),f4(3),'.','Color', 'r');
%plot3(f5(1),f5(2),f5(3),'.','Color', 'r');
%plot3(f6(1),f6(2),f6(3),'.','Color', 'r');
plot3(f7(1),f7(2),f7(3),'.','Color', 'm');
plot3(f8(1),f8(2),f8(3),'.','Color', 'm');
%plot3(q1(1),q1(2),q1(3),'.','Color', 'k');
%plot3(q2(1),q2(2),q2(3),'.','Color', 'k');
%_______________________________________________________

%Plotting Text for the points___________________________

text(a1(1),a1(2),a1(3), 'm1')
text(a2(1),a2(2),a2(3), 'm2')
text(a3(1),a3(2),a3(3), 'm3')
text(a4(1),a4(2),a4(3), 'm4')
text(a5(1),a5(2),a5(3), 'm5')
text(a6(1),a6(2),a6(3), 'm6')
text(a7(1),a7(2),a7(3), 'm7')
text(a8(1),a8(2),a8(3), 'm8')
text(f7(1),f7(2),f7(3), 'm9')
text(f8(1),f8(2),f8(3), 'm10')
%______________________________________________________

%Creating Coordinate System____________________________

%Fm
uFm = a3 - a2;
uFm = (uFm)/norm(uFm);
wFm = cross(uFm,a1-a2);
wFm = wFm/norm(wFm);
vFm = cross(wFm,uFm);

%Mm
uMm = a6 - a5;
uMm = (uMm)/norm(uMm);
wMm = cross(uMm,a4-a5);
wMm = wMm/norm(wMm);
vMm = cross(wMm,uMm);

%Knee
uKnee = a8 - a7;
uKnee = (uKnee)/norm(uKnee);
vKnee = cross(uKnee,f8 - f7);
vKnee = vKnee/norm(vKnee);
wKnee = cross(-vKnee,uKnee); %made this negative

%%
%Plot Fm
plotrhcs(a2,uFm/10,vFm/10,wFm/10)
%Plot Fa
plotrhcs(f7,uKnee/10,vKnee/10,wKnee/10)
plotrhcs(a2,uKnee/5,vKnee/5,wKnee/5) %added these 2 lines
plotrhcs(a5,uKnee/5,vKnee/5,wKnee/5) %
%Plot Mm
plotrhcs(a5,uMm/10,vMm/10,wMm/10)
%Plot Ma
%plotrhcs(a7,uMa/10,vMa/10,wMa/10)
%______________________________________________________

% Relative to Global Rotation Matrices_________________

% Global to Fm
RG2Fm = [uFm',vFm',wFm'];
TG2Fm = [1,0,0,0;a2',RG2Fm];
% Global to Mm
RG2Mm = [uMm',vMm',wMm'];
TG2Mm = [1,0,0,0;a5',RG2Mm];
% Global to Knee
RG2Knee = [uKnee',vKnee',wKnee'];
TG2Knee = [1,0,0,0;f7',RG2Knee];

% Inversion of knee pose for multiplication
inv_TG2Knee = invertpose(TG2Knee);

% Knee to Fm pose
TKnee2Fm = inv_TG2Knee*TG2Fm;

% Knee to Mm pose
TKnee2Mm = inv_TG2Knee*TG2Mm;

%_____________________________________________________
% For flexion motion

dyndata = dlmread('Abduction.csv');
dyndata = dyndata(:,5:36);

for i = 1:2%length(dyndata)
close all
hold all
axis equal
%Body1
a1=dyndata(i,1:3);
a2=dyndata(i,5:7);
a3=dyndata(i,9:11);

%Body2
a4=dyndata(i,29:31);
a5=dyndata(i,17:19);
a6=dyndata(i,21:23);

plot3(a1(1),a1(2),a1(3),'.','Color', 'b');
plot3(a2(1),a2(2),a2(3),'.','Color', 'm');
plot3(a3(1),a3(2),a3(3),'.','Color', 'b');
plot3(a4(1),a4(2),a4(3),'.','Color', 'r');
plot3(a5(1),a5(2),a5(3),'.','Color', 'r');
plot3(a6(1),a6(2),a6(3),'.','Color', 'r');

%Fm
uFm = a3 - a2;
uFm = (uFm)/norm(uFm);
wFm = cross(uFm,a1-a2);
wFm = wFm/norm(wFm);
vFm = cross(wFm,uFm);
uFm(2:4) = uFm(1:3);
uFm(1,1) = 1;
vFm(2:4) = vFm(1:3);
vFm(1,1) = 1;
wFm(2:4) = wFm(1:3);
wFm(1,1) = 1;

%Mm
uMm = a6 - a5;
uMm = (uMm)/norm(uMm);
wMm = cross(uMm,a4-a5);
wMm = wMm/norm(wMm);
vMm = cross(wMm,uMm);
uMm(2:4) = uMm(1:3);
uMm(1,1) = 1;
vMm(2:4) = vMm(1:3);
vMm(1,1) = 1;
wMm(2:4) = wMm(1:3);
wMm(1,1) = 1;

a2(2:4) = a2(1:3);
a2(1,1) = 1;
ctrFa = TKnee2Fm*a2';
uFa = TKnee2Fm*uFm';
vFa = TKnee2Fm*vFm';
wFa = TKnee2Fm*wFm';

a5(2:4) = a5(1:3);
a5(1,1) = 1;
ctrMa = TKnee2Mm*a5';
uMa = TKnee2Mm*uMm';
vMa = TKnee2Mm*vMm';
wMa = TKnee2Mm*wMm';

plotrhcs(ctrFa,uFa,vFa,wFa)
plotrhcs(ctrMa,uMa,vMa,wMa)

% % Fm to Mm __________
% % Rotation
% RMm2Fm = RG2Mm'*RG2Fm;%should this be flipped? aka Fm'*Mm?
% % Translation
% LMm2Fm = a5 - a2;
% % Euler angles
% thetaMmFm = -asind(RMm2Fm(3,1))
% phiMmFm = atand(RMm2Fm(2,1)/RMm2Fm(1,1))
% psiMmFm = atand(RMm2Fm(3,2)/RMm2Fm(3,3))

end




