function [  ] = dogselection( conf )
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
        width=mov.Width;
        height=mov.Height;
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        count=1;
        finalX=[];
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
            %     index=X(:,1);
            %     indexnow=index(:,1)==nowframe;
            %     tmpX=X(indexnow,:);
            %     stackX=[stackX; tmpX];
            %     nowframe=nowframe+1;
            %     if nowframe>endframe
            %         break;
            %     end
            adjacent2=zeros(size(stackX,1),size(stackX,1));
            for m=1:size(adjacent2,1)
                for n=1:size(adjacent2,2)
                    nowf=stackX(m,:);
                    comp=stackX(n,:);
                    dist1=sqrt(sum((comp(1,2:31) - nowf(1,2:31)) .^ 2));
                    if dist1>=400
                        adjacent2(m,n)=10;
                    else
                        dist2=sqrt(sum((comp(1,32:427) - nowf(1,32:427)) .^ 2));
                        adjacent2(m,n)=dist2;
                    end
                end
            end
            %             max2=max(max(adjacent2));
            %             norm2=adjacent2/max2;
            s=sum(adjacent2);
            b=zeros(size(adjacent2,1),size(adjacent2,2));
            for p=1:size(b,1)
                b(p,:)=s;
            end
            norm2=adjacent2./b;
            RRRR=pagerankv2(norm2, 1e-2, .85);
            allRRRR=[allRRRR; RRRR];
            [B I]=sort(RRRR,'ascend');
            indexx=1:size(RRRR,1);
            indexxx=ismember(indexx',I(1:fix(size(I,1)/10*9),1));
            finalX=[finalX; stackX(indexxx,:)];
            %end
        end
        save(sprintf('%s\\finalX%d_%d.mat',conf.tmppath,vi,j),'finalX');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath, vi, j));
        numberOfFrames = mov.NumberOfFrames;
        width=mov.Width;
        height=mov.Height;
        nowframe=X(1,1);
        endframe=X(size(X,1),1)+1;
        count=1;
        finalX=[];
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
            %     index=X(:,1);
            %     indexnow=index(:,1)==nowframe;
            %     tmpX=X(indexnow,:);
            %     stackX=[stackX; tmpX];
            %     nowframe=nowframe+1;
            %     if nowframe>endframe
            %         break;
            %     end
            adjacent2=zeros(size(stackX,1),size(stackX,1));
            for m=1:size(adjacent2,1)
                for n=1:size(adjacent2,2)
                    nowf=stackX(m,:);
                    comp=stackX(n,:);
                    dist1=sqrt(sum((comp(1,2:31) - nowf(1,2:31)) .^ 2));
                    if dist1>=400
                        adjacent2(m,n)=10;
                    else
                        dist2=sqrt(sum((comp(1,32:427) - nowf(1,32:427)) .^ 2));
                        adjacent2(m,n)=dist2;
                    end
                end
            end
            %             max2=max(max(adjacent2));
            %             norm2=adjacent2/max2;
            s=sum(adjacent2);
            b=zeros(size(adjacent2,1),size(adjacent2,2));
            for p=1:size(b,1)
                b(p,:)=s;
            end
            norm2=adjacent2./b;
            RRRR=pagerankv2(norm2, 1e-2, .85);
            allRRRR=[allRRRR; RRRR];
            [B I]=sort(RRRR,'ascend');
            indexx=1:size(RRRR,1);
            indexxx=ismember(indexx',I(1:fix(size(I,1)/10*9),1));
            finalX=[finalX; stackX(indexxx,:)];
            %end
        end
        save(sprintf('%s\\finalX%d_%d.mat',conf.tmppath,vi,j),'finalX');
    end
end
end

