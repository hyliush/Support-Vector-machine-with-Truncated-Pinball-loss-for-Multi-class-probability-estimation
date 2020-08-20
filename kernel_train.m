function [K,sigma]=kernel_train(x)
global k_name
    if strcmp(k_name,'gaussian')
        y=pdist(x,'euclidean');
        sigma=median(y);
        sigma=2.0*sigma^2;
        temp=-(y.^2)/sigma;
        K=exp(squareform(temp));
    else
        K=x*x';
        sigma=0;
    end