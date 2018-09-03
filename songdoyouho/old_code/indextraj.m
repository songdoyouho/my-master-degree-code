% 區分軌跡是在bbox內 or 外，得到label
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load all info boxes
        load(sprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j));
        fprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        outputvideo = VideoWriter(sprintf('%s\\bbox_demo\\bbox_%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 20;
        open(outputvideo);
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        %         [C, A] = vl_kmeans([X3'], 3);
        %         A=A';
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
                        line([tmpinfo(1,2) tmpinfo(1,2) tmpinfo(1,4) tmpinfo(1,4) tmpinfo(1,2)]', [tmpinfo(1,3) tmpinfo(1,5) tmpinfo(1,5) tmpinfo(1,3) tmpinfo(1,3)]', 'color', 'r', 'linewidth', 3);
                        % find the features inside the bbox
                        index_x1 = now_bbox(1,2) <= tmpX(:,2);
                        index_y1 = now_bbox(1,3) <= tmpX(:,3);
                        index_x2 = tmpX(:,2) <= now_bbox(1,4);
                        index_y2 = tmpX(:,3) <= now_bbox(1,5);
                        index = index_x1 + index_y1 + index_x2 + index_y2 == 4;
                        label = or(label,index) ; % or operation
                        new_tmpX = tmpX(index,:);
                    end
                end                
                %                 plot inside features
                plot(new_tmpX(:,2),new_tmpX(:,3),'r*');
                image = getframe(gcf);
                writeVideo(outputvideo,image);  
                clf
                label = label + 0;
                all_label{1,k} = label;
            end
        end
        save(sprintf('%s\\all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load all info boxes
        load(sprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j));
        fprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        outputvideo = VideoWriter(sprintf('%s\\bbox_demo\\bbox_%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 20;
        open(outputvideo);
        X1=X(:,2:31);
        X2=X(:,32:127);
        X3=X(:,128:235);
        X4=X(:,236:331);
        X5=X(:,332:427);
        %         [C, A] = vl_kmeans([X3'], 3);
        %         A=A';
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
                        line([tmpinfo(1,2) tmpinfo(1,2) tmpinfo(1,4) tmpinfo(1,4) tmpinfo(1,2)]', [tmpinfo(1,3) tmpinfo(1,5) tmpinfo(1,5) tmpinfo(1,3) tmpinfo(1,3)]', 'color', 'r', 'linewidth', 3);
                        % find the features inside the bbox
                        index_x1 = now_bbox(1,2) <= tmpX(:,2);
                        index_y1 = now_bbox(1,3) <= tmpX(:,3);
                        index_x2 = tmpX(:,2) <= now_bbox(1,4);
                        index_y2 = tmpX(:,3) <= now_bbox(1,5);
                        index = index_x1 + index_y1 + index_x2 + index_y2 == 4;
                        label = or(label,index) ; % or operation
                        new_tmpX = tmpX(index,:);
                    end
                end                
                %                 plot inside features
                plot(new_tmpX(:,2),new_tmpX(:,3),'r*');
                image = getframe(gcf);
                writeVideo(outputvideo,image);  
                clf
                label = label + 0;
                all_label{1,k} = label;
            end
        end
        save(sprintf('%s\\all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
    end
end