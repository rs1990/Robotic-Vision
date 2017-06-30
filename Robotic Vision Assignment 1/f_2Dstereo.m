function f_2Dstereo(xL,xR,f,d,ku)
% This MATLAB function calculates the depth of the 3D point.
% xL = Left camera horizontal Projection
% xR = Right camera horizontal Projection
% f = Focal length in cm
% d = baseline distance
% Z = Depth (div by 100 to convert to mts

Z = d*f*ku/(xL-xR);
fprintf('Depth = %f m',Z/100);
end