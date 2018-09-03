load(sprintf('%s\\feature4_1.mat',conf.videopath));
% newX=X(:,32:427);
% Z = linkage(newX,'ward','euclidean','savememory','on');
% c = cluster(Z,'maxclust',3);
% c = cluster(Z,'cutoff',0.1);
% index=1:size(c,1);
% indexxx=ismember(c(1:fix(size(c,1)/4*3),1),index);
% finalX=X(indexxx,:);
%c1 = kmeans(newX,3);
mov = VideoReader(sprintf('%s\\4_1.avi',conf.videopath));
numberOfFrames = mov.NumberOfFrames;
width=mov.Width;
height=mov.Height;

% PR
nowframe=X(1,1);
endframe=X(size(X,1),1)+1;
count=1;
finalX=[];
C=[];
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
%     index=X(:,1);
%     indexnow=index(:,1)==nowframe;
%     tmpX=X(indexnow,:);
%     stackX=[stackX; tmpX];
%     nowframe=nowframe+1;
%     if nowframe>endframe
%         break;
%     end
    newX=stackX(:,32:427);    
    Z = linkage(newX,'ward','euclidean','savememory','on');
    c = cluster(Z,'maxclust',2);
    C=[C; c];
end

disp('show video');
for frame = 1 : numberOfFrames
    thisFrame = read(mov, frame);
    %subplot(1,2,1);
    imshow(thisFrame);
    hold on;
%     subplot(1,2,2);
%     imshow(thisFrame);
%     hold on;
        for bbb=1:size(X,1)
            if frame==X(bbb,1)&&C(bbb,1)==1
                plot(X(bbb,2),X(bbb,3),'g+');
                hold on;
            elseif frame==X(bbb,1)&&C(bbb,1)==2
                plot(X(bbb,2),X(bbb,3),'r*');
                hold on;
            elseif frame==X(bbb,1)&&C(bbb,1)==3
                plot(X(bbb,2),X(bbb,3),'y*');
                hold on;
            elseif frame==X(bbb,1)&&C(bbb,1)==4
                plot(X(bbb,2),X(bbb,3),'c*');
                hold on;
            elseif frame==X(bbb,1)&&C(bbb,1)==5
                plot(X(bbb,2),X(bbb,3),'w*');
                hold on;
            elseif frame==X(bbb,1)&&C(bbb,1)==6
                plot(X(bbb,2),X(bbb,3),'m*');
                hold on;
            end
        end
    %     thisFrame = read(mov, frame);
    %     subplot(1,2,2);
    %     imshow(thisFrame);
    %     hold on;
    %     for bbb=1:size(X,1)
    %         if frame==X(bbb,1)&&c1(bbb,1)==1
    %             %subplot(1,2,2);
    %             plot(X(bbb,2),X(bbb,3),'g+');
    %             %text(1,1,1,sprintf('%d',frame));
    %             hold on;
    %         elseif frame==X(bbb,1)&&c1(bbb,1)==2
    %             plot(X(bbb,2),X(bbb,3),'r*');
    %             hold on;
    %         elseif frame==X(bbb,1)&&c1(bbb,1)==3
    %             plot(X(bbb,2),X(bbb,3),'y*');
    %             hold on;
    %         elseif frame==X(bbb,1)&&c1(bbb,1)==4
    %             plot(X(bbb,2),X(bbb,3),'c*');
    %             hold on;
    %         elseif frame==X(bbb,1)&&c1(bbb,1)==5
    %             plot(X(bbb,2),X(bbb,3),'w*');
    %             hold on;
    %         elseif frame==X(bbb,1)&&c(bbb,1)==6
    %             plot(X(bbb,2),X(bbb,3),'m*');
    %             hold on;
    %         end
    %     end
    pause(0.1);
    %system('pause');    
end
close Figure 1;
clear show;