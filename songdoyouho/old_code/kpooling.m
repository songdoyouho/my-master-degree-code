actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

%%
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load 
        load(sprintf('%s\\64_allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\64_allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        poolingmatrix=allencoding;
%         load(sprintf('%s\\64_W3\\W3%d_%d.mat', conf.tmppath, vi, j));
%         fprintf('%s\\64_W3\\W3%d_%d.mat\n', conf.tmppath, vi, j);       
%         % cut tmppool W and norm 0 ~ 1
%         tmpW=W3(1,1:size(W3,2)/2);
%         score=allencoding*tmpW';
%         minW=min(score);
%         maxW=max(score);
%         scoreW=(score-minW)/(maxW-minW);
%         % multiply weight
%         poolingmatrix=zeros(size(allencoding,1),size(allencoding,2));
%         for k=1:size(allencoding,1)
%             poolingmatrix(k,:)=allencoding(k,:)*scoreW(k,1);
%         end
        % max and sum pooling
        data={poolingmatrix};
        get_pyramid_pooling_features(data, sprintf('%s\\64_pooling\\moving_pooling%d_%d.mat',conf.tmppath,vi,j), [1 2 3 4]);
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load 
        load(sprintf('%s\\64_allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\64_allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        poolingmatrix=allencoding;
%         load(sprintf('%s\\64_W3\\W3%d_%d.mat', conf.tmppath, vi, j));
%         fprintf('%s\\64_W3\\W3%d_%d.mat\n', conf.tmppath, vi, j);       
%         % cut tmppool W and norm 0 ~ 1
%         tmpW=W3(1,1:size(W3,2)/2);
%         minW=min(tmpW);
%         maxW=max(tmpW);
%         tmpW=(tmpW-minW)/(maxW-minW);
%         % multiply weight
%         poolingmatrix=zeros(size(allencoding,1),size(allencoding,2));
%         for k=1:size(allencoding,1)
%             poolingmatrix(k,:)=allencoding(k,:).*tmpW;
%         end        
        % max and sum pooling
        data={poolingmatrix};
        get_pyramid_pooling_features(data, sprintf('%s\\64_pooling\\moving_pooling%d_%d.mat',conf.tmppath,vi,j), [1 2 3 4]);
    end
end