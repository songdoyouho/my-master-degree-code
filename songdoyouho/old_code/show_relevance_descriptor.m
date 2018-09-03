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
        load(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        outputvideo = VideoWriter(sprintf('%s\\motion_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
        open(outputvideo);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        for k=startframe:endframe
            thisFrame = read(mov, k);
            imshow(thisFrame,'border','tight');
            hold on
            % take this frame's feature out
            index=X(:,1)==k;
            now_tmpX=X(index,:);
            relevance_index=descriptor_relevance.X3(1,:)==k;
            now_relevance=descriptor_relevance.X3(index,:);
            if size(now_tmpX,1) < 50
                tmpX = now_tmpX;
            else 
                [aaa, bbb] = sort(now_relevance,'descend');
                tmp = 1:size(now_tmpX,1);
                indexx=1:size(now_tmpX,1);
                indexxx=ismember(indexx',bbb(1:fix(size(bbb,1)/4*3),1));
                tmpX = now_tmpX(indexxx,:);
            end
            % plot all features
            plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
            plot(tmpX(:,2),tmpX(:,3),'r*');  hold on
            pause(0.001);
            image = getframe(gcf);
            writeVideo(outputvideo,image);
        end
        close(outputvideo);
        clf;
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load features
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        load(sprintf('%s\\descriptor_relevance\\motion_desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        outputvideo = VideoWriter(sprintf('%s\\motion_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
        open(outputvideo);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        for k=startframe:endframe
            thisFrame = read(mov, k);
            imshow(thisFrame,'border','tight');
            hold on
            % take this frame's feature out
            index=X(:,1)==k;
            now_tmpX=X(index,:);
            relevance_index=descriptor_relevance.X3(1,:)==k;
            now_relevance=descriptor_relevance.X3(index,:);
            if size(now_tmpX,1) < 50
                tmpX = now_tmpX;
            else 
                [aaa, bbb] = sort(now_relevance,'descend');
                tmp = 1:size(now_tmpX,1);
                indexx=1:size(now_tmpX,1);
                indexxx=ismember(indexx',bbb(1:fix(size(bbb,1)/4*3),1));
                tmpX = now_tmpX(indexxx,:);
            end
            % plot all features
            plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
            plot(tmpX(:,2),tmpX(:,3),'r*');  hold on
            pause(0.001);
            image = getframe(gcf);
            writeVideo(outputvideo,image);
        end
        close(outputvideo);
        clf;
    end
end

%% original
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         load features
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         load(sprintf('%s\\descriptor_relevance\\desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         outputvideo = VideoWriter(sprintf('%s\\show_traj_videos\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
%         open(outputvideo);
%         descriptor_index = descriptor_relevance.X3 >= conf.descriptor_relevance_thr;
%         relevance_feature = X(descriptor_index,:);
%         startframe=relevance_feature(1,1);
%         endframe=relevance_feature(size(relevance_feature,1),1);
%         for k=startframe:endframe
%             thisFrame = read(mov, k);
%             imshow(thisFrame);
%             imshow(thisFrame,'border','tight','initialmagnification','fit');
%             hold on
%             take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
%             relevance_index=relevance_feature(:,1)==k;
%             now_relevance_tmpX=relevance_feature(relevance_index,:);
%             if feature num >= thr, use selected feature set
%             if size(now_tmpX,1) >= 50
%                 tmpX = now_relevance_tmpX;
%             else % else use the original feature set
%                 tmpX = now_tmpX;
%             end
%             plot all features
%             plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
%             plot(tmpX(:,2),tmpX(:,3),'r*');  hold on
%             pause(0.001);
%             image = getframe(gcf);
%             writeVideo(outputvideo,image);
%         end
%         close(outputvideo);
%         clf;
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         load(sprintf('%s\\descriptor_relevance\\desciptor_relevance%d_%d.mat',conf.tmppath,vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         outputvideo = VideoWriter(sprintf('%s\\show_traj_videos\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
%         open(outputvideo);
%         descriptor_index = descriptor_relevance.X3 >= conf.descriptor_relevance_thr;
%         relevance_feature = X(descriptor_index,:);
%         startframe=relevance_feature(1,1);
%         endframe=relevance_feature(size(relevance_feature,1),1);
%         for k=startframe:endframe
%             thisFrame = read(mov, k);
% %             imshow(thisFrame);
%             imshow(thisFrame,'border','tight','initialmagnification','fit');
%             hold on
%             % take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
%             relevance_index=relevance_feature(:,1)==k;
%             now_relevance_tmpX=relevance_feature(relevance_index,:);
%             % if feature num >= thr, use selected feature set
%             if size(now_tmpX,1) >= 50
%                 tmpX = now_relevance_tmpX;
%             else % else use the original feature set
%                 tmpX = now_tmpX;
%             end
%             % plot all features
%             plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
%             plot(tmpX(:,2),tmpX(:,3),'r*');  hold on
%             pause(0.001);
%             image = getframe(gcf);
%             writeVideo(outputvideo,image);
%         end
%         close(outputvideo);
%         clf;
%     end
% end