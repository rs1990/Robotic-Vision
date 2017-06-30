% Asgn 1 - Question(1)
% Author:Raghavendra Sriram
% Date  : 09/16/2013


clc;  
clear all;  % Clear and close command window, variables, figures
close all;  
imtool close all;

f = 1; %Focal length = 10mm = 1 cm
D = 9; %Depth = 9cm
Ku = 1;  %intrinsic parameter
Kv = Ku; %Initialize the parameters (cm)
U0 = 0;  
V0 = U0;

K = [f*Ku 0 U0;0 f*Kv V0;0 0 1];% defining the intrinsic camera calibration matrix
% 
% xL = input('Projection - left camera(xL) in cm:');%user input for projection from left pinhole camera
% xR = input('Projection - right camera(xR) in cm:');%user input for projection from left pinhole camera
% f_2Dstereo(xL,xR,f,D,Ku); %Calling function to calculate depth of plot
% 
% Xc = 9;  
% Yc = 0;  
% Zc = 100;
% C_X = [Xc;Yc;Zc]; %defining the location of image
% 
% figure(1);
% xlabel('x'); 
% ylabel('y');  
% zlabel('z');
% title('Projection of image');
% axis equal;  
% axis([-1 10 -1 120 -1 10]);
% view(48,42);
% 
% figure(2);
% title('Image Plane');
% grid on; hold on;
% 
% % Placement of Camera and plot of points
% figure(1);  
% hold on;
% w_x = rotox(-pi/2)*C_X; 
% plot3(w_x(1), w_x(2), w_x(3), 'r+');
% 
% %% Left Camera position parameters
% R = eye(3);
% t = [0,0,0]';
% H = f_Rt2H(R,t);
% scale = 1/2;
% f_3Dframe(H,'b',scale*3,'_');
% f_3Dcamera(H,'b',scale/2);
% %% Perspective Projection for Left Camera
% u_l = f_perspproj(w_x,H,K,2);
% figure(2);
% hold on;
% plot(u_l(1), u_l(2), 'O');
% %% Right Camera position parameters
% figure(1);
% hold on;
% t = [Xc,0,0]';
% H = f_Rt2H(R,t);
% scale = 1/2;
% f_3Dframe(H,'b',scale*3,'_');
% f_3Dcamera(H,'b',scale/2);
% %% Perspective Projection for Right Camera
% U_R = f_perspproj(w_x,H,K,2);
% figure(2);
% hold on;
% plot(U_R(1), U_R(2), 'rO');
% 
% % The following MATLAB code simulates a stereo pair camera using functions from the Epipolar Geometry Toolbox provided.
% % It displays the pixel projection on the image planes for the left & right cameras. The function f_2Dstereo which is 
% % present in the toolbox  is called by the main program to calculate the
% % depth of the 3D point.