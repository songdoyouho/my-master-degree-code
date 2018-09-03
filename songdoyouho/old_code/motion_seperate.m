function motion_seperate( conf )
%MOTION_SEPERATE Summary of this function goes here
%   Detailed explanation goes here
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
featurenum=fix(256000/videonumber);

% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup

% load PCA
load(sprintf('%s\\all_improved_traj_coeff1.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_coeff2.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_coeff3.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_coeff4.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_coeff5.mat',conf.modelpath)');

% load GMM model
load(sprintf('%s\\all_improved_traj_model1.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_model2.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_model3.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_model4.mat',conf.modelpath));
load(sprintf('%s\\all_improved_traj_model5.mat',conf.modelpath));
% get random features
% XXX=[];
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         % select feature for training GMM
%         if size(X,1)<featurenum
%             XXX=[XXX; X];
%         else
%             idid=randperm(size(X,1),featurenum);
%             X_idx = 1:size(X,1);
%             idx = ismember(X_idx,idid);
%             idx=idx';
%             X = X(idx,:);
%             XXX=[XXX; X];
%         end
%     end
% end
% 
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         % select feature for training GMM
%         if size(X,1)<featurenum
%             XXX=[XXX; X];
%         else
%             idid=randperm(size(X,1),featurenum);
%             X_idx = 1:size(X,1);
%             idx = ismember(X_idx,idid);
%             idx=idx';
%             X = X(idx,:);
%             XXX=[XXX; X];
%         end
%     end
% end
% 
% X1=XXX(:,2:31);
% X6=XXX(:,32:61);
% X2=XXX(:,62:157);
% X3=XXX(:,158:265);
% X4=XXX(:,266:361);
% X5=XXX(:,362:457);
% % pca for each features
% [all_improved_traj_coeff1, score1, latent1, tsquare1] = princomp(X1);
% newall_improved_traj_coeff1=all_improved_traj_coeff1(:,1:size(X1,2)/2);
% pcaX1=X1*newall_improved_traj_coeff1;
% [all_improved_traj_coeff2, score2, latent2, tsquare2] = princomp(X2);
% newall_improved_traj_coeff2=all_improved_traj_coeff2(:,1:size(X2,2)/2);
% pcaX2=X2*newall_improved_traj_coeff2;
% [all_improved_traj_coeff3, score3, latent3, tsquare3] = princomp(X3);
% newall_improved_traj_coeff3=all_improved_traj_coeff3(:,1:size(X3,2)/2);
% pcaX3=X3*newall_improved_traj_coeff3;
% [all_improved_traj_coeff4, score4, latent4, tsquare4] = princomp(X4);
% newall_improved_traj_coeff4=all_improved_traj_coeff4(:,1:size(X4,2)/2);
% pcaX4=X4*newall_improved_traj_coeff4;
% [all_improved_traj_coeff5, score5, latent5, tsquare5] = princomp(X5);
% newall_improved_traj_coeff5=all_improved_traj_coeff5(:,1:size(X5,2)/2);
% pcaX5=X5*newall_improved_traj_coeff5;
% [all_improved_traj_coeff6, score6, latent6, tsquare6] = princomp(X6);
% newall_improved_traj_coeff6=all_improved_traj_coeff6(:,1:size(X6,2)/2);
% pcaX6=X6*newall_improved_traj_coeff6;
% 
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff1.mat',conf.modelpath),'newall_improved_traj_coeff1');
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff2.mat',conf.modelpath),'newall_improved_traj_coeff2');
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff3.mat',conf.modelpath),'newall_improved_traj_coeff3');
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff4.mat',conf.modelpath),'newall_improved_traj_coeff4');
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff5.mat',conf.modelpath),'newall_improved_traj_coeff5');
% save(sprintf('%s\\all_improved_traj_all_improved_traj_coeff6.mat',conf.modelpath),'newall_improved_traj_coeff6');
% 
% % train GMM model
% [means, covariances, priors] = vl_gmm(pcaX1',numclusters);
% model1.means=means;
% model1.covariances=covariances;
% model1.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX2',numclusters);
% model2.means=means;
% model2.covariances=covariances;
% model2.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX3',numclusters);
% model3.means=means;
% model3.covariances=covariances;
% model3.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX4',numclusters);
% model4.means=means;
% model4.covariances=covariances;
% model4.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX5',numclusters);
% model5.means=means;
% model5.covariances=covariances;
% model5.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX6',numclusters);
% model6.means=means;
% model6.covariances=covariances;
% model6.priors=priors;
% 
% %save GMM model
% save(sprintf('%s\\all_improved_traj_model1.mat',conf.modelpath),'model1');
% save(sprintf('%s\\all_improved_traj_model2.mat',conf.modelpath),'model2');
% save(sprintf('%s\\all_improved_traj_model3.mat',conf.modelpath),'model3');
% save(sprintf('%s\\all_improved_traj_model4.mat',conf.modelpath),'model4');
% save(sprintf('%s\\all_improved_traj_model5.mat',conf.modelpath),'model5');
% save(sprintf('%s\\all_improved_traj_model6.mat',conf.modelpath),'model6');
% turn into fisher vector
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j); 
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        
        X = X(logical(outindex'),:);
        
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        
        % pca
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        
        % encoding
        encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
        encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
        encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
        encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
        encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
        % normalize by power
        s1=zeros(size(encoding.traj,1),1);
        s1=sign(encoding.traj(:,1));
        encoding.traj=s1.*sqrt(abs(encoding.traj(:,1)));
        s2=zeros(size(encoding.hog,1),1);
        s2=sign(encoding.hog(:,1));
        encoding.hog=s2.*sqrt(abs(encoding.hog(:,1)));
        s3=zeros(size(encoding.hof,1),1);
        s3=sign(encoding.hof(:,1));
        encoding.hof=s3.*sqrt(abs(encoding.hof(:,1)));
        s4=zeros(size(encoding.mbhx,1),1);
        s4=sign(encoding.mbhx(:,1));
        encoding.mbhx=s4.*sqrt(abs(encoding.mbhx(:,1)));
        s5=zeros(size(encoding.mbhy,1),1);
        s5=sign(encoding.mbhy(:,1));
        encoding.mbhy=s5.*sqrt(abs(encoding.mbhy(:,1)));
        % normalize by L2
        encoding.traj=encoding.traj/norm(encoding.traj);
        encoding.hog=encoding.hog/norm(encoding.hog);
        encoding.hof=encoding.hof/norm(encoding.hof);
        encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
        encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
        
        % save fisher vector
        save(sprintf('%s\\encoding\\seperate_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j); 
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        
        X = X(logical(outindex'),:);
        
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        
        % pca
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        
        % encoding
        encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
        encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
        encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
        encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
        encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
        % normalize by power
        s1=zeros(size(encoding.traj,1),1);
        s1=sign(encoding.traj(:,1));
        encoding.traj=s1.*sqrt(abs(encoding.traj(:,1)));
        s2=zeros(size(encoding.hog,1),1);
        s2=sign(encoding.hog(:,1));
        encoding.hog=s2.*sqrt(abs(encoding.hog(:,1)));
        s3=zeros(size(encoding.hof,1),1);
        s3=sign(encoding.hof(:,1));
        encoding.hof=s3.*sqrt(abs(encoding.hof(:,1)));
        s4=zeros(size(encoding.mbhx,1),1);
        s4=sign(encoding.mbhx(:,1));
        encoding.mbhx=s4.*sqrt(abs(encoding.mbhx(:,1)));
        s5=zeros(size(encoding.mbhy,1),1);
        s5=sign(encoding.mbhy(:,1));
        encoding.mbhy=s5.*sqrt(abs(encoding.mbhy(:,1)));
        % normalize by L2
        encoding.traj=encoding.traj/norm(encoding.traj);
        encoding.hog=encoding.hog/norm(encoding.hog);
        encoding.hof=encoding.hof/norm(encoding.hof);
        encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
        encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
        
        % save fisher vector
        save(sprintf('%s\\encoding\\seperate_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end
rmpath(genpath(conf.vlfeatpath));
end

