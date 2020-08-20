
function [p1,p2,svs_percent]=get_p_simp(K,K_train,y_train,C,a)
% m candidates for pi
[n,dump]=size(K);
m=20;
%sv_num_lst=zeros(1,21);
y_estimate=zeros(n,m+1);
svs_sum=0;
for j=1:m+1
    pi=(j-1)/m;
    [alpha1_mu,b,SV_num]=param_cal(K_train,y_train,C,pi,a);
    y_estimate(:,j)=sign(K*(alpha1_mu.*y_train)+b);
    svs_sum=SV_num+svs_sum;
end
svs_percent=svs_sum/21;
m=m-1;
%---------------------------- find the first jump ----------------------------------------------
[dump,first_jump]=min(y_estimate,[],2);
first_jump=first_jump-1;    
%--------------------------- find the last jump ------------------------------------------------
[dump, last_jump]=max(fliplr(y_estimate), [], 2);
last_jump=m+1-last_jump;

p1=(first_jump+last_jump)/(2*m);
p2=1-p1;

