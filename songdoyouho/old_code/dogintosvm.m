function [  ] = dogintosvm( conf, flag )
%INTOSVM Summary of this function goes here
% svm training and testing 

tridx=conf.tridx;
teidx=conf.teidx;
actnum=conf.actnum;
nnn=conf.nnn;
% add libsvm path
addpath(conf.svmpath);

if(strcmp(flag, 'train'))
    % read fisher vector
    for k=1:actnum
        feature=[];
        label=[];
        for j=1:actnum
            % take index
            load(sprintf('%s\\names%d.mat', conf.tmppath, j));
            for i=1:numel(tridx{j,1})
                vi=tridx{j,1}(1,i);
                % load features
                %                 load(sprintf('%s\\encoding%d_%d.mat', conf.tmppath, vi, j));
                %                 fprintf('%s\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
                %                 load(sprintf('%s\\select_encoding%d_%d.mat', conf.tmppath, vi, j));
                %                 fprintf('%s\\select_encoding%d_%d.mat\n', conf.tmppath, vi, j);
                %                 load(sprintf('%s\\W%d_%d.mat', conf.modelpath, vi, j));
                %                 fprintf('%s\\W%d_%d.mat\n', conf.modelpath, vi, j);
                load(sprintf('%s\\W1%d_%d.mat', conf.modelpath, vi, j));
                fprintf('%s\\W1%d_%d.mat\n', conf.modelpath, vi, j);
                
                % cascade and label features
                if k==j
                    label=[label; 1];
                    cas=W1/norm(W1);
                    %                     cas=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
                else
                    label=[label; -1];
                    cas=W1/norm(W1);
                    %                     cas=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
                end
                feature=[feature; cas];
            end
        end
        % train svm model
        %[label, feature] = libsvmread(sprintf('%s\\forsvm%d.txt',conf.tmppath,k));
        model = svmtrain(label, feature, '-c 100 -t 0');
        save(sprintf('%s\\svmmodel%d.mat',conf.modelpath,k),'model');
    end
    rmpath(conf.svmpath);
end
%%
if(strcmp(flag, 'test'))
    result=[];
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            % load features
            %             load(sprintf('%s\\encoding%d_%d.mat', conf.tmppath, vi, j));
            %             fprintf('%s\\encoding%d_%d.mat\n', conf.tmppath, vi, j);
            %             load(sprintf('%s\\select_encoding%d_%d.mat', conf.tmppath, vi, j));
            %             fprintf('%s\\select_encoding%d_%d.mat\n', conf.tmppath, vi, j);
            load(sprintf('%s\\W1%d_%d.mat', conf.modelpath, vi, j));
            fprintf('%s\\W1%d_%d.mat\n', conf.modelpath, vi, j);
            
            % cascade and label features
            %             feature=[encoding.traj' encoding.hog' encoding.hof' encoding.mbhx' encoding.mbhy'];
            feature=W2/norm(W2);
            % test svm
            comp=[];
            for n=1:actnum
                load(sprintf('%s\\svmmodel%d.mat',conf.modelpath,n));
                [predict_label, accuracy, dec_values] = svmpredict(0, feature, model);
                comp=[comp dec_values];
            end
            [B I]=sort(comp,'descend');
            tmpresult=[I(1,1) j];
            result=[tmpresult; result];
        end
    end
    save(sprintf('%s\\dog_darwin_W1_result%d.mat', conf.modelpath, nnn),'result');
    %save(sprintf('%s\\dogresult.mat',conf.modelpath),'result');
end
rmpath(conf.svmpath);
end

