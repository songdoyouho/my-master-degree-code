actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
featurenum=fix(256000/videonumber);

% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup

local_XXX=[];
global_XXX=[];
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        local_X = X(outindex',:);
        global_X = X(not(outindex'),:);
        
        % select feature for training GMM
        if size(local_X,1)<featurenum
            local_XXX=[local_XXX; local_X];
        else
            idid=randperm(size(local_X,1),featurenum);
            X_idx = 1:size(local_X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            local_X = local_X(idx,:);
            local_XXX=[local_XXX; local_X];
        end
        if size(global_X,1)<featurenum
            global_XXX=[global_XXX; global_X];
        else
            idid=randperm(size(global_X,1),featurenum);
            X_idx = 1:size(global_X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            global_X = global_X(idx,:);
            global_XXX=[global_XXX; global_X];
        end
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        local_X = X(outindex',:);
        global_X = X(not(outindex'),:);
        
        % select feature for training GMM
        if size(local_X,1)<featurenum
            local_XXX=[local_XXX; local_X];
        else
            idid=randperm(size(local_X,1),featurenum);
            X_idx = 1:size(local_X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            local_X = local_X(idx,:);
            local_XXX=[local_XXX; local_X];
        end
        if size(global_X,1)<featurenum
            global_XXX=[global_XXX; global_X];
        else
            idid=randperm(size(global_X,1),featurenum);
            X_idx = 1:size(global_X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            global_X = global_X(idx,:);
            global_XXX=[global_XXX; global_X];
        end
    end
end

X1=local_XXX(:,2:31);
X2=local_XXX(:,32:127);
X3=local_XXX(:,128:235);
X4=local_XXX(:,236:331);
X5=local_XXX(:,332:427);
% pca for each features
[coeff1, score1, latent1, tsquare1] = princomp(X1);
local_newcoeff1=coeff1(:,1:size(X1,2)/2);
local_pcaX1=X1*local_newcoeff1;
[coeff2, score2, latent2, tsquare2] = princomp(X2);
local_newcoeff2=coeff2(:,1:size(X2,2)/2);
local_pcaX2=X2*local_newcoeff2;
[coeff3, score3, latent3, tsquare3] = princomp(X3);
local_newcoeff3=coeff3(:,1:size(X3,2)/2);
local_pcaX3=X3*local_newcoeff3;
[coeff4, score4, latent4, tsquare4] = princomp(X4);
local_newcoeff4=coeff4(:,1:size(X4,2)/2);
local_pcaX4=X4*local_newcoeff4;
[coeff5, score5, latent5, tsquare5] = princomp(X5);
local_newcoeff5=coeff5(:,1:size(X5,2)/2);
local_pcaX5=X5*local_newcoeff5;

save(sprintf('%s\\local_coeff1.mat',conf.modelpath),'local_newcoeff1');
save(sprintf('%s\\local_coeff2.mat',conf.modelpath),'local_newcoeff2');
save(sprintf('%s\\local_coeff3.mat',conf.modelpath),'local_newcoeff3');
save(sprintf('%s\\local_coeff4.mat',conf.modelpath),'local_newcoeff4');
save(sprintf('%s\\local_coeff5.mat',conf.modelpath),'local_newcoeff5');

% train GMM model
[means, covariances, priors] = vl_gmm(local_pcaX1',64);
local_model1.means=means;
local_model1.covariances=covariances;
local_model1.priors=priors;
[means, covariances, priors] = vl_gmm(local_pcaX2',64);
local_model2.means=means;
local_model2.covariances=covariances;
local_model2.priors=priors;
[means, covariances, priors] = vl_gmm(local_pcaX3',64);
local_model3.means=means;
local_model3.covariances=covariances;
local_model3.priors=priors;
[means, covariances, priors] = vl_gmm(local_pcaX4',64);
local_model4.means=means;
local_model4.covariances=covariances;
local_model4.priors=priors;
[means, covariances, priors] = vl_gmm(local_pcaX5',64);
local_model5.means=means;
local_model5.covariances=covariances;
local_model5.priors=priors;

%save GMM model
save(sprintf('%s\\local_model1.mat',conf.modelpath),'local_model1');
save(sprintf('%s\\local_model2.mat',conf.modelpath),'local_model2');
save(sprintf('%s\\local_model3.mat',conf.modelpath),'local_model3');
save(sprintf('%s\\local_model4.mat',conf.modelpath),'local_model4');
save(sprintf('%s\\local_model5.mat',conf.modelpath),'local_model5');

X1=global_XXX(:,2:31);
X2=global_XXX(:,32:127);
X3=global_XXX(:,128:235);
X4=global_XXX(:,236:331);
X5=global_XXX(:,332:427);
% pca for each features
[coeff1, score1, latent1, tsquare1] = princomp(X1);
global_newcoeff1=coeff1(:,1:size(X1,2)/2);
global_pcaX1=X1*global_newcoeff1;
[coeff2, score2, latent2, tsquare2] = princomp(X2);
global_newcoeff2=coeff2(:,1:size(X2,2)/2);
global_pcaX2=X2*global_newcoeff2;
[coeff3, score3, latent3, tsquare3] = princomp(X3);
global_newcoeff3=coeff3(:,1:size(X3,2)/2);
global_pcaX3=X3*global_newcoeff3;
[coeff4, score4, latent4, tsquare4] = princomp(X4);
global_newcoeff4=coeff4(:,1:size(X4,2)/2);
global_pcaX4=X4*global_newcoeff4;
[coeff5, score5, latent5, tsquare5] = princomp(X5);
global_newcoeff5=coeff5(:,1:size(X5,2)/2);
global_pcaX5=X5*global_newcoeff5;

save(sprintf('%s\\global_coeff1.mat',conf.modelpath),'global_newcoeff1');
save(sprintf('%s\\global_coeff2.mat',conf.modelpath),'global_newcoeff2');
save(sprintf('%s\\global_coeff3.mat',conf.modelpath),'global_newcoeff3');
save(sprintf('%s\\global_coeff4.mat',conf.modelpath),'global_newcoeff4');
save(sprintf('%s\\global_coeff5.mat',conf.modelpath),'global_newcoeff5');

% train GMM model
[means, covariances, priors] = vl_gmm(global_pcaX1',numclusters);
global_model1.means=means;
global_model1.covariances=covariances;
global_model1.priors=priors;
[means, covariances, priors] = vl_gmm(global_pcaX2',numclusters);
global_model2.means=means;
global_model2.covariances=covariances;
global_model2.priors=priors;
[means, covariances, priors] = vl_gmm(global_pcaX3',numclusters);
global_model3.means=means;
global_model3.covariances=covariances;
global_model3.priors=priors;
[means, covariances, priors] = vl_gmm(global_pcaX4',numclusters);
global_model4.means=means;
global_model4.covariances=covariances;
global_model4.priors=priors;
[means, covariances, priors] = vl_gmm(global_pcaX5',numclusters);
global_model5.means=means;
global_model5.covariances=covariances;
global_model5.priors=priors;

%save GMM model
save(sprintf('%s\\global_model1.mat',conf.modelpath),'global_model1');
save(sprintf('%s\\global_model2.mat',conf.modelpath),'global_model2');
save(sprintf('%s\\global_model3.mat',conf.modelpath),'global_model3');
save(sprintf('%s\\global_model4.mat',conf.modelpath),'global_model4');
save(sprintf('%s\\global_model5.mat',conf.modelpath),'global_model5');


% turn into fisher vector
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        
        local_X = X(outindex',:);
        global_X = X(not(outindex'),:);
        
        if isempty(local_X)
            local_encoding.traj = zeros(1920,1);
            local_encoding.hog = zeros(6144,1);
            local_encoding.hof = zeros(6912,1);
            local_encoding.mbhx = zeros(6144,1);
            local_encoding.mbhy = zeros(6144,1);
        else
            
            X1=local_X(:,2:31);
            X2=local_X(:,32:127);
            X3=local_X(:,128:235);
            X4=local_X(:,236:331);
            X5=local_X(:,332:427);
            
            % pca
            pcaX1=X1*local_newcoeff1;
            pcaX2=X2*local_newcoeff2;
            pcaX3=X3*local_newcoeff3;
            pcaX4=X4*local_newcoeff4;
            pcaX5=X5*local_newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', local_model1.means, local_model1.covariances, local_model1.priors);
            encoding.hog = vl_fisher(pcaX2', local_model2.means, local_model2.covariances, local_model2.priors);
            encoding.hof = vl_fisher(pcaX3', local_model3.means, local_model3.covariances, local_model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', local_model4.means, local_model4.covariances, local_model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', local_model5.means, local_model5.covariances, local_model5.priors);
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
            local_encoding.traj=encoding.traj/norm(encoding.traj);
            local_encoding.hog=encoding.hog/norm(encoding.hog);
            local_encoding.hof=encoding.hof/norm(encoding.hof);
            local_encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
            local_encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
            
            clear encoding;
        end
        
        if isempty(global_X)
            global_encoding.traj = zeros(7680,1);
            global_encoding.hog = zeros(24576,1);
            global_encoding.hof = zeros(27648,1);
            global_encoding.mbhx = zeros(24576,1);
            global_encoding.mbhy = zeros(24576,1);
        else
            X1=global_X(:,2:31);
            X2=global_X(:,32:127);
            X3=global_X(:,128:235);
            X4=global_X(:,236:331);
            X5=global_X(:,332:427);
            
            % pca
            pcaX1=X1*global_newcoeff1;
            pcaX2=X2*global_newcoeff2;
            pcaX3=X3*global_newcoeff3;
            pcaX4=X4*global_newcoeff4;
            pcaX5=X5*global_newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', global_model1.means, global_model1.covariances, global_model1.priors);
            encoding.hog = vl_fisher(pcaX2', global_model2.means, global_model2.covariances, global_model2.priors);
            encoding.hof = vl_fisher(pcaX3', global_model3.means, global_model3.covariances, global_model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', global_model4.means, global_model4.covariances, global_model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', global_model5.means, global_model5.covariances, global_model5.priors);
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
            global_encoding.traj=encoding.traj/norm(encoding.traj);
            global_encoding.hog=encoding.hog/norm(encoding.hog);
            global_encoding.hof=encoding.hof/norm(encoding.hof);
            global_encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
            global_encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
            
            clear encoding;
        end
        encoding.traj = [local_encoding.traj; global_encoding.traj];
        encoding.hog = [local_encoding.hog; global_encoding.hog];
        encoding.hof = [local_encoding.hof; global_encoding.hof];
        encoding.mbhx = [local_encoding.mbhx; global_encoding.mbhx];
        encoding.mbhy = [local_encoding.mbhy; global_encoding.mbhy];
        
        % save fisher vector
        save(sprintf('%s\\encoding\\seperate_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        
        local_X = X(outindex',:);
        global_X = X(not(outindex'),:);
        
        if isempty(local_X)
            local_encoding.traj = zeros(1920,1);
            local_encoding.hog = zeros(6144,1);
            local_encoding.hof = zeros(6912,1);
            local_encoding.mbhx = zeros(6144,1);
            local_encoding.mbhy = zeros(6144,1);
        else
            
            X1=local_X(:,2:31);
            X2=local_X(:,32:127);
            X3=local_X(:,128:235);
            X4=local_X(:,236:331);
            X5=local_X(:,332:427);
            
            % pca
            pcaX1=X1*local_newcoeff1;
            pcaX2=X2*local_newcoeff2;
            pcaX3=X3*local_newcoeff3;
            pcaX4=X4*local_newcoeff4;
            pcaX5=X5*local_newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', local_model1.means, local_model1.covariances, local_model1.priors);
            encoding.hog = vl_fisher(pcaX2', local_model2.means, local_model2.covariances, local_model2.priors);
            encoding.hof = vl_fisher(pcaX3', local_model3.means, local_model3.covariances, local_model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', local_model4.means, local_model4.covariances, local_model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', local_model5.means, local_model5.covariances, local_model5.priors);
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
            local_encoding.traj=encoding.traj/norm(encoding.traj);
            local_encoding.hog=encoding.hog/norm(encoding.hog);
            local_encoding.hof=encoding.hof/norm(encoding.hof);
            local_encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
            local_encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
            
            clear encoding;
        end
        
        if isempty(global_X)
            global_encoding.traj = zeros(7680,1);
            global_encoding.hog = zeros(24576,1);
            global_encoding.hof = zeros(27648,1);
            global_encoding.mbhx = zeros(24576,1);
            global_encoding.mbhy = zeros(24576,1);
        else
            X1=global_X(:,2:31);
            X2=global_X(:,32:127);
            X3=global_X(:,128:235);
            X4=global_X(:,236:331);
            X5=global_X(:,332:427);
            
            % pca
            pcaX1=X1*global_newcoeff1;
            pcaX2=X2*global_newcoeff2;
            pcaX3=X3*global_newcoeff3;
            pcaX4=X4*global_newcoeff4;
            pcaX5=X5*global_newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', global_model1.means, global_model1.covariances, global_model1.priors);
            encoding.hog = vl_fisher(pcaX2', global_model2.means, global_model2.covariances, global_model2.priors);
            encoding.hof = vl_fisher(pcaX3', global_model3.means, global_model3.covariances, global_model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', global_model4.means, global_model4.covariances, global_model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', global_model5.means, global_model5.covariances, global_model5.priors);
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
            global_encoding.traj=encoding.traj/norm(encoding.traj);
            global_encoding.hog=encoding.hog/norm(encoding.hog);
            global_encoding.hof=encoding.hof/norm(encoding.hof);
            global_encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
            global_encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
            
            clear encoding;
        end
        encoding.traj = [local_encoding.traj; global_encoding.traj];
        encoding.hog = [local_encoding.hog; global_encoding.hog];
        encoding.hof = [local_encoding.hof; global_encoding.hof];
        encoding.mbhx = [local_encoding.mbhx; global_encoding.mbhx];
        encoding.mbhy = [local_encoding.mbhy; global_encoding.mbhy];
        
        % save fisher vector
        save(sprintf('%s\\encoding\\seperate_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end
rmpath(genpath(conf.vlfeatpath));


