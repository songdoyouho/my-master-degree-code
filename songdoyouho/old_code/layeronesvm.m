function [  ] = layeronesvm( conf,flag )
% layeroneSVM Summary of this function goes here
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
globalclass=conf.globalclass;
localclass=conf.localclass;
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
                %                 casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
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
            cas=[casencoding casselectencoding casWencoding casseg2Wencoding casseg03Wencoding];
            
            feature=[feature; cas];
        end
    end
    
    
    label=[];
    for j=1:actnum
        % take index
        for i=1:numel(tridx{j,1})
            if j==1||j==4||j==5||j==6||j==7 % local
                label=[label; 1];
            else % global
                label=[label; -1];
            end
        end
    end
    
    trainindex=[];
    for jj=1:actnum
        % take index
        for kk=1:numel(tridx{jj,1})
            trainindex=[trainindex; jj];
        end
    end
    
    % global and local classify
    %     finallabel=[label(1:5,:);label(14:18,:);label(19:23,:);label(31:35,:);label(41:45,:);label(1:5,:);label(50:54,:);label(62:66,:);label(69:73,:);label(78:82,:);label(91:95,:);];
    %     finalfeature=[feature(1:5,:);feature(14:18,:);feature(19:23,:);feature(31:35,:);feature(41:45,:);feature(1:5,:);feature(50:54,:);feature(62:66,:);feature(69:73,:);feature(78:82,:);feature(91:95,:);];
    % train svm model (global and local)
    %     layerone_model = svmtrain(finallabel, finalfeature, '-c 100 -t 0');
    layerone_model = svmtrain(label, feature, '-c 100 -t 0');
    save(sprintf('%s\\layerone_model.mat',conf.layeronepath),'layerone_model');
    
    % seperate global and local features
    globalfeature=[];
    globalindex=[];
    for qwe=1:size(globalclass,1)
        index=trainindex(:,1)==globalclass(qwe,1);
        tmp=feature(index,:);
        globalfeature=[globalfeature; tmp];
        globalindex=[globalindex; trainindex(index,1)];
    end
    localfeature=[];
    localindex=[];
    for qwe=1:size(localclass,1)
        index=trainindex(:,1)==localclass(qwe,1);
        tmp=feature(index,:);
        localfeature=[localfeature; tmp];
        localindex=[localindex; trainindex(index,1)];
    end
    % train global model
    for qwe=1:size(globalclass,1)
        zxc=globalclass(qwe,1);
        label=zeros(size(globalfeature,1),1);
        for asd=1:size(label,1)
            if globalindex(asd,1)==zxc
                label(asd,1)=1;
            else
                label(asd,1)=-1;
            end
        end
        layertwo_globalmodel = svmtrain(label, globalfeature, '-c 100 -t 0');
        save(sprintf('%s\\layertwo_globalmodel%d.mat',conf.layeronepath,zxc),'layertwo_globalmodel');
    end
    % train lacal model
    for qwe=1:size(localclass,1)
        zxc=localclass(qwe,1);
        label=zeros(size(localfeature,1),1);
        for asd=1:size(label,1)
            if localindex(asd,1)==zxc
                label(asd,1)=1;
            else
                label(asd,1)=-1;
            end
        end
        layertwo_localmodel = svmtrain(label, localfeature, '-c 100 -t 0');
        save(sprintf('%s\\layertwo_localmodel%d.mat',conf.layeronepath,zxc),'layertwo_localmodel');
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
            casseg2Wencoding=[];
            casseg03Wencoding=[];
            if loadencoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                %                 casencoding=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
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
            if j==1||j==4||j==5||j==6||j==7
                truelabel=[truelabel; 1]; % local
            else
                truelabel=[truelabel; -1]; % global
            end
        end
    end
    
    testindex=[];
    for jj=1:actnum
        % take index
        for kk=1:numel(teidx{jj,1})
            testindex=[testindex; jj];
        end
    end
    
    % test svm
    label=zeros(size(allfeature,1),1);
    load(sprintf('%s\\layerone_model.mat',conf.layeronepath));
    [predict_label, accuracy, dec_values] = svmpredict(label, allfeature, layerone_model);
    result=[predict_label truelabel testindex];
    % accuracy
    acc=0;
    for iii=1:size(result,1)
        if result(iii,1)==result(iii,2)
            acc=acc+1;
        end
    end
    save(sprintf('%s\\layerone_result%d.mat', conf.layeronepath, nnn),'result');
    % seperate test feature
    index=predict_label==1;
    localfeature=allfeature(index,:);
    localtestindex=testindex(index,:);
    locallabel=zeros(size(localfeature,1),1);
    index=predict_label==-1;
    globalfeature=allfeature(index,:);
    globaltestindex=testindex(index,:);
    globallabel=zeros(size(globalfeature,1),1);
    % test local svm
    comp=[];
    for zxc=1:size(localclass,1)
        load(sprintf('%s\\layertwo_localmodel%d.mat',conf.layeronepath,localclass(zxc,1)));
        [predict_label, accuracy, dec_values] = svmpredict(locallabel, localfeature, layertwo_localmodel);
        comp=[comp dec_values];
    end
    [B I]=sort(comp, 2, 'descend');
    localresult=[localclass(I(:,1),1) localtestindex];
    % test global svm
    comp=[];
    for zxc=1:size(globalclass,1)
        load(sprintf('%s\\layertwo_globalmodel%d.mat',conf.layeronepath,globalclass(zxc,1)));
        [predict_label, accuracy, dec_values] = svmpredict(globallabel, globalfeature, layertwo_globalmodel);
        comp=[comp dec_values];
    end
    [B I]=sort(comp, 2, 'descend');
    globalresult=[globalclass(I(:,1),1) globaltestindex];
    
    % combine result
    result=[localresult; globalresult];
    save(sprintf('%s\\%s%d.mat', conf.layeronepath, conf.resultname, nnn),'result');
end
rmpath(conf.svmpath);
end



