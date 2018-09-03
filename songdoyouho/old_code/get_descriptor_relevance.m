% 算descriptor relevance，把不要的traj砍掉
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
descriptor_relevance_thr=conf.descriptor_relevance_thr;
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
% load codebook_relevance
load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX1.mat',conf.tmppath));
load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX2.mat',conf.tmppath));
load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX3.mat',conf.tmppath));
load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX4.mat',conf.tmppath));
load(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX5.mat',conf.tmppath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        % PCA
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        % get posterior
        posteriorX1 = vl_gmm_get_posteriors(pcaX1', model1.means, model1.covariances, model1.priors);
        posteriorX2 = vl_gmm_get_posteriors(pcaX2', model2.means, model2.covariances, model2.priors);
        posteriorX3 = vl_gmm_get_posteriors(pcaX3', model3.means, model3.covariances, model3.priors);
        posteriorX4 = vl_gmm_get_posteriors(pcaX4', model4.means, model4.covariances, model4.priors);
        posteriorX5 = vl_gmm_get_posteriors(pcaX5', model5.means, model5.covariances, model5.priors);
        % get descriptor relevance
        descriptor_relevance.X1 = posteriorX1' * codebook_relevanceX1;
        descriptor_relevance.X2 = posteriorX2' * codebook_relevanceX2;
        descriptor_relevance.X3 = posteriorX3' * codebook_relevanceX3;
        descriptor_relevance.X4 = posteriorX4' * codebook_relevanceX4;
        descriptor_relevance.X5 = posteriorX5' * codebook_relevanceX5;
        save(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j),'descriptor_relevance');
        %         descriptor_index = descriptor_relevance.X3 >= 0.55;
        %         relevance_feature = X(descriptor_index,:);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         nowframe=X(1,1);
%         endframe=X(size(X,1),1);
%         relevance_feature = [];
%         while(nowframe<=endframe)
%             % take 2 frames of features out
%             index=X(:,1);
%             indexnow=index(:,1)==nowframe;
%             tmpX=X(indexnow,:);
%             nowframe=nowframe+1;
%             if nowframe>endframe
%                 break;
%             end
%             
%             if size(tmpX,1) <= 20
%                 tmp_relevance_feature = tmpX;
%             else
%                 tmp_score = descriptor_relevance.X2(indexnow,1);
%                 descriptor_index = tmp_score >= 0.3;  % threshold is here
%                 tmp_relevance_feature = tmpX(descriptor_index,:);
%             end
%             relevance_feature = [relevance_feature; tmp_relevance_feature];
%             disp('show video');
%             thisFrame = read(mov, nowframe);
%             imshow(thisFrame);
%             hold on;
%             for bbb=1:size(X,1)
%                 if nowframe-1==X(bbb,1)
%                     plot(X(bbb,2),X(bbb,3),'g*');
%                     hold on;
%                 end
%             end
%             for bbb=1:size(relevance_feature,1)
%                 if nowframe-1==relevance_feature(bbb,1)
%                     plot(relevance_feature(bbb,2),relevance_feature(bbb,3),'r*');
%                     hold on;
%                 end
%             end
%             pause(0.2)
%             clf
%         end
%         save(sprintf('%s\\relevance_feature\\relevance_feature%d_%d.mat',conf.videopath,vi,j),'relevance_feature');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        % PCA
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        % get posterior
        posteriorX1 = vl_gmm_get_posteriors(pcaX1', model1.means, model1.covariances, model1.priors);
        posteriorX2 = vl_gmm_get_posteriors(pcaX2', model2.means, model2.covariances, model2.priors);
        posteriorX3 = vl_gmm_get_posteriors(pcaX3', model3.means, model3.covariances, model3.priors);
        posteriorX4 = vl_gmm_get_posteriors(pcaX4', model4.means, model4.covariances, model4.priors);
        posteriorX5 = vl_gmm_get_posteriors(pcaX5', model5.means, model5.covariances, model5.priors);
        % get descriptor relevance
        descriptor_relevance.X1 = posteriorX1' * codebook_relevanceX1;
        descriptor_relevance.X2 = posteriorX2' * codebook_relevanceX2;
        descriptor_relevance.X3 = posteriorX3' * codebook_relevanceX3;
        descriptor_relevance.X4 = posteriorX4' * codebook_relevanceX4;
        descriptor_relevance.X5 = posteriorX5' * codebook_relevanceX5;
        save(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j),'descriptor_relevance');
        %         descriptor_index = descriptor_relevance.X3 >= 0.55;
        %         relevance_feature = X(descriptor_index,:);
        %         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        %         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         nowframe=X(1,1);
%         endframe=X(size(X,1),1);
%         relevance_feature = [];
%         while(nowframe<=endframe)
%             % take 2 frames of features out
%             index=X(:,1);
%             indexnow=index(:,1)==nowframe;
%             tmpX=X(indexnow,:);
%             nowframe=nowframe+1;
%             if nowframe>endframe
%                 break;
%             end
%             
%             if size(tmpX,1) <= 50
%                 tmp_relevance_feature = tmpX;
%             else
%                 tmp_score = descriptor_relevance.X3(indexnow,1);
%                 descriptor_index = tmp_score >= 0.5;  % threshold is here
%                 tmp_relevance_feature = tmpX(descriptor_index,:);
%             end
%             relevance_feature = [relevance_feature; tmp_relevance_feature];
            %             disp('show video');
            %             thisFrame = read(mov, nowframe);
            %             imshow(thisFrame);
            %             hold on;
            %             for bbb=1:size(X,1)
            %                 if nowframe-1==X(bbb,1)
            %                     plot(X(bbb,2),X(bbb,3),'g*');
            %                     hold on;
            %                 end
            %             end
            %             for bbb=1:size(relevance_feature,1)
            %                 if nowframe-1==relevance_feature(bbb,1)
            %                     plot(relevance_feature(bbb,2),relevance_feature(bbb,3),'r*');
            %                     hold on;
            %                 end
            %             end
            %             pause(0.2)
            %             clf
%         end
%         save(sprintf('%s\\relevance_feature\\relevance_feature%d_%d.mat',conf.videopath,vi,j),'relevance_feature');
    end
end