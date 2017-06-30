%%
%% CSE 4392-5369 University of Texas at Arlington  
%% Dr. Gian Luca Mariottini
%%

function [K_hat, C_R_W_hat] = f_P2KR(C_P_W)

%% Camera calibration and rotation estimation
KR = C_P_W(:,[1:3]); %just in case
[W_R_C_hat,invK_hat] = qr(inv(KR));
C_R_W_hat = f_roundn( W_R_C_hat', -8); 
K_hat = inv(invK_hat);
K_hat = f_roundn(K_hat/K_hat(3,3), -8);
% Scan columns of K to adjust sign of R
for i=1:3,
    signK=find(K_hat(i,i)<0);
    if ~isempty(signK),
        K_hat(:,i)=-K_hat(:,i);
        C_R_W_hat(i,:)=-C_R_W_hat(i,:);
    end
    clear signK
end
% Final check on det(C_R_W_hat)
epsilon = 1e-6;
if det(C_R_W_hat)  < 0,
    C_R_W_hat=-C_R_W_hat;
end