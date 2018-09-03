actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath, vi, j));
        numberOfFrames = mov.NumberOfFrames;
        
        startframe=X(1,1);
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        all_pr_adjmatrix=cell(numberOfFrames-startframe,2);
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
            
            adjacent1=zeros(size(stackX,1),size(stackX,1));
            adjacent2=zeros(size(stackX,1),size(stackX,1));
            for m=1:size(adjacent2,1)
                for n=1:size(adjacent2,2)
                    nowf=stackX(m,:);
                    comp=stackX(n,:);
                    dist1=sqrt(sum((comp(1,2:3) - nowf(1,2:3)) .^ 2));
                    dist2=sqrt(sum((comp(1,32:427) - nowf(1,32:427)) .^ 2));
                    adjacent1(m,n)=dist1;
                    adjacent2(m,n)=dist2;
                end
            end
            norm1 = adjacent1/norm(adjacent1);
            norm2 = adjacent2/norm(adjacent2);
            
            all_pr_adjmatrix{nowframe-startframe,1}=norm1;
            all_pr_adjmatrix{nowframe-startframe,2}=norm2;
        end
        save(sprintf('D:\\pr_matrix\\%d_%d.mat',vi,j),'all_pr_adjmatrix');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath, vi, j));
        numberOfFrames = mov.NumberOfFrames;
        
        startframe=X(1,1);
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        all_pr_adjmatrix=cell(numberOfFrames-startframe,2);
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
            adjacent1=zeros(size(stackX,1),size(stackX,1));
            adjacent2=zeros(size(stackX,1),size(stackX,1));
            for m=1:size(adjacent2,1)
                for n=1:size(adjacent2,2)
                    nowf=stackX(m,:);
                    comp=stackX(n,:);
                    dist1=sqrt(sum((comp(1,2:3) - nowf(1,2:3)) .^ 2));
                    dist2=sqrt(sum((comp(1,32:427) - nowf(1,32:427)) .^ 2));
                    if dist1>=400
                        adjacent1(m,n)=dist1;
                        adjacent2(m,n)=10;
                    else
                        adjacent1(m,n)=dist1;
                        adjacent2(m,n)=dist2;
                    end
                end
            end
            norm1 = adjacent1/norm(adjacent1);
            norm2 = adjacent2/norm(adjacent2);
            
            all_pr_adjmatrix{nowframe-startframe,1}=norm1;
            all_pr_adjmatrix{nowframe-startframe,2}=norm2;
        end
        save(sprintf('D:\\pr_matrix\\%d_%d.mat',vi,j),'all_pr_adjmatrix');
    end
end