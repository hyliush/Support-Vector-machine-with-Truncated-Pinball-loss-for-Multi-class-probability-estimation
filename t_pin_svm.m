clear all;clc
global k_name
global a;
global tau;
k_name='gaussian';
%k_name='linear';
global iters;
iters=50;
a=1.5;
tau=0.5;
%------------------------------------- load data set ----------------------------------------------
%------------------ train data information ----------------
train_data_original=load('train.txt');    % load the test data;
test_data_original=load('test.txt');    % load the test data;
global Multi_Class;
Multi_Class=length(unique(train_data_original(:,1))); % get the number of classes
[sample_size,column_size]=size(train_data_original);
train_data_all=train_data_original(:,1:column_size-Multi_Class);
test_data=test_data_original(:,1:column_size-Multi_Class);

%------------------ test data information -----------------
x_test=test_data(:,2:end);
[n_test,p]=size(x_test);
%--------------------- Tune part, using the leave one out method ----------------------------------%
%-------------------- Set the train data and tune data --------------------
% a half of train_data_all for train_data,the other half of train_data_all for tune_data
% randomly choose half of the train data as the train set and let the rest as the tune set
temp=(randperm(sample_size));
tune_sub=temp(1:floor(sample_size/2));
tune_sub=sort(tune_sub);    
% train_data
train_data = train_data_all;
train_data(tune_sub,:)=[]; % leave one out from the train data
train_simp = Mul2Sim (train_data , Multi_Class );

% tune_data
tune_data = train_data_all(tune_sub,:); % let the left be the tune data
tune_simp = Mul2Sim( tune_data, Multi_Class);
[prediction_result,sv_result]=main_function(train_simp,tune_simp,x_test);
% index calculate
acc=mean(prediction_result(:,end)==test_data(:,1));
error=prediction_result(:,1:Multi_Class)-test_data_original(:,column_size-Multi_Class+1:column_size);
l1=sum(sum(abs(error)))/n_test;
l2=sum(sum(error.^2))/n_test;
sv=sv_result/(Multi_Class*(Multi_Class-1));




