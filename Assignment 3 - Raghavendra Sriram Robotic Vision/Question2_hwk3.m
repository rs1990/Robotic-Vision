% Assignment#3 - Question(2)
% Author: Raghavendra Sriram
% Date  : 11/02/2013

clc; 
clear all; 
close all; 
imtool close all;

a = 0.0011; 
b = 0.0009; 
c = 0.0028; 
d = 0.0028;
image_calib = imread('Cal_1.jpg');
points = f_getpoint(image_calib,32,image_calib);

W_X = zeros(3,32);
W_X(1,1:8) = 0; W_X(1,9:16) = 0;
W_X(2,1:8)  = a + (0:7)*c; W_X(2,9:16) = a + (0:7)*c;
W_X(3,1:8)  = b + 2*d; W_X(3,9:16) = b;
W_X(1,17:24) = b; W_X(1,25:32) = b + 2*d;
W_X(2,17:24) = a + (0:7)*c; W_X(2,25:32) = a + (0:7)*c;
W_X(3,17:24) = 0; W_X(3,25:32) = 0;
for i = 1:1:32
    A = [zeros(1,3), -W_X(:,i)',   points(2,i)*W_X(:,i)';
         W_X(:,i)',    zeros(1,3), points(1,i)*W_X(:,i)';
         -points(2,i)*W_X(:,i)', points(1,i)*W_X(:,i)', zeros(1,3)];
    
    [U,D,V] = svd(A);
    temp = V(:,end);
    X(:,i) = temp;
end
