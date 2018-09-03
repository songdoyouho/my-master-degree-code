actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
featurenum=fix(256000/videonumber);

% add vlfeat path
addpath(genpath(conf.liblinear));
addpath(genpath(conf.videodarwin));
addpath(genpath(conf.vlfeatpath));
vl_setup

% get random features
% XXX=[];
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
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
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
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
% X1=XXX(:,2:31); % location
% X2=XXX(:,32:127); % hog
% X3=XXX(:,128:235); % hof 
% X4=XXX(:,236:331); % mbhx
% X5=XXX(:,332:427); % mbhy
% 
% % PCA
% [coeff3, score3, latent3, tsquare3] = princomp(X3);
% newcoeff3=coeff3(:,1:size(X3,2)/2);
% pcaX3=X3*newcoeff3;
% save(sprintf('%s\\newcoeff3.mat',conf.modelpath),'newcoeff3');
% 
% [means, covariances, priors] = vl_gmm(pcaX3',64); % K = 64
% model3.means=means;
% model3.covariances=covariances;
% model3.priors=priors;
% save(sprintf('%s\\newmodel3.mat',conf.modelpath),'model3');

% load GMM model
% load(sprintf('%s\\model1.mat',conf.modelpath));
% load(sprintf('%s\\model2.mat',conf.modelpath));
load(sprintf('%s\\newmodel3.mat',conf.modelpath));
% load(sprintf('%s\\model4.mat',conf.modelpath));
% load(sprintf('%s\\model5.mat',conf.modelpath));
% load pca
% load(sprintf('%s\\coeff1.mat',conf.modelpath));
% load(sprintf('%s\\coeff2.mat',conf.modelpath));
load(sprintf('%s\\newcoeff3.mat',conf.modelpath));
% load(sprintf('%s\\coeff4.mat',conf.modelpath));
% load(sprintf('%s\\coeff5.mat',conf.modelpath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        
        allencoding=[];
        timevarymean=[];
        movingaverage=[];
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
%                 X1=tmpX(:,2:31);
%                 X2=tmpX(:,32:127);
                X3=tmpX(:,128:235);
%                 X4=tmpX(:,236:331);
%                 X5=tmpX(:,332:427);
                % PCA
%                 pcaX1=X1*newcoeff1;
%                 pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
%                 pcaX4=X4*newcoeff4;
%                 pcaX5=X5*newcoeff5;
                % encoding fisher vector and normalize
                E=[];                
%                 tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%                 E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%                 E=[E tmpE'];
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%                 E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
%                 E=[E tmpE'];
                
                allencoding = [allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
                allencoding = [allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
                if k <= 50
                    movingaverage=[movingaverage; mean];
                else
                    average=sum(allencoding(k-49:k,:)) / 50;
                    movingaverage=[movingaverage; average];
                end
            end
        end
        save(sprintf('%s\\64_allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\64_timevarymean\\timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');
        save(sprintf('%s\\64_movingaverage\\movingaverage%d_%d.mat',conf.tmppath,vi,j),'movingaverage');
        
        W1 = VideoDarwin(allencoding);
        clear allencoding;
        W1 = W1';
        save(sprintf('%s\\64_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        clear W1;
        W2 = VideoDarwin(timevarymean);
        clear timevarymean;
        W2 = W2';
        save(sprintf('%s\\64_W2\\W2%d_%d.mat',conf.tmppath,vi,j),'W2');
        clear W2;
        W3 = VideoDarwin(movingaverage);
        clear movingaverage;
        W3 = W3';
        save(sprintf('%s\\64_W3\\W3%d_%d.mat',conf.tmppath,vi,j),'W3');
        clear W3;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        
        allencoding=[];
        timevarymean=[];
        movingaverage=[];
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
%                 X1=tmpX(:,2:31);
%                 X2=tmpX(:,32:127);
                X3=tmpX(:,128:235);
%                 X4=tmpX(:,236:331);
%                 X5=tmpX(:,332:427);
                % PCA
%                 pcaX1=X1*newcoeff1;
%                 pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
%                 pcaX4=X4*newcoeff4;
%                 pcaX5=X5*newcoeff5;
                % encoding fisher vector
                E=[];
%                 tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%                 E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%                 E=[E tmpE'];
                tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%                 E=[E tmpE'];
%                 tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
%                 E=[E tmpE'];
                
                allencoding=[allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
                allencoding = [allencoding; E];
                mean = sum(allencoding,1) / size(allencoding,1);
                timevarymean = [timevarymean; mean];
                if k <= 65
                    movingaverage=[movingaverage; mean];
                else
                    average=sum(allencoding(k-49:k,:)) / 50;
                    movingaverage=[movingaverage; average];
                end
            end
        end
        save(sprintf('%s\\64_allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\64_timevarymean\\timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');
        save(sprintf('%s\\64_movingaverage\\movingaverage%d_%d.mat',conf.tmppath,vi,j),'movingaverage');
        
        W1 = VideoDarwin(allencoding);
        clear allencoding;
        W1 = W1';
        save(sprintf('%s\\64_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
        clear W1;
        W2 = VideoDarwin(timevarymean);
        clear timevarymean;
        W2 = W2';
        save(sprintf('%s\\64_W2\\W2%d_%d.mat',conf.tmppath,vi,j),'W2');
        clear W2;
        W3 = VideoDarwin(movingaverage);
        clear movingaverage;
        W3 = W3';
        save(sprintf('%s\\64_W3\\W3%d_%d.mat',conf.tmppath,vi,j),'W3');
        clear W3;
    end
end
rmpath(genpath(conf.liblinear));
rmpath(genpath(conf.videodarwin));
rmpath(genpath(conf.vlfeatpath));
