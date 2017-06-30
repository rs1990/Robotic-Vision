%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Epipolar Geometry Toolbox  (EGT)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% EGT function name:
%   f_getpoint      
%
%% EGT syntax  
%   u=f_getpoint(Name,pointnmb,fig)


function u=f_getpoint(Name,pointnmb,fig);
if isstr(Name)==1,
    I=imread(Name);
else
    I=Name;
end

Igray=rgb2gray(I);
imshow(Igray);
hold on
for i=1:pointnmb,
    title('1) Zoom then 2) Press a key and then 3) Click on feature points');
    pause
    [x(i),y(i)]=ginput(1);
    if fig~=0,
        figure(fig);
        plot(x(i),y(i),'r+')
        text(x(i)-12,y(i)-12,num2str(i),'Color','r','FontSize',12);
    end
end;    
u=[x ; y];
