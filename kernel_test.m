function K=kernel_test(x_basic,x_t,sigma)
global k_name
    if strcmp(k_name,'gaussian')
        [n_train,dump]=size(x_basic);
        [n_test,dump]=size(x_t);
        X_tt2=[x_basic;x_t];
        d_eu2=pdist(X_tt2);
        d_eu2=-d_eu2.^2/sigma;
        K_tt2=zeros(n_train+n_test,n_train+n_test);
        K_tt2=squareform(d_eu2);
        K_tt2=exp(K_tt2);
        K=K_tt2(n_train+1:n_train+n_test,1:n_train);

    else
        K=x_t*x_basic';
    end
