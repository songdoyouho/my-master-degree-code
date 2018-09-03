actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

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
        load(sprintf('%s\\prX\\prX%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\prX\\prX%d_%d.mat\n', conf.videopath, vi, j);
        startframe=prX(1,1);
        endframe=prX(size(prX,1),1);
        
        allencoding=[];
        timevarymean=[];
        meanminus=[];
        for k=1:endframe
            % take this frame's feature out
            index=prX(:,1)==k;
            tmpX=prX(index,:);
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
                pcaX2=pcaX2/norm(pcaX2);
                tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                E=[E tmpE'];
                pcaX3=pcaX3/norm(pcaX3);
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
                pcaX4=pcaX4/norm(pcaX4);
                tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                E=[E tmpE'];
                pcaX5=pcaX5/norm(pcaX5);
                tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                E=[E tmpE'];
                
                allencoding = [allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
            end
        end
        save(sprintf('%s\\pr_allencoding\\pr_allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\pr_timevarymean\\pr_timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');        W1 = VideoDarwin(allencoding);
        W1 = W1';
        save(sprintf('%s\\pr_W1\\pr_W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        W2 = VideoDarwin(timevarymean);
        W2 = W2';
        save(sprintf('%s\\pr_W2\\pr_W2%d_%d.mat',conf.tmppath,vi,j),'W2');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\prX\\prX%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\prX\\prX%d_%d.mat\n', conf.videopath, vi, j);
        startframe=prX(1,1);
        endframe=prX(size(prX,1),1);
        
        allencoding=[];
        timevarymean=[];
        meanminus=[];
        for k=1:endframe
            % take this frame's feature out
            index=prX(:,1)==k;
            tmpX=prX(index,:);
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
                % encoding fisher vector
                E=[];
                tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
                E=[E tmpE'];
                pcaX2=pcaX2/norm(pcaX2);
                tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                E=[E tmpE'];
                pcaX3=pcaX3/norm(pcaX3);
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
                pcaX4=pcaX4/norm(pcaX4);
                tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                E=[E tmpE'];
                pcaX5=pcaX5/norm(pcaX5);
                tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                E=[E tmpE'];
                
                allencoding=[allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
            end
        end
        save(sprintf('%s\\pr_allencoding\\pr_allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\pr_timevarymean\\pr_timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');
        W1 = VideoDarwin(allencoding);
        W1 = W1';
        save(sprintf('%s\\pr_W1\\pr_W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        W2 = VideoDarwin(timevarymean);
        W2 = W2';
        save(sprintf('%s\\pr_W2\\pr_W2%d_%d.mat',conf.tmppath,vi,j),'W2');
    end
end

