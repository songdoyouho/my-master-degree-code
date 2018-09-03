function [  ] = multisvm( conf,flag )
%MULTISVM Summary of this function goes here
% svm training and testing
tridx=conf.tridx;
teidx=conf.teidx;
actnum=conf.actnum;
nnn=conf.nnn;

loadencoding=conf.loadencoding;
loadselect=conf.loadselect;
loadW=conf.loadW;
loadseg2W=conf.loadseg2W;
loadseg03W=conf.loadseg03W;
% add libsvm path
addpath(conf.svmpath);

%%
if(strcmp(flag, 'train'))
    % read fisher vector
    feature=[];
    for j=1:actnum
        % take index
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            % load features
            casencoding=[];
            casselectencoding=[];
            casWencoding=[];
            casseg2Wencoding=[];
            casseg03Wencoding=[];
            if loadencoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadselect ==1
                load(sprintf('%s\\select_encoding\\select_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\select_encoding\\select_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casselectencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadW == 1
                load(sprintf('%s\\W2\\W2%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\W2\\W2%d_%d.mat\n', conf.tmppath, vi, j);
                casWencoding=W2/norm(W2);
            end
            if loadseg2W == 1
                load(sprintf('%s\\seg0.2W2%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\seg0.2W2%d_%d.mat\n', conf.modelpath, vi, j);
                casseg2Wencoding=W2/norm(W2);
            end
            if loadseg03W == 1
                load(sprintf('%s\\seg0.03W2%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\seg0.03W2%d_%d.mat\n', conf.modelpath, vi, j);
                casseg03Wencoding=W2/norm(W2);
            end            
            cas=[casencoding casselectencoding casWencoding casseg2Wencoding casseg03Wencoding];

            feature=[feature; cas];
        end
    end
    
    label=[];
    for j=1:actnum
        % take index
        for i=1:numel(tridx{j,1})
            label=[label; j];
        end
    end
    % train svm model
    model = svmtrain(label, feature, '-c 100 -t 0');
    save(sprintf('%s\\svmmodel.mat',conf.modelpath),'model');
end

%%
if(strcmp(flag, 'test'))
    % read fisher vector
    result=[];
    allfeature=[];
    truelabel=[];
    for j=1:actnum
        % take index
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            % load features
            casencoding=[];
            casselectencoding=[];
            casWencoding=[];
            casseg2Wencoding=[];
            casseg03Wencoding=[];
            if loadencoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadselect ==1
                load(sprintf('%s\\select_encoding\\select_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\select_encoding\\select_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casselectencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadW == 1
                load(sprintf('%s\\W2%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\W2%d_%d.mat\n', conf.modelpath, vi, j);
                casWencoding=W2/norm(W2);
            end
            if loadseg2W == 1
                load(sprintf('%s\\seg0.2W2%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\seg0.2W2%d_%d.mat\n', conf.modelpath, vi, j);
                casseg2Wencoding=W2/norm(W2);
            end
            if loadseg03W == 1
                load(sprintf('%s\\seg0.03W2%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\seg0.03W2%d_%d.mat\n', conf.modelpath, vi, j);
                casseg03Wencoding=W2/norm(W2);
            end            
            feature=[casencoding casselectencoding casWencoding casseg2Wencoding casseg03Wencoding];
            allfeature=[allfeature; feature];
            truelabel=[truelabel; j];
        end
    end
    
    % test svm 
    label=zeros(size(allfeature,1),1);
    load(sprintf('%s\\svmmodel.mat',conf.modelpath));
    [predict_label, accuracy, dec_values] = svmpredict(label, allfeature, model);  
    result=[predict_label truelabel];    
    save(sprintf('%s\\%s%d.mat', conf.modelpath, conf.resultname, nnn),'result');
end
rmpath(conf.svmpath);
end


