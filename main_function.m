function [prediction_result,sv_result]=main_function(train_simp,tune_simp,x_test)
global Multi_Class;
global a;

C_index=-3:5;
EGKL_lst=zeros(1,length(C_index));
for C_idx=C_index
    EGKL_lst(1,C_idx-min(C_index)+1)=EGKL_cal(train_simp,tune_simp,2^C_idx,a);
end

[mxv,idx] = max(EGKL_lst(:));
[a_i,C_i]= ind2sub(size(EGKL_lst),idx);

best_C=2^(C_i-min(C_index)+1);

%----------------- Test part using the whole train data --------------%
sv_result=0;
for i=1:Multi_Class-1
    for j=i+1:Multi_Class
        %--------------- get K_train ---------------
        train_temp = train_simp{i,j};
        y_train=train_temp(:,1);
        x_train=train_temp(:,2:end);
        [K_train,sigma]=kernel_train(x_train);
        %--------------- get K_test ---------------
        K_test=kernel_test(x_train,x_test,sigma);
        %---------------
        [pi,pj,svs_percent] = get_p_simp(K_test,K_train,y_train,best_C,a);
        sv_result=svs_percent/length(y_train)+sv_result;
        prob_EGKL{i,j} = [pi,pj];
    end
end

%--------------------------------- output part ---------------------------------------------------
prediction_result=prediction(prob_EGKL);

