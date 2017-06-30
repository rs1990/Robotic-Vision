% ROBOT VISION(Assignment#3 - Question(3))
% Author: Raghavendra Sriram
% Date  : 11/05/2013

clc; 
clear all; 
close all; 
imtool close all;

f_ku = 200; 
f_kv = 200;
u_0 = 300; v_0 = 300;
K = [f_ku  0   u_0;
      0   f_kv v_0;
      0    0    1 ];
correspondences = load('Correspondences.mat');
U_L = correspondences.U_L; 
U_R = correspondences.U_R;

R_L = eye(3); 
t_L = [0; 0; 0];

Ext_P_L = [R_L, t_L];

R_R = rotoy(pi/4); t_R = [-1; -0.25; 0.5];

Ext_P_R = [R_R, t_R];

P_L = K * Ext_P_L; 
P_R = K * Ext_P_R;

for i = 1:1:9
    A = [U_L(1,i) .* P_L(3,:) - P_L(1,:);
         U_L(2,i) .* P_L(3,:) - P_L(2,:);
         U_R(1,i) .* P_R(3,:) - P_R(1,:);
         U_R(2,i) .* P_R(3,:) - P_R(2,:)];
     
    [U,D,V] = svd(A);
    
    temp = V(:,4);
    temp = temp ./ repmat(temp(4,1),4,1);
    W_X(:,i) = temp;
end

figure(1); 
view(42,48);
plot3(W_X(1,:),W_X(2,:),W_X(3,:),'bo');
xlabel('X'); 
ylabel('Y'); 
zlabel('Z');
title('Points on 3D Plane');

U_L = [U_L;ones(1,9)]; 
U_R = [U_R;ones(1,9)];
u_l = P_L * W_X; u_l = u_l ./ repmat(u_l(3,:),3,1);
u_r = P_R * W_X; u_r = u_r ./ repmat(u_r(3,:),3,1);
E_L = (U_L - u_l) .* (U_L - u_l); 
E_R = (U_R - u_r) .* (U_R - u_r);
E = E_L + E_R;
MSE = sqrt(sum(sum(E)))/9;
fprintf('Projection Error = %f\n',MSE);