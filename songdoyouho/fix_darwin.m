actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

addpath(genpath(conf.liblinear));
addpath(genpath(conf.videodarwin));
addpath(genpath(conf.vlfeatpath));
vl_setup

% load GMM model
load(sprintf('%s\\TVL1_model1.mat',conf.modelpath));
load(sprintf('%s\\TVL1_model2.mat',conf.modelpath));
load(sprintf('%s\\TVL1_model3.mat',conf.modelpath));
load(sprintf('%s\\TVL1_model4.mat',conf.modelpath));
load(sprintf('%s\\TVL1_model5.mat',conf.modelpath));
load(sprintf('%s\\TVL1_model6.mat',conf.modelpath));
% load pca
load(sprintf('%s\\TVL1_coeff1.mat',conf.modelpath));
load(sprintf('%s\\TVL1_coeff2.mat',conf.modelpath));
load(sprintf('%s\\TVL1_coeff3.mat',conf.modelpath));
load(sprintf('%s\\TVL1_coeff4.mat',conf.modelpath));
load(sprintf('%s\\TVL1_coeff5.mat',conf.modelpath));
load(sprintf('%s\\TVL1_coeff6.mat',conf.modelpath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        
        allencoding=[];
        endframe = X(size(X,1),1);
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:21);
                X6=tmpX(:,22:41);
                % normalize displacement
                % abs_X6 = abs(X6);
                % sum_X6 = sum(abs_X6,2);
                % for iii = 1:size(X6,1)
                %     X6(iii,:) = X6(iii,:)/sum_X6(iii,1);
                % end
                
                X2=tmpX(:,42:137);
                X3=tmpX(:,138:245);
                X4=tmpX(:,246:341);
                X5=tmpX(:,342:437);
                %                 X1=tmpX(:,2:31);
                %                 X2=tmpX(:,32:127);
                %                 X3=tmpX(:,128:235);
                %                 X4=tmpX(:,236:331);
                %                 X5=tmpX(:,332:427);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                pcaX6=X6*newcoeff6;
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
                tmpE = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
                E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        
		% save the result
        save(sprintf('%s\\TVL1_allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        
		% run darwin algorithn for each descriptor
        traj_W1 = VideoDarwin(allencoding(:,1:5120));
        traj_W1 = traj_W1';
        hog_W1 = VideoDarwin(allencoding(:,5121:29696));
        hog_W1 = hog_W1';
        hof_W1 = VideoDarwin(allencoding(:,29697:57344));
        hof_W1 = hof_W1';
        mbhx_W1 = VideoDarwin(allencoding(:,57345:81920));
        mbhx_W1 = mbhx_W1';
        mbhy_W1 = VideoDarwin(allencoding(:,81921:106496));
        mbhy_W1 = mbhy_W1';
        disp_W1 = VideoDarwin(allencoding(:,106497:111616));
        disp_W1 = disp_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        W1.disp_W1 = disp_W1;
        
        save(sprintf('%s\\TVL1_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load feature
        load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        
        allencoding=[];
        endframe = X(size(X,1),1);
        for k=1:endframe
            % take this frame's feature out
            index=X(:,1)==k;
            tmpX=X(index,:);
            check=isempty(tmpX);
            if check~=1
                X1=tmpX(:,2:21);
                X6=tmpX(:,22:41);
                % normalize displacement
                % abs_X6 = abs(X6);
                % sum_X6 = sum(abs_X6,2);
                % for iii = 1:size(X6,1)
                %     X6(iii,:) = X6(iii,:)/sum_X6(iii,1);
                % end
                
                X2=tmpX(:,42:137);
                X3=tmpX(:,138:245);
                X4=tmpX(:,246:341);
                X5=tmpX(:,342:437);
                %                 X1=tmpX(:,2:31);
                %                 X2=tmpX(:,32:127);
                %                 X3=tmpX(:,128:235);
                %                 X4=tmpX(:,236:331);
                %                 X5=tmpX(:,332:427);
                % PCA
                pcaX1=X1*newcoeff1;
                pcaX2=X2*newcoeff2;
                pcaX3=X3*newcoeff3;
                pcaX4=X4*newcoeff4;
                pcaX5=X5*newcoeff5;
                pcaX6=X6*newcoeff6;
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
                tmpE = vl_fisher(pcaX6', model6.means, model6.covariances, model6.priors);
                E=[E tmpE'];
                
                allencoding = [allencoding; E];
            end
        end
        
        save(sprintf('%s\\TVL1_allencoding\\allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        
        traj_W1 = VideoDarwin(allencoding(:,1:5120));
        traj_W1 = traj_W1';
        hog_W1 = VideoDarwin(allencoding(:,5121:29696));
        hog_W1 = hog_W1';
        hof_W1 = VideoDarwin(allencoding(:,29697:57344));
        hof_W1 = hof_W1';
        mbhx_W1 = VideoDarwin(allencoding(:,57345:81920));
        mbhx_W1 = mbhx_W1';
        mbhy_W1 = VideoDarwin(allencoding(:,81921:106496));
        mbhy_W1 = mbhy_W1';
        disp_W1 = VideoDarwin(allencoding(:,106497:111616));
        disp_W1 = disp_W1';
        W1.traj_W1 = traj_W1;
        W1.hog_W1 = hog_W1;
        W1.hof_W1 = hof_W1;
        W1.mbhx_W1 = mbhx_W1;
        W1.mbhy_W1 = mbhy_W1;
        W1.disp_W1 = disp_W1;
        
        save(sprintf('%s\\TVL1_W1\\W1%d_%d.mat',conf.tmppath,vi,j),'W1');
    end
end

rmpath(genpath(conf.liblinear));
rmpath(genpath(conf.videodarwin));
rmpath(genpath(conf.vlfeatpath));