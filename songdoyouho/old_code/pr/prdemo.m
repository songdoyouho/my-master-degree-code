load(sprintf('%s\\feature4_5.mat', conf.videopath));
fprintf('%s\\feature4_5.mat\n', conf.videopath);
mov = VideoReader(sprintf('%s\\4_5.avi',conf.videopath));

weight=0;

numberOfFrames = mov.NumberOfFrames;
width=mov.Width;
height=mov.Height;
nowframe=X(1,1);
endframe=X(size(X,1),1)+1;
count=1;
finalX=[];
allRRRR=[];

while(nowframe<=endframe)
    % take 2 frames of features out
    stackX=[];
    index=X(:,1);
    indexnow=index(:,1)==nowframe;
    tmpX=X(indexnow,:);
    stackX=[stackX; tmpX];
    nowframe=nowframe+1;
    if nowframe>endframe
        break;
    end
    
    if size(stackX,1)>=20  % 如果這張frame的feature數量超過200，就篩選
        adjacent1=zeros(size(stackX,1),size(stackX,1));
        adjacent2=zeros(size(stackX,1),size(stackX,1));
        % distance = sqrt(sum((comp - nowf) .^ 2))
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
        dis_RRRR = pagerankv2(norm1,1e-2,.85);
        desc_RRRR = pagerankv2(norm2,1e-2,.85);
        [B1 I1] = sort(dis_RRRR,'ascend');
        [B2 I2] = sort(desc_RRRR,'descend');
        order_dis = zeros(size(I1,1),1);
        order_desc = zeros(size(I2,1),1);
        for iii = 1:size(I1,1)
            order_dis(I1(iii,1),1)=iii;
            order_desc(I2(iii,1),1)=iii;
        end

        order = order_dis + order_desc;
        [B3 I3] = sort(order,'ascend');
        I=I3;
%         I = zeros(size(I3,1),1);
%         for iii = 1:size(I1,1)
%             I(I3(iii,1),1) = iii;
%         end
%         RRRR=pagerankv2(weight*norm1+(1-weight)*norm2, 1e-2, .85);
%         allRRRR=[allRRRR; RRRR];
%         [B I]=sort(RRRR,'descend');    
        indexx=1:size(dis_RRRR,1);
        indexxx=ismember(indexx',I(1:fix(size(I,1)/10*5),1));
        finalX=[finalX; stackX(indexxx,:)];
    else
        finalX=[finalX; stackX];
    end
    
    disp('show video');
    thisFrame = read(mov, nowframe);
    imshow(thisFrame);
    hold on;
    for bbb=1:size(X,1)
        if nowframe-1==X(bbb,1)
            plot(X(bbb,2),X(bbb,3),'g+');
            hold on;
        end
    end
    for bbb=1:size(finalX,1)
        if nowframe-1==finalX(bbb,1)
            plot(finalX(bbb,2),finalX(bbb,3),'r+');
            hold on;
        end
    end
    pause(0.2)
    clf
end



