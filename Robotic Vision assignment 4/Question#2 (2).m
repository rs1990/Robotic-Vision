

clc; clear all; close all; imtool close all;
k_i = 4; k_f = 4; k_1 = 0.5; k_2 = 0.5; step = 0.0025;
x(1) = 0.25; y(1) = 2.75; theta(1) = 0;

x_des_i = 0; y_des_i = 3; theta_des_i = 0;
X_des_i = [x_des_i; y_des_i; theta_des_i];

x_des_f = 0; y_des_f = 3; theta_des_f = pi/2;
X_des_f = [x_des_f; y_des_f; theta_des_f];
[x_des,y_des,theta_des,~,~,~] = f_trajectoryplan(3,X_des_i,X_des_f,step);

K = 0.5*eye(3); Nx = length(x_des);
x_des_pose = zeros(1,Nx); y_des_pose = zeros(1,Nx); theta_des_pose = zeros(1,Nx);
for i = 1:1:Nx
    if i == 1
        x_des_pose(i) = 0;
        y_des_pose(i) = 0;
        theta_des_pose(i) = 0;
    else
        x_des_pose(i) = x_des(i) - x_des(i-1);
        y_des_pose(i) = y_des(i) - y_des(i-1);
        theta_des_pose(i) = theta_des(i) - theta_des(i-1);
    end
    
    X_des_pose = [x_des_pose(i);y_des_pose(i);theta_des_pose(i)];
    
    e(:,i) = [x(i) - x_des(i);
         y(i) - y_des(i);
         theta(i) - theta_des(i)];
     
    u(:,i) = (-K * e(:,i)) + X_des_pose;
    
    figure(1); 
    plot(x,y,'ro',x_des,y_des);
    axis equal;
    
    x(i+1) = x(i) + u(1,i);
    y(i+1) = y(i) + u(2,i);
    theta(i+1) = theta(i) + u(3,i);
end