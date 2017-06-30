function Camera_3D(C_X,K,u0,v0)
%   The following MATLAB function generates the 3D projections of points
%   and generates the camera and frame of reference using the "Epipolar
%   Geometry Toolbox".
%% Create the figures and set their properties
figure(1);
xlabel('x'); ylabel('y');  zlabel('z');
title('Camera Placement & Perspective Projection');
axis equal;  axis([-1 3 -1 3 -1 1]);
view(48,42);
%% Figure on the Image Plane
figure(2);
title('Image Plane');
axis([0 u0*2 0 v0*2]);
grid on; hold on;
%% Placement of Camera and plot of points
figure(1);  hold on;
W_X = rotox(-pi/2)*C_X;
plot3(W_X(1), W_X(2), W_X(3), 'r+');
%% Left Camera position parameters
R = eye(3);
t = [0,0,0]';
H = f_Rt2H(R,t);
scale = 1/2;
f_3Dframe(H,'b',scale,'_{c}');
f_3Dcamera(H,'b',scale);
%% Perspective Projection for Left Camera
U_L = f_perspproj(W_X,H,K,2);
figure(2);
hold on;
plot(U_L(1), U_L(2), 'rO');