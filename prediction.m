
function prediction_result=prediction(p_estimate)

global Multi_Class

n=length(p_estimate{1,2}); %sample size
score=zeros(n,Multi_Class);

for i = 1:Multi_Class-1
    for j = i+1: Multi_Class
        pij = p_estimate{i,j};
        indi = find(pij(:,1)>pij(:,2));
        score(indi,i) = score(indi,i)+1;
        indj = find(pij(:,1)<=pij(:,2));
        score(indj,j) = score(indj,j)+1;

        P_ratio{i,j} = pij(:,1)./pij(:,2);
        P_ratio{j,i} = pij(:,2)./pij(:,1);

    end
end

for i = 1:Multi_Class
    P_ratio{i,i}=ones(n,1);
    i_section = [P_ratio{1:Multi_Class,i}];
    sum_i_section = sum(i_section,2)*ones(1,Multi_Class);
    P_section{i} = i_section./sum_i_section;
end

[dump,section_picked]=max(score,[],2);

for i=1:Multi_Class
    indi=find(section_picked==i);
    p_for_section=P_section{i};
    p_estimate2(indi,:)=p_for_section(indi,:);
end
dump=dump./sum(score,2);
% wrong_error=sum(section_picked~=true_class);

prediction_result = [p_estimate2,section_picked];
