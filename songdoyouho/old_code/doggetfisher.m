function [] = doggetfisher( conf, flag )
%FISHER Summary of this function goes here
%Detailed explanation goes here
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
featurenum=fix(256000/102);
% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup

% for training
if(strcmp(flag, 'train'))
    %XXX=[];
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            % load features
            load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
            fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);              
            %             load(sprintf('%s\\finalX%d_%d.mat', conf.tmppath, vi, j));
            %             fprintf('%s\\finalX%d_%d.mat\n', conf.tmppath, vi, j);
            %             X=finalX;
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
    
    X1=XXX(:,2:31);
    X2=XXX(:,32:127);
    X3=XXX(:,128:235);
    X4=XXX(:,236:331);
    X5=XXX(:,332:427);
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
    % save pca coeff
    save(sprintf('%s\\newcoeff1.mat',conf.modelpath),'newcoeff1');
    save(sprintf('%s\\newcoeff2.mat',conf.modelpath),'newcoeff2');
    save(sprintf('%s\\newcoeff3.mat',conf.modelpath),'newcoeff3');
    save(sprintf('%s\\newcoeff4.mat',conf.modelpath),'newcoeff4');
    save(sprintf('%s\\newcoeff5.mat',conf.modelpath),'newcoeff5');
    
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
    
    %save GMM model
    save(sprintf('%s\\model1.mat',conf.modelpath),'model1');
    save(sprintf('%s\\model2.mat',conf.modelpath),'model2');
    save(sprintf('%s\\model3.mat',conf.modelpath),'model3');
    save(sprintf('%s\\model4.mat',conf.modelpath),'model4');
    save(sprintf('%s\\model5.mat',conf.modelpath),'model5');
    
    % turn into fisher vector
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            X1=[];
            X2=[];
            X3=[];
            X4=[];
            X5=[];
            X6=[];
            pcaX1=[];
            pcaX2=[];
            pcaX3=[];
            pcaX4=[];
            pcaX5=[];
            pcaX6=[];
            % load features
            load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
            fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
            
            %            load(sprintf('%s\\finalX%d_%d.mat', conf.tmppath, vi, j));
            %            fprintf('%s\\finalX%d_%d.mat\n', conf.tmppath, vi, j);
            %            X=finalX;
            % 存剩下的 features
            save(sprintf('%s\\index%d_%d.mat',conf.tmppath,vi,j),'X');
            X1=X(:,2:31);
            X2=X(:,32:127);
            X3=X(:,128:235);
            X4=X(:,236:331);
            X5=X(:,332:427);
            
            % pca
            load(sprintf('%s\\newcoeff1.mat',conf.modelpath));
            pcaX1=X1*newcoeff1;
            load(sprintf('%s\\newcoeff2.mat',conf.modelpath));
            pcaX2=X2*newcoeff2;
            load(sprintf('%s\\newcoeff3.mat',conf.modelpath));
            pcaX3=X3*newcoeff3;
            load(sprintf('%s\\newcoeff4.mat',conf.modelpath));
            pcaX4=X4*newcoeff4;
            load(sprintf('%s\\newcoeff5.mat',conf.modelpath));
            pcaX5=X5*newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
            encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
            encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
            % save fisher vector
            save(sprintf('%s\\encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
        end
    end
    rmpath(genpath(conf.vlfeatpath));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for testing
if(strcmp(flag, 'test'))
    %save GMM model
    load(sprintf('%s\\model1.mat',conf.modelpath),'model1');
    load(sprintf('%s\\model2.mat',conf.modelpath),'model2');
    load(sprintf('%s\\model3.mat',conf.modelpath),'model3');
    load(sprintf('%s\\model4.mat',conf.modelpath),'model4');
    load(sprintf('%s\\model5.mat',conf.modelpath),'model5');
    
    % turn into fisher vector
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            X1=[];
            X2=[];
            X3=[];
            X4=[];
            X5=[];
            pcaX1=[];
            pcaX2=[];
            pcaX3=[];
            pcaX4=[];
            pcaX5=[];
            % load features
            load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
            fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
            
            %            load(sprintf('%s\\finalX%d_%d.mat', conf.tmppath, vi, j));
            %            fprintf('%s\\finalX%d_%d.mat\n', conf.tmppath, vi, j);
            %            X=finalX;
            % 存剩下的 features
            save(sprintf('%s\\index%d_%d.mat',conf.tmppath,vi,j),'X');
            X1=X(:,2:31);
            X2=X(:,32:127);
            X3=X(:,128:235);
            X4=X(:,236:331);
            X5=X(:,332:427);
            
            % pca
            load(sprintf('%s\\newcoeff1.mat',conf.modelpath));
            pcaX1=X1*newcoeff1;
            load(sprintf('%s\\newcoeff2.mat',conf.modelpath));
            pcaX2=X2*newcoeff2;
            load(sprintf('%s\\newcoeff3.mat',conf.modelpath));
            pcaX3=X3*newcoeff3;
            load(sprintf('%s\\newcoeff4.mat',conf.modelpath));
            pcaX4=X4*newcoeff4;
            load(sprintf('%s\\newcoeff5.mat',conf.modelpath));
            pcaX5=X5*newcoeff5;
            
            % encoding
            encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
            encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
            encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
            encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
            encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
            % save fisher vector
            save(sprintf('%s\\encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');
        end
    end
end
rmpath(genpath(conf.vlfeatpath));
end

