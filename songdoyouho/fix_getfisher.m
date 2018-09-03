actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
featurenum=fix(256000/videonumber);

% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup

% get random features
XXX=[];
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % select feature for training GMM
        if size(X,1)<featurenum
            XXX=[XXX; X];
        else
            idid=randperm(size(X,1),featurenum);
            X_idx = 1:size(X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            X = X(idx,:);
            XXX=[XXX; X];
        end
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % select feature for training GMM
        if size(X,1)<featurenum
            XXX=[XXX; X];
        else
            idid=randperm(size(X,1),featurenum);
            X_idx = 1:size(X,1);
            idx = ismember(X_idx,idid);
            idx=idx';
            X = X(idx,:);
            XXX=[XXX; X];
        end
    end
end

X1=XXX(:,2:21);
X6=XXX(:,22:41);
% normalize displacement
% abs_X6 = abs(X6);
% sum_X6 = sum(abs_X6,2);
% for iii = 1:size(X6,1)
%     X6(iii,:) = X6(iii,:)/sum_X6(iii,1);
% end

X2=XXX(:,42:137);
X3=XXX(:,138:245);
X4=XXX(:,246:341);
X5=XXX(:,342:437);
% pca for each features
[coeff1, score1, latent1, tsquare1] = princomp(X1);
newcoeff1=coeff1(:,1:size(X1,2)/2);
pcaX1=X1*newcoeff1;
[coeff2, score2, latent2, tsquare2] = princomp(X2);
newcoeff2=coeff2(:,1:size(X2,2)/2);
pcaX2=X2*newcoeff2;
[coeff3, score3, latent3, tsquare3] = princomp(X3);
newcoeff3=coeff3(:,1:size(X3,2)/2);
pcaX3=X3*newcoeff3;
[coeff4, score4, latent4, tsquare4] = princomp(X4);
newcoeff4=coeff4(:,1:size(X4,2)/2);
pcaX4=X4*newcoeff4;
[coeff5, score5, latent5, tsquare5] = princomp(X5);
newcoeff5=coeff5(:,1:size(X5,2)/2);
pcaX5=X5*newcoeff5;
[coeff6, score6, latent6, tsquare6] = princomp(X6);
newcoeff6=coeff6(:,1:size(X6,2)/2);
pcaX6=X6*newcoeff6;

save(sprintf('%s\\TVL1_coeff1.mat',conf.modelpath),'newcoeff1');
save(sprintf('%s\\TVL1_coeff2.mat',conf.modelpath),'newcoeff2');
save(sprintf('%s\\TVL1_coeff3.mat',conf.modelpath),'newcoeff3');
save(sprintf('%s\\TVL1_coeff4.mat',conf.modelpath),'newcoeff4');
save(sprintf('%s\\TVL1_coeff5.mat',conf.modelpath),'newcoeff5');
save(sprintf('%s\\TVL1_coeff6.mat',conf.modelpath),'newcoeff6');

% train GMM model
[means, covariances, priors] = vl_gmm(pcaX1',numclusters);
model1.means=means;
model1.covariances=covariances;
model1.priors=priors;
[means, covariances, priors] = vl_gmm(pcaX2',numclusters);
model2.means=means;
model2.covariances=covariances;
model2.priors=priors;
[means, covariances, priors] = vl_gmm(pcaX3',numclusters);
model3.means=means;
model3.covariances=covariances;
model3.priors=priors;
[means, covariances, priors] = vl_gmm(pcaX4',numclusters);
model4.means=means;
model4.covariances=covariances;
model4.priors=priors;
[means, covariances, priors] = vl_gmm(pcaX5',numclusters);
model5.means=means;
model5.covariances=covariances;
model5.priors=priors;
[means, covariances, priors] = vl_gmm(pcaX6',numclusters);
model6.means=means;
model6.covariances=covariances;
model6.priors=priors;

%save GMM model
save(sprintf('%s\\TVL1_model1.mat',conf.modelpath),'model1');
save(sprintf('%s\\TVL1_model2.mat',conf.modelpath),'model2');
save(sprintf('%s\\TVL1_model3.mat',conf.modelpath),'model3');
save(sprintf('%s\\TVL1_model4.mat',conf.modelpath),'model4');
save(sprintf('%s\\TVL1_model5.mat',conf.modelpath),'model5');
save(sprintf('%s\\TVL1_model6.mat',conf.modelpath),'model6');

% load(sprintf('%s\\TVL1_coeff1.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_coeff2.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_coeff3.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_coeff4.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_coeff5.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_coeff6.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model1.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model2.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model3.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model4.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model5.mat',conf.modelpath));
% load(sprintf('%s\\TVL1_model6.mat',conf.modelpath));

% turn into fisher vector
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        X1=X(:,2:21);
        X6=X(:,22:41);
        % normalize displacement
        % abs_X6 = abs(X6);
        % sum_X6 = sum(abs_X6,2);
        % for iii = 1:size(X6,1)
        %     X6(iii,:) = X6(iii,:)/sum_X6(iii,1);
        % end
        
        X2=X(:,42:137);
        X3=X(:,138:245);
        X4=X(:,246:341);
        X5=X(:,342:437);
        
        % pca
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        pcaX6=X6*newcoeff6;
        
        % encoding
        encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
        encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
        encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
        encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
        encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
        encoding.disp = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
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
        s6=zeros(size(encoding.disp,1),1);
        s6=sign(encoding.disp(:,1));
        encoding.disp=s6.*sqrt(abs(encoding.disp(:,1)));
        
        % normalize by L2
        encoding.traj=encoding.traj/norm(encoding.traj);
        encoding.hog=encoding.hog/norm(encoding.hog);
        encoding.hof=encoding.hof/norm(encoding.hof);
        encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
        encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
        encoding.disp=encoding.disp/norm(encoding.disp);
        
        % save fisher vector
        save(sprintf('%s\\encoding\\TVL1_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end

% turn into fisher vector
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j); 
        X1=X(:,2:21);
        X6=X(:,22:41);
        % normalize displacement
        % abs_X6 = abs(X6);
        % sum_X6 = sum(abs_X6,2);
        % for iii = 1:size(X6,1)
        %     X6(iii,:) = X6(iii,:)/sum_X6(iii,1);
        % end
        
        X2=X(:,42:137);
        X3=X(:,138:245);
        X4=X(:,246:341);
        X5=X(:,342:437);
        
        % pca
        pcaX1=X1*newcoeff1;
        pcaX2=X2*newcoeff2;
        pcaX3=X3*newcoeff3;
        pcaX4=X4*newcoeff4;
        pcaX5=X5*newcoeff5;
        pcaX6=X6*newcoeff6;
        
        % encoding
        encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
        encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
        encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
        encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
        encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
        encoding.disp = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
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
        s6=zeros(size(encoding.disp,1),1);
        s6=sign(encoding.disp(:,1));
        encoding.disp=s6.*sqrt(abs(encoding.disp(:,1)));
        
        % normalize by L2
        encoding.traj=encoding.traj/norm(encoding.traj);
        encoding.hog=encoding.hog/norm(encoding.hog);
        encoding.hof=encoding.hof/norm(encoding.hof);
        encoding.mbhx=encoding.mbhx/norm(encoding.mbhx);
        encoding.mbhy=encoding.mbhy/norm(encoding.mbhy);
        encoding.disp=encoding.disp/norm(encoding.disp);
        
        % save fisher vector
        save(sprintf('%s\\encoding\\TVL1_encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
    end
end
rmpath(genpath(conf.vlfeatpath));