actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% get descriptor threshold
% descriptor_relevance_thr=conf.descriptor_relevance_thr;
% relevance_thr=conf.codebook_relevance_thr;
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
% load(sprintf('%s\\model6.mat',conf.modelpath));
% load pca
load(sprintf('%s\\coeff1.mat',conf.modelpath));
load(sprintf('%s\\coeff2.mat',conf.modelpath));
load(sprintf('%s\\coeff3.mat',conf.modelpath));
load(sprintf('%s\\coeff4.mat',conf.modelpath));
load(sprintf('%s\\coeff5.mat',conf.modelpath));
% load(sprintf('%s\\coeff6.mat',conf.modelpath));
% % load codebook_relevance
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX1.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX2.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX3.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX4.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX5.mat',conf.tmppath));
% load(sprintf('%s\\codebook_relevance\\codebook_relevanceX6.mat',conf.tmppath));
% % 算哪些群是重要的群
% aboveX1=codebook_relevanceX1(:,1)>=relevance_thr;
% aboveX2=codebook_relevanceX2(:,1)>=relevance_thr;
% aboveX3=codebook_relevanceX3(:,1)>=relevance_thr;
% aboveX4=codebook_relevanceX4(:,1)>=relevance_thr;
% aboveX5=codebook_relevanceX5(:,1)>=relevance_thr;
% fv_indexX1 = assign_index(aboveX1, 15);
% fv_indexX2 = assign_index(aboveX2, 48);
% fv_indexX3 = assign_index(aboveX3, 54);
% fv_indexX4 = assign_index(aboveX4, 48);
% fv_indexX5 = assign_index(aboveX5, 48);

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        %         load(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        %         % select features ~~~
        %         descriptor_index = descriptor_relevance.X3 >= descriptor_relevance_thr;
        %         relevance_feature = X(descriptor_index,:);
        %         startframe=relevance_feature(1,1);
        %         endframe=relevance_feature(size(relevance_feature,1),1);
        
        allencoding=[];
        endframe = X(size(X,1),1);
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            now_tmpX=X(index,:);
            %             relevance_index=relevance_feature(:,1)==k;
            %             now_relevance_tmpX=relevance_feature(relevance_index,:);
            %             % if feature num >= thr, use selected feature set
            %             if size(now_tmpX,1) >= conf.perframenum
            %                 tmpX = now_relevance_tmpX;
            %             else % else use the original feature set
            %                 tmpX = now_tmpX;
            %             end
            tmpX = now_tmpX;
            check=isempty(tmpX);
            if check~=1
                %                 X1=tmpX(:,2:31);
                %                 X6=tmpX(:,32:61);
                %                 X2=tmpX(:,62:157);
                %                 X3=tmpX(:,158:265);
                %                 X4=tmpX(:,266:361);
                %                 X5=tmpX(:,362:457);
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
                %                 pcaX6=X6*newcoeff6;
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
                %                 tmpE = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
                %                 E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        
%         save(sprintf('%s\\allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        
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
        %         disp_W1 = VideoDarwin(allencoding(:,109057:116736));
        %         disp_W1 = disp_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        %         W1.disp_W1 = disp_W1;
        
        save(sprintf('%s\\W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        
        %         traj = allencoding(:,1:7680);
        %         traj_W1 = VideoDarwin(traj(:,logical(fv_indexX1)));
        %         traj_W1 = traj_W1';
        %         hog = allencoding(:,7681:32256);
        %         hog_W1 = VideoDarwin(hog(:,logical(fv_indexX2)));
        %         hog_W1 = hog_W1';
        %         hof = allencoding(:,32257:59904);
        %         hof_W1 = VideoDarwin(hof(:,logical(fv_indexX3)));
        %         hof_W1 = hof_W1';
        %         mbhx = allencoding(:,59905:84480);
        %         mbhx_W1 = VideoDarwin(mbhx(:,logical(fv_indexX4)));
        %         mbhx_W1 = mbhx_W1';
        %         mbhy = allencoding(:,84481:109056);
        %         mbhy_W1 = VideoDarwin(mbhy(:,logical(fv_indexX5)));
        %         mbhy_W1 = mbhy_W1';
        %         W1.traj_W1 = traj_W1;
        %         W1.hog_W1 = hog_W1;
        %         W1.hof_W1 = hof_W1;
        %         W1.mbhx_W1 = mbhx_W1;
        %         W1.mbhy_W1 = mbhy_W1;
        %         save(sprintf('%s\\relevance_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        %         load(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        %         % select features ~~~
        %         descriptor_index = descriptor_relevance.X3 >= descriptor_relevance_thr;
        %         relevance_feature = X(descriptor_index,:);
        %         startframe=relevance_feature(1,1);
        %         endframe=relevance_feature(size(relevance_feature,1),1);
        
        allencoding=[];
        endframe = X(size(X,1),1);
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            now_tmpX=X(index,:);
            %             relevance_index=relevance_feature(:,1)==k;
            %             now_relevance_tmpX=relevance_feature(relevance_index,:);
            %             % if feature num >= thr, use selected feature set
            %             if size(now_tmpX,1) >= conf.perframenum
            %                 tmpX = now_relevance_tmpX;
            %             else % else use the original feature set
            %                 tmpX = now_tmpX;
            %             end
            tmpX = now_tmpX;
            check=isempty(tmpX);
            if check~=1
                %                 X1=tmpX(:,2:31);
                %                 X6=tmpX(:,32:61);
                %                 X2=tmpX(:,62:157);
                %                 X3=tmpX(:,158:265);
                %                 X4=tmpX(:,266:361);
                %                 X5=tmpX(:,362:457);
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
                %                 pcaX6=X6*newcoeff6;
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
                %                 tmpE = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
                %                 E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        
%         save(sprintf('%s\\allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        
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
        %         disp_W1 = VideoDarwin(allencoding(:,109057:116736));
        %         disp_W1 = disp_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        %         W1.disp_W1 = disp_W1;
        
        save(sprintf('%s\\W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        
        %         traj = allencoding(:,1:7680);
        %         traj_W1 = VideoDarwin(traj(:,logical(fv_indexX1)));
        %         traj_W1 = traj_W1';
        %         hog = allencoding(:,7681:32256);
        %         hog_W1 = VideoDarwin(hog(:,logical(fv_indexX2)));
        %         hog_W1 = hog_W1';
        %         hof = allencoding(:,32257:59904);
        %         hof_W1 = VideoDarwin(hof(:,logical(fv_indexX3)));
        %         hof_W1 = hof_W1';
        %         mbhx = allencoding(:,59905:84480);
        %         mbhx_W1 = VideoDarwin(mbhx(:,logical(fv_indexX4)));
        %         mbhx_W1 = mbhx_W1';
        %         mbhy = allencoding(:,84481:109056);
        %         mbhy_W1 = VideoDarwin(mbhy(:,logical(fv_indexX5)));
        %         mbhy_W1 = mbhy_W1';
        %         W1.traj_W1 = traj_W1;
        %         W1.hog_W1 = hog_W1;
        %         W1.hof_W1 = hof_W1;
        %         W1.mbhx_W1 = mbhx_W1;
        %         W1.mbhy_W1 = mbhy_W1;
        %         save(sprintf('%s\\relevance_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end

rmpath(genpath(conf.liblinear));
rmpath(genpath(conf.videodarwin));
rmpath(genpath(conf.vlfeatpath));