function EGKL_sum=EGKL_cal(train_simp,tune_simp,C,a)
global Multi_Class
EGKL_sum=0;
for i=1:Multi_Class-1
    for j=i+1:Multi_Class
        train_temp = train_simp{i,j};
        tune_temp = tune_simp{i,j};
        %----------------- Tunning part to get the best C ----------------------------------
        %--------------- get K_train ---------------
        y_train=train_temp(:,1);
        x_train=train_temp;
        x_train(:,1)=[];
        [K_train,sigma]=kernel_train(x_train);
        %--------------- get K_tune ---------------
        y_tune=tune_temp(:,1);
        x_tune=tune_temp;
        x_tune(:,1)=[];
        K_tune=kernel_test(x_train,x_tune,sigma);
        
        % calculate probability under binary task
        [p_tune_estimate,dump,sv_num]=get_p_simp(K_tune,K_train,y_train,C,a);
        % tuning standard: acc or egkl
        % accuracy
        result=ones(size(y_tune));
        result(p_tune_estimate>0.5)=-1;
        EGKL=mean(result==y_tune);
        EGKL_sum=EGKL_sum+EGKL;
        % egkl
        %EGKL=sum( ((y_tune+1)/2).*log(p_tune_estimate) + ((1-y_tune)/2).*log(1-p_tune_estimate), 1);
        %EGKL_sum=EGKL_sum+EGKL;
    end
end