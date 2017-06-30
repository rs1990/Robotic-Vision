% Asgn 1 - Question(2)
% Author: Raghavendra Sriram
% Date  : 09/15/2013
 
%% Clear command window, all previous variables and close all figures
clc;  
clear all;  
close all;  
imtool close all;
Yc = 0.3;
%% Obtain  image
[fn,pn] = uigetfile('*.jpg','Select the image file');
loc = strcat(pn,fn);
image = importdata(loc);
 
%% optical center co-ordinates   ( hint : draw parallel lines on all lines in
%%                                        image with as much accuracy as
%%                                        possible and point of intersection
%%                                        is best possible result of optical
%%                                               center )
figure(1);  
imshow(image);
disp('Select the optical center \n');
[u0,v0] = ginput(1);
fprintf('Selected Optical Center co-ordinates: [ %f , %f ] \n ',u0,v0);
%% Convert and display the co-ordinates from pixels to meters
u0 = u0 * 4.4*10^(-6);  
v0 = v0 * 4.4*10^(-6);
fprintf('Selected Optical Center co-ordinates(meters): [ %f , %f ] \n',u0,v0);
 
%% User selects the point P
disp('Select the point P which is the base of the pedestrian ');
[x_p,y_p] = ginput(1);
fprintf('P co-ordinates(pixels): [ %f , %f ] \n',x_p,y_p);
%% Convert and display the  co-ordinates from pixels to meters
x_p = x_p * 4.4*10^(-6);  
y_p = y_p * 4.4*10^(-6);
fprintf('Point P co-ordinates(meters): [ %f , %f ] \n',x_p,y_p);
%% Calculate the distance between the camera and point P
distance = sqrt((x_p-u0)^2 + (y_p-v0)^2);
%%

f_kv = 1039*4.4*10^(-6);%% Calculate & display D of point P in the image in meters
D = abs(f_kv*Yc/(y_p-v0));
fprintf('Depth of selected point is : %f meters \n',D);
 
%   The above MATLAB code calculates the distance of any point from the
%   optical center of the camera and displays the distance in "meters".
%   The image selected in obtained by the code and the user defines the
%   optical center and the desired Point on the image.
%   The Y-component, i.e. height of the camera from the ground, pixel value
%   of the focal length and the pixel size are known parameters.
