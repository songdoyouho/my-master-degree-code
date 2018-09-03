function [ cccount ] = matchresult( conf )
%MATCHRESULT Summary of this function goes here
%   Detailed explanation goes here
allresult=[];
cccount=[];
for i=1:100
    load(sprintf('%s\\%s%d.mat', conf.resultpath, conf.resultname, i));
    fprintf('%s\\%s%d.mat\n', conf.resultpath, conf.resultname, i);
    correct_num = 0;
    for j=1:size(result,1)
        if result(j,1)==result(j,2) % correct
            allresult=[allresult; 1];
        else % wrong
            allresult=[allresult; 0];
%             fprintf('predict label : %d truth label : %d video index : %d\n',result(j,1),result(j,2),result(j,3));
            label = 0;
            if isempty(cccount)
                cccount = [cccount result(j,1) result(j,2) result(j,3) 1];
                label = 1;
            else
                for k = 1:size(cccount,1)
                    if result(j,2) == cccount(k,2) && result(j,3) == cccount(k,3)
                        cccount(k,4) = cccount(k,4) + 1;
                        label = 1;
                    end
                end
                if label == 0
                    cccount = [cccount; result(j,1) result(j,2) result(j,3) 1];
                end
            end
        end
    end
end

e=find(allresult==1);
% correct test video number
length(e)
% all test video number
size(allresult,1)
% final accuracy
final_acc=length(e)/size(allresult,1)
end

