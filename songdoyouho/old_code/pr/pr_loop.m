function [  ] = pr_loop( conf, weight, threshold, number )
%PR_LOOP Summary of this function goes here
%   Detailed explanation goes here
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\%d_%d.mat', conf.pr_matrixpath, vi, j));
        fprintf('%s\\%d_%d.mat\n', conf.pr_matrixpath, vi, j);
        
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath, vi, j));
        numberOfFrames = mov.NumberOfFrames;
        startframe=X(1,1);
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        count=1;
        prX=[];
        allRRRR=[];
        while(nowframe<=endframe)
            stackX=[];
            index=X(:,1);
            indexnow=index(:,1)==nowframe;
            tmpX=X(indexnow,:);
            stackX=[stackX; tmpX];
            nowframe=nowframe+1;
            if nowframe>endframe
                break;
            end
            
            norm1=all_pr_adjmatrix{nowframe-startframe,1};
            norm2=all_pr_adjmatrix{nowframe-startframe,2};
            if size(stackX,1) <= threshold
                prX=[prX; stackX];
            else
                % page rank
                RRRR=pagerankv2(weight*norm1+(1-weight)*norm2, 1e-2, .85);
                allRRRR=[allRRRR; RRRR];
                [B I]=sort(RRRR,'ascend');
                indexx=1:size(RRRR,1);
                indexxx=ismember(indexx',I(1:fix(size(I,1)*number),1));
                prX=[prX; stackX(indexxx,:)];
            end
        end
        save(sprintf('%s\\prX\\prX%d_%d.mat',conf.videopath,vi,j),'prX');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\%d_%d.mat', conf.pr_matrixpath, vi, j));
        fprintf('%s\\%d_%d.mat\n', conf.pr_matrixpath, vi, j);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath, vi, j));
        numberOfFrames = mov.NumberOfFrames;
        startframe=X(1,1);
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        count=1;
        prX=[];
        allRRRR=[];
        while(nowframe<=endframe)
            stackX=[];
            index=X(:,1);
            indexnow=index(:,1)==nowframe;
            tmpX=X(indexnow,:);
            stackX=[stackX; tmpX];
            nowframe=nowframe+1;
            if nowframe>endframe
                break;
            end
            
            norm1=all_pr_adjmatrix{nowframe-startframe,1};
            norm2=all_pr_adjmatrix{nowframe-startframe,2};
            if size(stackX,1) <= threshold
                prX=[prX; stackX];
            else
                % page rank
                RRRR=pagerankv2(weight*norm1+(1-weight)*norm2, 1e-2, .85);
                allRRRR=[allRRRR; RRRR];
                [B I]=sort(RRRR,'ascend');
                indexx=1:size(RRRR,1);
                indexxx=ismember(indexx',I(1:fix(size(I,1)*number),1));
                prX=[prX; stackX(indexxx,:)];
            end
        end
        save(sprintf('%s\\prX\\prX%d_%d.mat',conf.videopath,vi,j),'prX');
    end
end
end

