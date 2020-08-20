function [alpha1_mu,b,SV_num]=param_cal(K,y,C,pi,a)
global Result
global iters
global tau;
%--------------------------------------- Parameters Zone ---------------------------------------
s=1-a;
ClassI_ind = find(y==1);
ClassII_ind = find(y==-1);

beta=zeros(size(y));
[n,dump]=size(y);
% Add small amount of zero order regularisation to avoid problems
% when Hessian is badly conditioned.
H=(y*y').*K+eye(n)*1e-5;
H4 = [H, -H; -H, H];
f=[-ones(n,1);ones(n,1)];
Aeq=[y',-y';eye(n,n),(1/tau)*eye(n,n)];
ub = ones(n,1)*C;
ub(ClassI_ind) = ub(ClassI_ind)*(1-pi);
ub(ClassII_ind) = ub(ClassII_ind)*pi;
for i=1:iters
    %--------------------------------------- Computation Zone --------------------------------------
    if pi==0
        alpha1_mu=zeros(n,1);
        b=1;
    elseif pi==1
        alpha1_mu=zeros(n,1);
        b=-1;
    else
        %------------------------- The upper bound: C, Different from Class ------------------------
        beq=[0;ub-beta];
        LB = [-beta;zeros(n,1)];
        %-------------------------------------- Calculate the alpha1 -----------------------------------
        
        x_0 = [];
        Prob = qpAssign(sparse(H4), f, Aeq, beq, beq, LB, [], x_0, 'XinW');
        Prob = ProbCheck(Prob, 'sqopt');
        Result = sqoptTL(Prob);
        lambda_mu=Result.x_k;
        alpha1=lambda_mu(1:n,:);
        mu=lambda_mu(n+1:end,:);
        alpha1_mu=alpha1-mu;
        mu_x=K*(alpha1_mu.*y);
        %XIAOLIN H, LEI S, SUYKENS J A K. Support Vector Machine Classifier With Pinball Loss [J]. IEEE Transactions on Pattern Analysis and Machine Intelligence, 2014, 36(5): 984-97.
        idx = find( (abs(alpha1+beta )>0 ) & (abs(mu) > 0));
        if isempty(idx)
            b=0;
        else
            b=mean(y(idx)-mu_x(idx));
        end
    end
    last_b=beta;
    u=y.*(K*(alpha1_mu.*y)+b);
    
    beta(find(u<s & y==1),:)=(1-pi)*C;
    beta(find(u>=s & y==1),:)=0;
    
    beta(find(u<s & y==-1),:)=pi*C;
    beta(find(u>=s & y==-1),:)=0;
    
    if all(beta==last_b)
        disp(i)
        break
    end
end
SV_num=sum(alpha1_mu~=0);
