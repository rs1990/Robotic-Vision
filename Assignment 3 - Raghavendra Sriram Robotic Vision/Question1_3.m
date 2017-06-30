% ROBOT VISION(Assignment#3 - Question(1.3))
% Author: Raghavendra Sriram
% Date : 11/04/2013
clc; 
clear all; 
close all; 
imtool close all;
K = [100,  0, 200;
      0 ,100, 250;
      0 ,  0,   1];
C_X = [-1; -2; 3];
t = [0, 0, 0]'; 
R = eye(3);
[U_1] = Camera_3D(C_X,K,R,t,K(1,3),K(2,3));
t = [4, -1, 3]'; 
R = rotoy(-pi/2);
[U_2] = Camera_3D(C_X,K,R,t,K(1,3),K(2,3));
t = -t;
skew_t = f_skew(t);     
E = skew_t * R'
x_c = K \ [U_1; 1];
x_c_prime = K \ [U_2; 1];
Epipolar_Constraint = x_c_prime'*E*x_c