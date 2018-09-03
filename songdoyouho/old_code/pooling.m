actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% poolingidx=conf.poolingidx;
%%
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load 
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W1\\W1%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W1\\W1%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W1(1,1:size(W1,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(allencoding,1),size(allencoding,2));
        for k=1:size(allencoding,1)
            poolingmatrix(k,:)=allencoding(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load 
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W1\\W1%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W1\\W1%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W1(1,1:size(W1,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(allencoding,1),size(allencoding,2));
        for k=1:size(allencoding,1)
            poolingmatrix(k,:)=allencoding(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end
%%
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load 
        load(sprintf('%s\\timevarymean\\timevarymean%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\timevarymean\\timevarymean%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W2\\W2%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W2\\W2%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W2(1,1:size(W2,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(timevarymean,1),size(timevarymean,2));
        for k=1:size(timevarymean,1)
            poolingmatrix(k,:)=timevarymean(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\time_maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\time_sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load 
        load(sprintf('%s\\timevarymean\\timevarymean%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\timevarymean\\timevarymean%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W2\\W2%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W2\\W2%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W2(1,1:size(W2,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(timevarymean,1),size(timevarymean,2));
        for k=1:size(timevarymean,1)
            poolingmatrix(k,:)=timevarymean(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\time_maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\time_sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end
%%
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load 
        load(sprintf('%s\\movingaverage\\movingaverage%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\movingaverage\\movingaverage%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W3\\W3%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W3\\W3%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W3(1,1:size(W3,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(movingaverage,1),size(movingaverage,2));
        for k=1:size(movingaverage,1)
            poolingmatrix(k,:)=movingaverage(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\moving_maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\moving_sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load 
        load(sprintf('%s\\movingaverage\\movingaverage%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\movingaverage\\movingaverage%d_%d.mat\n', conf.tmppath, vi, j);
        load(sprintf('%s\\W3\\W3%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\W3\\W3%d_%d.mat\n', conf.tmppath, vi, j);       
        % cut half W
        tmpW=W3(1,1:size(W3,2)/2);
        % multiply weight
        poolingmatrix=zeros(size(movingaverage,1),size(movingaverage,2));
        for k=1:size(movingaverage,1)
            poolingmatrix(k,:)=movingaverage(k,:).*tmpW;
        end
        
        % max and sum pooling
        maxpooling=[];
        sumpooling=[];
        tmpmaxpooling=max(poolingmatrix,[],1); % original
        tmpsumpooling=sum(poolingmatrix)/size(poolingmatrix,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(1:fix(size(poolingmatrix,1))/2,:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];
        half=poolingmatrix(fix(size(poolingmatrix,1))/2+1:size(poolingmatrix,1),:); % half
        tmpmaxpooling=max(half,[],1);
        tmpsumpooling=sum(half)/size(half,1);
        maxpooling=[maxpooling tmpmaxpooling];
        sumpooling=[sumpooling tmpsumpooling];

        save(sprintf('%s\\pooling\\moving_maxpooling%d_%d.mat',conf.tmppath,vi,j),'maxpooling');
        save(sprintf('%s\\pooling\\moving_sumpooling%d_%d.mat',conf.tmppath,vi,j),'sumpooling');
    end
end