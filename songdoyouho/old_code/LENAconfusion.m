function [  ] = LENAconfusion( conf )
%CONFUSION Summary of this function goes here
%   Detailed explanation goes here

% LENA dataset
name{1}=['car'];
name{2}=['drink'];
name{3}=['feed'];
name{4}=['lookleft'];
name{5}=['lookright'];
name{6}=['pet'];
name{7}=['ball'];
name{8}=['shake'];
name{9}=['sniff'];
name{10}=['walk'];
nclass=13;

allresult=[];
for i=1:100
    load(sprintf('%s\\%s%d.mat', conf.resultpath, conf.resultname, i));
    allresult=[allresult; result];
end
figure;
[CM,order] = confusionmat(allresult(:,2),allresult(:,1));% confusionmat(true label,predict label)
normalcm(CM,name,nclass);


% load(sprintf('%s\\result.mat',conf.modelpath));
% [CM,order] = confusionmat(result(:,2),result(:,1));% confusionmat(true label,predict label)
% normalcm(CM,name,nclass);
end



