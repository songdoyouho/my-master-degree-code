actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
keyframepath='C:\Users\diesel\Desktop\dogcentric\keyframe';

% load model
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
        load(sprintf('%s\\keyframe0.03%d_%d.mat',keyframepath,vi,j));
        load(sprintf('%s\\feature%d_%d.mat',conf.videopath,vi,j));
        fprintf('%s\\feature%d_%d.mat\n',conf.videopath,vi,j);
        if isempty(keyframe)==0
            allencoding=[];
            timevarymean=[];
            for k=1:size(keyframe)
                if k==1 % 從第1張frame到第1個keyframe
                    index=X(:,1)<=keyframe(k,1);
                    tmpX=X(index,:);
                    % encode fisher vector
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                else % 剩下的一段一段keyframe
                    indexa=X(:,1)<=keyframe(k,1);
                    indexb=X(:,1)<=keyframe(k-1,1);
                    indexc=indexa+indexb;
                    index=indexc==1;
                    
                    tmpX=X(index,:);
                    % encode fisher vector
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                end
            end
%             % 最後一個keyframe到最後一張frame
%             indexa=X(:,1)<=keyframe(size(keyframe,1),1);
%             indexb=X(:,1)<=X(size(X,1),1);
%             indexc=indexa+indexb;
%             index=indexc==1;
%             tmpX=X(index,:);
%             % encode fisher vector
%             X1=tmpX(:,2:31);
%             X2=tmpX(:,32:127);
%             X3=tmpX(:,128:235);
%             X4=tmpX(:,236:331);
%             X5=tmpX(:,332:427);
%             % PCA
%             pcaX1=X1*newcoeff1;
%             pcaX2=X2*newcoeff2;
%             pcaX3=X3*newcoeff3;
%             pcaX4=X4*newcoeff4;
%             pcaX5=X5*newcoeff5;
%             % encoding fisher vector and normalize
%             E=[];
%             tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             
%             allencoding = [allencoding; E];
%             mean = sum(allencoding,1) / size(allencoding,1);
%             timevarymean = [timevarymean; mean];
        else
            allencoding=[];
            timevarymean=[];
            endframe=X(size(X,1),1);
            for k=1:endframe
                % take this frame's feature out
                index=X(:,1)==k;
                tmpX=X(index,:);
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                end
            end            
        end
        % save
        save(sprintf('%s\\seg0.03allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\seg0.03timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');
        % videodarwin
        W1 = VideoDarwin(allencoding);
        W1 = W1';
        save(sprintf('%s\\seg0.03W1%d_%d.mat',conf.modelpath,vi,j),'W1');
        W2 = VideoDarwin(timevarymean);
        W2 = W2';
        save(sprintf('%s\\seg0.03W2%d_%d.mat',conf.modelpath,vi,j),'W2');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\keyframe0.03%d_%d.mat',keyframepath,vi,j));
        load(sprintf('%s\\feature%d_%d.mat',conf.videopath,vi,j));
        fprintf('%s\\feature%d_%d.mat\n',conf.videopath,vi,j);
        if isempty(keyframe)==0
            allencoding=[];
            timevarymean=[];
            for k=1:size(keyframe)
                if k==1
                    index=X(:,1)<=keyframe(k,1);
                    tmpX=X(index,:);
                    % encode fisher vector
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                else
                    indexa=X(:,1)<=keyframe(k,1);
                    indexb=X(:,1)<=keyframe(k-1,1);
                    indexc=indexa+indexb;
                    index=indexc==1;
                    
                    tmpX=X(index,:);
                    % encode fisher vector
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                end
            end
%             % rest of frames
%             indexa=X(:,1)<=keyframe(size(keyframe,1),1);
%             indexb=X(:,1)<=X(size(X,1),1);
%             indexc=indexa+indexb;
%             index=indexc==1;
%             tmpX=X(index,:);
%             % encode fisher vector
%             X1=tmpX(:,2:31);
%             X2=tmpX(:,32:127);
%             X3=tmpX(:,128:235);
%             X4=tmpX(:,236:331);
%             X5=tmpX(:,332:427);
%             % PCA
%             pcaX1=X1*newcoeff1;
%             pcaX2=X2*newcoeff2;
%             pcaX3=X3*newcoeff3;
%             pcaX4=X4*newcoeff4;
%             pcaX5=X5*newcoeff5;
%             % encoding fisher vector and normalize
%             E=[];
%             tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             
%             allencoding = [allencoding; E];
%             mean = sum(allencoding,1) / size(allencoding,1);
%             timevarymean = [timevarymean; mean];
        else
            allencoding=[];
            timevarymean=[];
            endframe=X(size(X,1),1);
            for k=1:endframe
                % take this frame's feature out
                index=X(:,1)==k;
                tmpX=X(index,:);
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
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
                    sss=sign(tmpE(:,1));
                    tmpE=sss.*sqrt(abs(tmpE(:,1)));
                    tmpE=tmpE/norm(tmpE);
                    E=[E tmpE'];
                    
                    allencoding = [allencoding; E];
                    mean = sum(allencoding,1) / size(allencoding,1);
                    timevarymean = [timevarymean; mean];
                end
            end            
        end
        % save
        save(sprintf('%s\\seg0.03allencoding%d_%d.mat',conf.tmppath,vi,j),'allencoding');
        save(sprintf('%s\\seg0.03timevarymean%d_%d.mat',conf.tmppath,vi,j),'timevarymean');
        % videodarwin
        W1 = VideoDarwin(allencoding);
        W1 = W1';
        save(sprintf('%s\\seg0.03W1%d_%d.mat',conf.modelpath,vi,j),'W1');
        W2 = VideoDarwin(timevarymean);
        W2 = W2';
        save(sprintf('%s\\seg0.03W2%d_%d.mat',conf.modelpath,vi,j),'W2');
    end
end

