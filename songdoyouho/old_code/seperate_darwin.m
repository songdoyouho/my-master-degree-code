actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% get descriptor threshold
descriptor_relevance_thr=conf.descriptor_relevance_thr;
relevance_thr=conf.codebook_relevance_thr;
addpath(genpath(conf.liblinear));
addpath(genpath(conf.videodarwin));
addpath(genpath(conf.vlfeatpath));
vl_setup
% load GMM model
load(sprintf('%s\\model1.mat',conf.modelpath));
load(sprintf('%s\\model2.mat',conf.modelpath));
load(sprintf('%s\\model3.mat',conf.modelpath));
load(sprintf('%s\\model4.mat',conf.modelpath));
load(sprintf('%s\\model5.mat',conf.modelpath));
% load pca
load(sprintf('%s\\coeff1.mat',conf.modelpath));
load(sprintf('%s\\coeff2.mat',conf.modelpath));
load(sprintf('%s\\coeff3.mat',conf.modelpath));
load(sprintf('%s\\coeff4.mat',conf.modelpath));
load(sprintf('%s\\coeff5.mat',conf.modelpath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));        
        relevance_feature = X(outindex',:);
        startframe=relevance_feature(1,1);
        endframe=relevance_feature(size(relevance_feature,1),1);
        allencoding=[];
        for k=startframe:endframe
            % take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
            relevance_index=relevance_feature(:,1)==k;
            tmpX=relevance_feature(relevance_index,:);
%             now_relevance_tmpX=relevance_feature(relevance_index,:);
            % if feature num >= thr, use selected feature set
%             if size(now_tmpX,1) >= conf.perframenum
%                 tmpX = now_relevance_tmpX;
%             else % else use the original feature set
%                 tmpX = now_tmpX;
%             end
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:31);
                X2=tmpX(:,32:127);
                X3=tmpX(:,128:235);
                X4=tmpX(:,236:331);
                X5=tmpX(:,332:427);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                % encoding fisher vector and normalize
                E=[];
                tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        save(sprintf('%s\\relevance_allencoding\\motion_allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        traj_W1 = VideoDarwin(allencoding(:,1:7680));
        traj_W1 = traj_W1';
        hog_W1 = VideoDarwin(allencoding(:,7681:32256));
        hog_W1 = hog_W1';
        hof_W1 = VideoDarwin(allencoding(:,32257:59904));
        hof_W1 = hof_W1';
        mbhx_W1 = VideoDarwin(allencoding(:,59905:84480));
        mbhx_W1 = mbhx_W1';
        mbhy_W1 = VideoDarwin(allencoding(:,84481:109056));
        mbhy_W1 = mbhy_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        save(sprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));        
        relevance_feature = X(outindex',:);
        startframe=relevance_feature(1,1);
        endframe=relevance_feature(size(relevance_feature,1),1);
        allencoding=[];
        for k=startframe:endframe
            % take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
            relevance_index=relevance_feature(:,1)==k;
            tmpX=relevance_feature(relevance_index,:);
%             now_relevance_tmpX=relevance_feature(relevance_index,:);
            % if feature num >= thr, use selected feature set
%             if size(now_tmpX,1) >= conf.perframenum
%                 tmpX = now_relevance_tmpX;
%             else % else use the original feature set
%                 tmpX = now_tmpX;
%             end
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:31);
                X2=tmpX(:,32:127);
                X3=tmpX(:,128:235);
                X4=tmpX(:,236:331);
                X5=tmpX(:,332:427);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                % encoding fisher vector and normalize
                E=[];
                tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                E=[E tmpE'];
                tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        save(sprintf('%s\\relevance_allencoding\\motion_allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        traj_W1 = VideoDarwin(allencoding(:,1:7680));
        traj_W1 = traj_W1';
        hog_W1 = VideoDarwin(allencoding(:,7681:32256));
        hog_W1 = hog_W1';
        hof_W1 = VideoDarwin(allencoding(:,32257:59904));
        hof_W1 = hof_W1';
        mbhx_W1 = VideoDarwin(allencoding(:,59905:84480));
        mbhx_W1 = mbhx_W1';
        mbhy_W1 = VideoDarwin(allencoding(:,84481:109056));
        mbhy_W1 = mbhy_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        save(sprintf('%s\\relevance_W1\\seperate_W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end



rmpath(genpath(conf.liblinear));
rmpath(genpath(conf.videodarwin));
rmpath(genpath(conf.vlfeatpath));