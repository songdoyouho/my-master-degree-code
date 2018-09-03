function [  ] = relevance_intosvm( conf,flag )
%RELEVANCE_INTOSVM Summary of this function goes here
%   Detailed explanation goes here
tridx=conf.tridx;
teidx=conf.teidx;
actnum=conf.actnum;
nnn=conf.nnn;

% use which one to apply svm 
load_encoding=conf.load_encoding;
load_W=conf.load_W;
load_relevance_encoding=conf.load_relevance_encoding;
load_relevance_W=conf.load_relevance_W;
% get codebook threshold
% codebook_relevance_thr=conf.codebook_relevance_thr;
% add libsvm path
addpath(conf.svmpath);
% load codebook_relevance
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX1.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX2.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX3.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX4.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX5.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX6.mat',conf.tmppath));
% % 算哪些群是重要的群
% aboveX1=codebook_relevanceX1(:,1)>=codebook_relevance_thr;
% aboveX2=codebook_relevanceX2(:,1)>=codebook_relevance_thr;
% aboveX3=codebook_relevanceX3(:,1)>=codebook_relevance_thr;
% aboveX4=codebook_relevanceX4(:,1)>=codebook_relevance_thr;
% aboveX5=codebook_relevanceX5(:,1)>=codebook_relevance_thr;
% aboveX6=codebook_relevanceX6(:,1)>=codebook_relevance_thr;
% fv_indexX1 = assign_index(aboveX1, 15);
% fv_indexX2 = assign_index(aboveX2, 48);
% fv_indexX3 = assign_index(aboveX3, 54);
% fv_indexX4 = assign_index(aboveX4, 48);
% fv_indexX5 = assign_index(aboveX5, 48);
% fv_indexX6 = assign_index(aboveX6, 15);
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
            casWencoding=[];
            if load_encoding ==1
                load(sprintf('%s\\encoding\\TVL1_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\TVL1_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding = [encoding.traj' encoding.disp' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
                
%                 load(sprintf('%s\\encoding\\TVL1_Ac_encoding%d_%d.mat', conf.tmppath, vi, j));
%                 fprintf('%s\\encoding\\TVL1_Ac_encoding%d_%d.mat\n', conf.tmppath, vi, j);                
%                 casAcencoding = [encoding.traj' encoding.disp' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
                
%                 casencoding = [casencoding casAcencoding];
                
                % keep the important dimensions
%                 traj = encoding.traj';
%                 traj = traj(logical(fv_indexX1));
%                 hog = encoding.hog';
%                 hog = hog(logical(fv_indexX2));
%                 hof = encoding.hof';
%                 hof = hof(logical(fv_indexX3));
%                 mbhx = encoding.mbhx';
%                 mbhx = mbhx(logical(fv_indexX4));
%                 mbhy = encoding.mbhy';
%                 mbhy = mbhy(logical(fv_indexX5));
% 				disp = encoding.disp';
% 				disp = disp(logical(fv_indexX6));
%                 casencoding=[traj hog hof mbhx mbhy disp];

            end
            if load_W == 1
                load(sprintf('%s\\TVL1_W1\\W1%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\TVL1_W1\\W1%d_%d.mat\n', conf.tmppath, vi, j);
                W1.traj_W1 = W1.traj_W1/norm(W1.traj_W1);
                W1.hog_W1 = W1.hog_W1/norm(W1.hog_W1);
                W1.hof_W1 = W1.hof_W1/norm(W1.hof_W1);
                W1.mbhx_W1 = W1.mbhx_W1/norm(W1.mbhx_W1);
                W1.mbhy_W1 = W1.mbhy_W1/norm(W1.mbhy_W1);
				W1.disp_W1 = W1.disp_W1/norm(W1.disp_W1);
                casWencoding = [W1.traj_W1 W1.disp_W1 W1.hog_W1 W1.hof_W1 W1.mbhx_W1 W1.mbhy_W1];
            end
            if load_relevance_encoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding = [casencoding encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if load_relevance_W == 1
                load(sprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat\n', conf.tmppath, vi, j);  
                W1.traj_W1 = W1.traj_W1/norm(W1.traj_W1);
                W1.hog_W1 = W1.hog_W1/norm(W1.hog_W1);
                W1.hof_W1 = W1.hof_W1/norm(W1.hof_W1);
                W1.mbhx_W1 = W1.mbhx_W1/norm(W1.mbhx_W1);
                W1.mbhy_W1 = W1.mbhy_W1/norm(W1.mbhy_W1);
				W1.disp_W1 = W1.disp_W1/norm(W1.disp_W1);
                casWencoding = [W1.traj_W1 W1.disp W1.hog_W1 W1.hof_W1 W1.mbhx_W1 W1.mbhy_W1];
            end
            cas=[casencoding  casWencoding];
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
    video_index=[];
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            % load features
            casencoding=[];
            casWencoding=[];
            if load_encoding ==1
                load(sprintf('%s\\encoding\\TVL1_encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\TVL1_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding = [encoding.traj' encoding.disp' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
                
%                 load(sprintf('%s\\encoding\\TVL1_Ac_encoding%d_%d.mat', conf.tmppath, vi, j));
%                 fprintf('%s\\encoding\\TVL1_Ac_encoding%d_%d.mat\n', conf.tmppath, vi, j);                
%                 casAcencoding = [encoding.traj' encoding.disp' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
%                 
%                 casencoding = [casencoding casAcencoding];
                
                % keep the important dimensions
%                 traj = encoding.traj';
%                 traj = traj(logical(fv_indexX1));
%                 hog = encoding.hog';
%                 hog = hog(logical(fv_indexX2));
%                 hof = encoding.hof';
%                 hof = hof(logical(fv_indexX3));
%                 mbhx = encoding.mbhx';
%                 mbhx = mbhx(logical(fv_indexX4));
%                 mbhy = encoding.mbhy';
%                 mbhy = mbhy(logical(fv_indexX5));
% 				disp = encoding.disp';
% 				disp = disp(logical(fv_indexX6));
%                 casencoding=[traj hog hof mbhx mbhy disp]

            end
            if load_W == 1
                load(sprintf('%s\\TVL1_W1\\W1%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\TVL1_W1\\W1%d_%d.mat\n', conf.tmppath, vi, j);
                W1.traj_W1 = W1.traj_W1/norm(W1.traj_W1);
                W1.hog_W1 = W1.hog_W1/norm(W1.hog_W1);
                W1.hof_W1 = W1.hof_W1/norm(W1.hof_W1);
                W1.mbhx_W1 = W1.mbhx_W1/norm(W1.mbhx_W1);
                W1.mbhy_W1 = W1.mbhy_W1/norm(W1.mbhy_W1);
				W1.disp_W1 = W1.disp_W1/norm(W1.disp_W1);
                casWencoding = [W1.traj_W1 W1.disp_W1 W1.hog_W1 W1.hof_W1 W1.mbhx_W1 W1.mbhy_W1];
            end
            if load_relevance_encoding == 1
                load(sprintf('%s\\encoding\\encoding%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\encoding\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                casencoding = [casencoding encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            end
            if load_relevance_W == 1
                load(sprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat', conf.tmppath, vi, j));
                fprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat\n', conf.tmppath, vi, j);
                W1.traj_W1 = W1.traj_W1/norm(W1.traj_W1);
                W1.hog_W1 = W1.hog_W1/norm(W1.hog_W1);
                W1.hof_W1 = W1.hof_W1/norm(W1.hof_W1);
                W1.mbhx_W1 = W1.mbhx_W1/norm(W1.mbhx_W1);
                W1.mbhy_W1 = W1.mbhy_W1/norm(W1.mbhy_W1);
% 				W1.disp_W1 = W1.disp_W1/norm(W1.disp_W1);
                casWencoding = [W1.traj_W1 W1.hog_W1 W1.hof_W1 W1.mbhx_W1 W1.mbhy_W1];
            end
            feature=[casencoding casWencoding]; 
            allfeature=[allfeature; feature];
            truelabel=[truelabel; j];
            video_index=[video_index; vi];
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
    result=[I(:,1) truelabel video_index]; % predict label truth label video index!!!!!
    
    save(sprintf('%s\\%s%d.mat', conf.resultpath, conf.resultname, nnn),'result');
end
rmpath(conf.svmpath);
end

function [n_index] = assign_index(above, D)
f = @(x) x * ones(2 * D,1);
index = arrayfun(f, above, 'UniformOutput', false);
n_index = cell2mat(index);
n_index = reshape(n_index,1,[]);
end
