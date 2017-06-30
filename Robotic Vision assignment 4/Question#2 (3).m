% ROBOT VISION(Assignment#4 - Question#2)
% Author : Raghavendra Sriram
% Date   : 11/26/2013

% I have noticed the code sometimes throws up an error saying that an un
% supported character is present. However i am not able to identify it. But
% when you run individual cells of the code, it seems to work fine. 
%I would like you to kindly take not of the same.
%Thank you.

clc; 
clear all; 
close all; 
imtool close all;

ki = 4; 
kf = 4; 
k1 = 0.5; 
k2 = 0.5; 
step = 0.0025;
x(1) = 0.25; 
y(1) = 2.75; 
angle(1) = 0;

xf = 0; 
xf = 3; 
anglef = 0;
xf_i = [xf; 
        xf; 
        anglef];

xf_f = 0; 
yf_f = 3; 
anglef_f = pi/2;
xf_f = [xf_f; 
        yf_f;
        anglef_f];

[xf,yf,anglef,~,~,~] = f_trajectoryplan(3,xf_i,xf_f,step);
%% Calculate the path of the robot and display the desired and actual trajectories
K = 0.5*eye(3); 
Nx = length(xf);
xf_pose = zeros(1,Nx); 
yf_pose = zeros(1,Nx); 
anglef_pose = zeros(1,Nx);
for i = 1:1:Nx
    if i == 1
        xf_pose(i) = 0;
        yf_pose(i) = 0;
        anglef_pose(i) = 0;
    else
        xf_pose(i) = xf(i) - xf(i-1);
        yf_pose(i) = yf(i) - yf(i-1);
        anglef_pose(i) = anglef(i) - anglef(i-1);
    end
    Xf_pose = [xf_pose(i);yf_pose(i);anglef_pose(i)];
    e(:,i) = [x(i) - xf(i);
    y(i) - yf(i);
    angle(i) - anglef(i)];
    u(:,i) = (-K * e(:,i)) + Xf_pose;
    
    figure(1); 
    plot(x,y,'sq',xf,yf);
    title('Robot path trajectory');
    grid on
    
    x(i+1) = x(i) + u(1,i);
    y(i+1) = y(i) + u(2,i);
    angle(i+1) = angle(i) + u(3,i);
end