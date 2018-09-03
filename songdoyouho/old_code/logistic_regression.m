function [  ] = logistic_regression( conf )
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
descriptor_relevance_thr=conf.descriptor_relevance_thr;
addpath(genpath('C:\Users\songdoyouho\Desktop\pmtk3-master'));
% add vlfeat path
addpath(genpath(conf.vlfeatpath));
vl_setup
% Parameter
pp = preprocessorCreate('standardizeX', false, 'addOnes', true);
all_train_decision_value=[];
all_train_label=[];

load(sprintf('%s\\pbm_coeff1.mat',conf.modelpath));
load(sprintf('%s\\pbm_coeff2.mat',conf.modelpath));
load(sprintf('%s\\pbm_coeff3.mat',conf.modelpath));
load(sprintf('%s\\pbm_coeff4.mat',conf.modelpath));
load(sprintf('%s\\pbm_coeff5.mat',conf.modelpath));
load(sprintf('%s\\pbm_model1.mat',conf.modelpath));
load(sprintf('%s\\pbm_model2.mat',conf.modelpath));
load(sprintf('%s\\pbm_model3.mat',conf.modelpath));
load(sprintf('%s\\pbm_model4.mat',conf.modelpath));
load(sprintf('%s\\pbm_model5.mat',conf.modelpath));
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        train_label=[];
		load(sprintf('%s\\descriptor_relevance\\desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\all_label\\%d_%d.mat',conf.tmppath,vi,j));
		train_decision_value = [descriptor_relevance.X2 descriptor_relevance.X3 descriptor_relevance.X4 descriptor_relevance.X5];
        for aaa=1:size(all_label,2)
            if size(all_label{1,aaa},1) == 1
                all_label{1,aaa} = all_label{1,aaa}';
            end
            train_label = [train_label;all_label{1,aaa}];
        end
        all_train_decision_value=[all_train_decision_value; train_decision_value];
        all_train_label=[all_train_label; train_label];
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        train_label=[];
		load(sprintf('%s\\descriptor_relevance\\desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\all_label\\%d_%d.mat',conf.tmppath,vi,j));
		train_decision_value = [descriptor_relevance.X2 descriptor_relevance.X3 descriptor_relevance.X4 descriptor_relevance.X5];
        for aaa=1:size(all_label,2)
            if size(all_label{1,aaa},1) == 1
                all_label{1,aaa} = all_label{1,aaa}';
            end
            train_label = [train_label;all_label{1,aaa}];
        end
        all_train_decision_value=[all_train_decision_value; train_decision_value];
        all_train_label=[all_train_label; train_label];
    end
end
% model = logregFit(train_decision_value, train_label, 'lambda', 0, 'preproc', pp);
modelEB = logregFitBayes(all_train_decision_value, all_train_label, 'method', 'eb', 'preproc', pp);
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
		load(sprintf('%s\\descriptor_relevance\\desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
		test_decision_value = [descriptor_relevance.X2 descriptor_relevance.X3 descriptor_relevance.X4 descriptor_relevance.X5];
%         [test_predict_label, ppp] = logregPredict(model,test_decision_value);
        [test_predict_label, pEB] = logregPredictBayes(modelEB, test_decision_value);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
                load(sprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j));
        fprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        all_label = cell(1,endframe+1-startframe);
        for k=startframe:endframe
            thisFrame = read(mov, k);
            imshow(thisFrame);
            hold on
            % take this frame's feature and bbox out
            index=X(:,1)==k;
            tmpX=X(index,:);
            tmp_test_predict_label = test_predict_label(index,2);
            index=all_info_boxes(:,1)==k;
            tmpinfo=all_info_boxes(index,:);
            label = zeros(size(tmpX,1),1);
            % 要把所有在這張frame的bbox都驗證一遍
            if isempty(tmpinfo)
                all_label{1,k} = label;
            else
                for bbb = 1:size(tmpinfo,1)
                    % plot all features
                    plot(tmpX(:,2),tmpX(:,3),'g*');
                    check=isempty(tmpX);
                    if check~=1 % 這張畫面有feature
                        now_bbox = tmpinfo(bbb,:);
                        % plot bbox
                        line([tmpinfo(:,2) tmpinfo(:,2) tmpinfo(:,4) tmpinfo(:,4) tmpinfo(:,2)]', [tmpinfo(:,3) tmpinfo(:,5) tmpinfo(:,5) tmpinfo(:,3) tmpinfo(:,3)]', 'color', 'r', 'linewidth', 3);           
                    end
                end
                new_tmpX = tmpX(logical(tmp_test_predict_label),:);
%                 plot inside features
                plot(new_tmpX(:,2),new_tmpX(:,3),'r*');
                pause(0.01);
            end
        end        
%         X = X(logical(test_predict_label(:,2)),:);
%         X1=X(:,2:31);
%         X2=X(:,32:127);
%         X3=X(:,128:235);
%         X4=X(:,236:331);
%         X5=X(:,332:427);        
%         pca
%         pcaX1=X1*newcoeff1;
%         pcaX2=X2*newcoeff2;
%         pcaX3=X3*newcoeff3;
%         pcaX4=X4*newcoeff4;
%         pcaX5=X5*newcoeff5;
%         encoding
%         encoding.traj = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%         encoding.hog = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%         encoding.hof = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
%         encoding.mbhx = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%         encoding.mbhy = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);        
%         save(sprintf('%s\\log_encoding\\encoding%d_%d.mat',conf.tmppath,vi,j),'encoding');

    end
end
rmpath(genpath('C:\Users\songdoyouho\Desktop\pmtk3-master'));
end



