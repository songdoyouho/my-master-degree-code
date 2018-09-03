function [  ] = confusion( conf )
%CONFUSION Summary of this function goes here
%   Detailed explanation goes here

% DOG dataset
name{1}=['shake'];
name{2}=['hug'];
name{3}=['pet'];
name{4}=['wave'];
name{5}=['point'];
name{6}=['pounch'];
name{7}=['throw'];
nclass=7;

allresult=[];
for i=1:100
    load(sprintf('%s\\%s%d.mat', conf.resultpath, conf.resultname, i));
    allresult=[allresult; result];
end
figure;
[CM,order] = confusionmat(allresult(:,2),allresult(:,1)); % confusionmat(true label,predict label)
all_class_acc=[];
for aaa=1:nclass
    bbb=1:nclass;
    TP = CM(aaa,aaa);
    index=bbb==aaa;
    index=not(index);
    FP = CM(index,aaa);
    FN = CM(aaa,index);
    FN = sum(FN);
    FP = sum(FP);
    class_acc = 2*TP/(2*TP+FP+FN);
    all_class_acc=[all_class_acc class_acc];
end
for aaa=1:nclass
    fprintf('%s : %f\n',name{1,aaa},all_class_acc(1,aaa)*100);    
end
normalcm(CM,name,nclass);


% load(sprintf('%s\\result.mat',conf.modelpath));
% [CM,order] = confusionmat(result(:,2),result(:,1));% confusionmat(true label,predict label)
% normalcm(CM,name,nclass);
end



