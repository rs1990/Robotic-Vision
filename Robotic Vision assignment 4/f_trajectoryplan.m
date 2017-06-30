function [x,y,theta, xp, yp, thetap] = f_trajectoryplan(k, Xi, Xf, step)
%% see pg. 492 - "Robotics" by Siciliano et al.
% Compute the parameters alpha_x,y and beta_x,y of the parameterized trajectory
  alpha_x = k*cos(Xf(3))-3*Xf(1);
  beta_x = k*cos(Xi(3))+3*Xi(1);
  alpha_y = k*sin(Xf(3))-3*Xf(2);
  beta_y = k*sin(Xi(3))+3*Xi(2);
  
% Generate Trajectory w/ boundary conditions
  i=1;
  for s=0:step:1,
     x(i)=s^3*Xf(1)-(s-1)^3*Xi(1)+alpha_x*s^2*(s-1)+beta_x*s*(s-1)^2;
     y(i)=s^3*Xf(2)-(s-1)^3*Xi(2)+alpha_y*s^2*(s-1)+beta_y*s*(s-1)^2;
     xp(i) = 3*s^2*Xf(1)-3*(s-1)^2*Xi(1)+alpha_x*(2*s*(s-1)+s^2) + beta_x*((s-1)^2+2*s*(s-1));
     yp(i) = 3*s^2*Xf(2)-3*(s-1)^2*Xi(2)+alpha_y*(2*s*(s-1)+s^2) + beta_y*((s-1)^2+2*s*(s-1));     
     thetap(i) = xp(i)^2/(xp(i)^2+yp(i)^2);
     theta(i) = atan2(yp(i), xp(i));
     i=i+1;
  end  