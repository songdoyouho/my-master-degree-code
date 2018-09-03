actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
featurenum=fix(256000/videonumber);
% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup

% for training
% load pca coeff
load(sprintf('%s\\coeff1.mat',conf.modelpath));
load(sprintf('%s\\coeff2.mat',conf.modelpath));
load(sprintf('%s\\coeff3.mat',conf.modelpath));
load(sprintf('%s\\coeff4.mat',conf.modelpath));
load(sprintf('%s\\coeff5.mat',conf.modelpath));

%load GMM model
load(sprintf('%s\\model1.mat',conf.modelpath));
load(sprintf('%s\\model2.mat',conf.modelpath));
load(sprintf('%s\\model3.mat',conf.modelpath));
load(sprintf('%s\\model4.mat',conf.modelpath));
load(sprintf('%s\\model5.mat',conf.modelpath));

% turn into fisher vector
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\prX\\prX%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\prX\\prX%d_%d.mat\n', conf.videopath, vi, j);
        X1=prX(:,2:31);
        X2=prX(:,32:127);
        X3=prX(:,128:235);
        X4=prX(:,236:331);
        X5=prX(:,332:427);
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
        save(sprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat',conf.tmppath, vi, j),'encoding');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for testing
% turn into fisher vector
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\prX\\prX%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\prX\\prX%d_%d.mat\n', conf.videopath, vi, j);;
        X1=prX(:,2:31);
        X2=prX(:,32:127);
        X3=prX(:,128:235);
        X4=prX(:,236:331);
        X5=prX(:,332:427);
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
        save(sprintf('%s\\prX_encoding\\prX_encoding%d_%d.mat', conf.tmppath, vi ,j),'encoding');
    end
end
rmpath(genpath(conf.vlfeatpath));


