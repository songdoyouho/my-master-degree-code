function [  ] = newintosvm( conf,flag )
%NEWINTOSVM Summary of this function goes here
% svm training and testing
tridx=conf.tridx;
teidx=conf.teidx;
actnum=conf.actnum;
nnn=conf.nnn;

loadencoding=conf.loadencoding;
loadselect=conf.loadselect;
loadW=conf.loadW;
loadsegW=conf.loadsegW;
loadpoolingW=conf.loadpoolingW;
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
            cassegWencoding=[];
            caspoolingW=[];
            if loadencoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadselect ==1
                load(sprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casselectencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadW == 1
                load(sprintf('%s\\W2\\W2%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\W2\\W2%d_%d.mat\n', conf.tmppath, vi, j);
                casWencoding=[W2.traj_W2 W2.hog_W2 W2.hof_W2 W2.mbhx_W2 W2.mbhy_W2];
            end
            if loadsegW == 1
                load(sprintf('%s\\pr_W2\\pr_W2%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\pr_W2\\pr_W2%d_%d.mat\n', conf.tmppath, vi, j);
                cassegWencoding=W5/norm(W5);
            end
            if loadpoolingW == 1
                load(sprintf('%s\\64_pooling\\moving_pooling%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\64_pooling\\moving_pooling%d_%d.mat\n', conf.tmppath, vi, j);
                caspoolingW=pyramid_pooling_features/norm(pyramid_pooling_features);
            end
            cas=[casencoding casselectencoding casWencoding cassegWencoding caspoolingW];            
            feature=[feature; cas];
        end
    end
    
    for k=1:actnum
        label=[];
        for j=1:actnum
            % take index
            for i=1:numel(tridx{j,1})
                vi=tridx{j,1}(1,i);
                if k==j
                    label=[label; 1];
                else
                    label=[label; -1];
                end
            end
        end
        % train svm model
        model = svmtrain(label, feature, '-c 100 -t 0');
        save(sprintf('%s\\svmmodel%d.mat',conf.modelpath,k),'model');
    end
    rmpath(conf.svmpath);
end
%%
if(strcmp(flag, 'test'))
    result=[];
    allfeature=[];
    truelabel=[];
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            % load features
            casencoding=[];
            casselectencoding=[];
            casWencoding=[];
            cassegWencoding=[];
            caspoolingW=[];
            if loadencoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadselect ==1
                load(sprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casselectencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if loadW == 1
                load(sprintf('%s\\W5\\W5%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\W5\\W5%d_%d.mat\n', conf.tmppath, vi, j);
                casWencoding=W5/norm(W5);
            end
            if loadsegW == 1
                load(sprintf('%s\\pr_W2\\pr_W2%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\pr_W2\\pr_W2%d_%d.mat\n', conf.tmppath, vi, j);
                cassegWencoding=W5/norm(W5);
            end
            if loadpoolingW == 1
                load(sprintf('%s\\64_pooling\\moving_pooling%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\64_pooling\\moving_pooling%d_%d.mat\n', conf.tmppath, vi, j);
                caspoolingW=pyramid_pooling_features/norm(pyramid_pooling_features);
%                 load(sprintf('%s\\64_pooling\\moving_sumpooling%d_%d.mat', conf.tmppath, vi, j));
%                 fprintf('%s\\64_pooling\\moving_sumpooling%d_%d.mat\n', conf.tmppath, vi, j);
%                 caspoolingW=[caspoolingW sumpooling/norm(sumpooling)];
            end

            feature=[casencoding casselectencoding casWencoding cassegWencoding caspoolingW];            
            allfeature=[allfeature; feature];
            truelabel=[truelabel; j];
        end
    end
    % test svm
    comp=[];
    label=zeros(size(allfeature,1),1);
    for n=1:actnum
        load(sprintf('%s\\svmmodel%d.mat',conf.modelpath,n));
        [predict_label, accuracy, dec_values] = svmpredict(label, allfeature, model);
        comp=[comp dec_values];
    end
    [B I]=sort(comp, 2, 'descend');
    result=[I(:,1) truelabel];
    
    save(sprintf('%s\\%s%d.mat', conf.resultpath, conf.resultname, nnn),'result');
end
rmpath(conf.svmpath);
end


