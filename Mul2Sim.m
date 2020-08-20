function [data_simp]=Mul2Sim(data,Multi_Class)
% Divided into a number of two classification tasks
lable=data(:,1);
for i=1:Multi_Class-1
    indi = find(lable == i);
    y1 = ones(length(indi),1);
    tempi = [y1 data(indi,2:end)];
    
    for j=i+1:Multi_Class
        indj = find(lable==j);
        y2 = ones(length(indj),1)*(-1);
        tempj = [y2 data(indj,2:end)];
        data_simp{i,j} = [tempi;tempj];
    end
end
    