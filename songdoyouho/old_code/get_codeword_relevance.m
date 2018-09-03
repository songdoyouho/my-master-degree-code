% 算 codeword relevance，找出前景背景的codeword
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

addpath(genpath(conf.vlfeatpath));
vl_setup

% load GMM model
load(sprintf('%s\\displacement_model1.mat',conf.modelpath));
load(sprintf('%s\\displacement_model2.mat',conf.modelpath));
load(sprintf('%s\\displacement_model3.mat',conf.modelpath));
load(sprintf('%s\\displacement_model4.mat',conf.modelpath));
load(sprintf('%s\\displacement_model5.mat',conf.modelpath));
load(sprintf('%s\\displacement_model6.mat',conf.modelpath));
% load pca
load(sprintf('%s\\displacement_coeff1.mat',conf.modelpath));
load(sprintf('%s\\displacement_coeff2.mat',conf.modelpath));
load(sprintf('%s\\displacement_coeff3.mat',conf.modelpath));
load(sprintf('%s\\displacement_coeff4.mat',conf.modelpath));
load(sprintf('%s\\displacement_coeff5.mat',conf.modelpath));
load(sprintf('%s\\displacement_coeff6.mat',conf.modelpath));
% initial all_mom and all_son
all_momX1 = zeros(conf.numclusters,1);
all_momX2 = zeros(conf.numclusters,1);
all_momX3 = zeros(conf.numclusters,1);
all_momX4 = zeros(conf.numclusters,1);
all_momX5 = zeros(conf.numclusters,1);
all_momX6 = zeros(conf.numclusters,1);
all_sonX1 = zeros(conf.numclusters,1);
all_sonX2 = zeros(conf.numclusters,1);
all_sonX3 = zeros(conf.numclusters,1);
all_sonX4 = zeros(conf.numclusters,1);
all_sonX5 = zeros(conf.numclusters,1);
all_sonX6 = zeros(conf.numclusters,1);

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\displacement\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\displacement\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load label
        load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\motion_all_label\\%d_%d.mat\n', conf.tmppath, vi, j);
        momX1 = zeros(conf.numclusters,1);
        momX2 = zeros(conf.numclusters,1);
        momX3 = zeros(conf.numclusters,1);
        momX4 = zeros(conf.numclusters,1);
        momX5 = zeros(conf.numclusters,1);
        momX6 = zeros(conf.numclusters,1);
        sonX1 = zeros(conf.numclusters,1);
        sonX2 = zeros(conf.numclusters,1);
        sonX3 = zeros(conf.numclusters,1);
        sonX4 = zeros(conf.numclusters,1);
        sonX5 = zeros(conf.numclusters,1);
        sonX6 = zeros(conf.numclusters,1);
        
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        
        for k=startframe:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:31);
                X6=tmpX(:,32:61);
                X2=tmpX(:,62:157);
                X3=tmpX(:,158:265);
                X4=tmpX(:,266:361);
                X5=tmpX(:,362:457);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                pcaX6=X6*newcoeff6;
                % get posterior
                posteriorX1 = vl_gmm_get_posteriors(pcaX1', model1.means, model1.covariances, model1.priors);
                posteriorX2 = vl_gmm_get_posteriors(pcaX2', model2.means, model2.covariances, model2.priors);
                posteriorX3 = vl_gmm_get_posteriors(pcaX3', model3.means, model3.covariances, model3.priors);
                posteriorX4 = vl_gmm_get_posteriors(pcaX4', model4.means, model4.covariances, model4.priors);
                posteriorX5 = vl_gmm_get_posteriors(pcaX5', model5.means, model5.covariances, model5.priors);
                posteriorX6 = vl_gmm_get_posteriors(pcaX6', model6.means, model6.covariances, model6.priors);
                % 得到分母
                momX1 = sum(posteriorX1,2);
                momX2 = sum(posteriorX2,2);
                momX3 = sum(posteriorX3,2);
                momX4 = sum(posteriorX4,2);
                momX5 = sum(posteriorX5,2);
                momX6 = sum(posteriorX6,2);
                % 得到分子
                if size(all_label{:,k},1) == 1
                    all_label{:,k} = all_label{:,k}';
                end
                sonX1 = posteriorX1 * all_label{:,k};
                sonX2 = posteriorX2 * all_label{:,k};
                sonX3 = posteriorX3 * all_label{:,k};
                sonX4 = posteriorX4 * all_label{:,k};
                sonX5 = posteriorX5 * all_label{:,k};
                sonX6 = posteriorX6 * all_label{:,k};
                % 把每張frame的mom and son相加
                all_momX1 = all_momX1 + momX1;
                all_momX2 = all_momX2 + momX2;
                all_momX3 = all_momX3 + momX3;
                all_momX4 = all_momX4 + momX4;
                all_momX5 = all_momX5 + momX5;
                all_momX6 = all_momX6 + momX6;
                all_sonX1 = all_sonX1 + sonX1;
                all_sonX2 = all_sonX2 + sonX2;
                all_sonX3 = all_sonX3 + sonX3;
                all_sonX4 = all_sonX4 + sonX4;
                all_sonX5 = all_sonX5 + sonX5;
                all_sonX6 = all_sonX6 + sonX6;
            end
        end
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\displacement\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\displacement\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load label
        load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\motion_all_label\\%d_%d.mat\n', conf.tmppath, vi, j);
        momX1 = zeros(conf.numclusters,1);
        momX2 = zeros(conf.numclusters,1);
        momX3 = zeros(conf.numclusters,1);
        momX4 = zeros(conf.numclusters,1);
        momX5 = zeros(conf.numclusters,1);
        momX6 = zeros(conf.numclusters,1);
        sonX1 = zeros(conf.numclusters,1);
        sonX2 = zeros(conf.numclusters,1);
        sonX3 = zeros(conf.numclusters,1);
        sonX4 = zeros(conf.numclusters,1);
        sonX5 = zeros(conf.numclusters,1);
        sonX6 = zeros(conf.numclusters,1);
        
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        
        for k=startframe:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:31);
                X6=tmpX(:,32:61);
                X2=tmpX(:,62:157);
                X3=tmpX(:,158:265);
                X4=tmpX(:,266:361);
                X5=tmpX(:,362:457);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                pcaX6=X6*newcoeff6;
                % get posterior
                posteriorX1 = vl_gmm_get_posteriors(pcaX1', model1.means, model1.covariances, model1.priors);
                posteriorX2 = vl_gmm_get_posteriors(pcaX2', model2.means, model2.covariances, model2.priors);
                posteriorX3 = vl_gmm_get_posteriors(pcaX3', model3.means, model3.covariances, model3.priors);
                posteriorX4 = vl_gmm_get_posteriors(pcaX4', model4.means, model4.covariances, model4.priors);
                posteriorX5 = vl_gmm_get_posteriors(pcaX5', model5.means, model5.covariances, model5.priors);
                posteriorX6 = vl_gmm_get_posteriors(pcaX6', model6.means, model6.covariances, model6.priors);
                % 得到分母
                momX1 = sum(posteriorX1,2);
                momX2 = sum(posteriorX2,2);
                momX3 = sum(posteriorX3,2);
                momX4 = sum(posteriorX4,2);
                momX5 = sum(posteriorX5,2);
                momX6 = sum(posteriorX6,2);
                % 得到分子
                if size(all_label{:,k},1) == 1
                    all_label{:,k} = all_label{:,k}';
                end
                sonX1 = posteriorX1 * all_label{:,k};
                sonX2 = posteriorX2 * all_label{:,k};
                sonX3 = posteriorX3 * all_label{:,k};
                sonX4 = posteriorX4 * all_label{:,k};
                sonX5 = posteriorX5 * all_label{:,k};
                sonX6 = posteriorX6 * all_label{:,k};
                % 把每張frame的mom and son相加
                all_momX1 = all_momX1 + momX1;
                all_momX2 = all_momX2 + momX2;
                all_momX3 = all_momX3 + momX3;
                all_momX4 = all_momX4 + momX4;
                all_momX5 = all_momX5 + momX5;
                all_momX6 = all_momX6 + momX6;
                all_sonX1 = all_sonX1 + sonX1;
                all_sonX2 = all_sonX2 + sonX2;
                all_sonX3 = all_sonX3 + sonX3;
                all_sonX4 = all_sonX4 + sonX4;
                all_sonX5 = all_sonX5 + sonX5;
                all_sonX6 = all_sonX6 + sonX6;
            end
        end
    end
end
% get codebook relevance
codebook_relevanceX1 = all_sonX1 ./ all_momX1;
codebook_relevanceX2 = all_sonX2 ./ all_momX2;
codebook_relevanceX3 = all_sonX3 ./ all_momX3;
codebook_relevanceX4 = all_sonX4 ./ all_momX4;
codebook_relevanceX5 = all_sonX5 ./ all_momX5;
codebook_relevanceX6 = all_sonX6 ./ all_momX6;
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX1.mat',conf.tmppath),'codebook_relevanceX1');
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX2.mat',conf.tmppath),'codebook_relevanceX2');
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX3.mat',conf.tmppath),'codebook_relevanceX3');
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX4.mat',conf.tmppath),'codebook_relevanceX4');
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX5.mat',conf.tmppath),'codebook_relevanceX5');
save(sprintf('%s\\codebook_relevance\\motion_codebook_relevanceX6.mat',conf.tmppath),'codebook_relevanceX6');