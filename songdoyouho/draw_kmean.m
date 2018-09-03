actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
%         X = load(sprintf('H:\\dogcentric\\new_decompose_traj_thr_0.1\\test%d_%d.txt',vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\Et_iscamkmean%d_%d.avi',conf.videopath,vi,j));
%         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\test%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        for k = 1 : endframe
            thisframe = read(mov,k);
            imshow(thisframe,'border','tight');
            hold on
            index = X(:,1) == k;
            tmp_traj = X(index,:); 
            if isempty(tmp_traj) == 0
                plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                U = tmp_traj(:,2:2:30);
                V = tmp_traj(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'Et');
                image = getframe(gcf);
                clf
                writeVideo(outputvideo,image);
            end
        end
        close(outputvideo);
    end
end

% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         load(sprintf('I:\\jpl_seg\\new_decompose_traj\\feature%d_%d.mat',vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         endframe = mov.NumberOfFrames;
%         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj\\iscamkmean%d_%d.avi',conf.videopath,vi,j));
%         outputvideo.FrameRate = 5;
%         open(outputvideo);
%         for k = 1 : endframe
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             index = X(:,1) == k;
%             tmp_traj = X(index,:);
%             if isempty(tmp_traj) == 0
%                 plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
%                 U = tmp_traj(:,2:2:30);
%                 V = tmp_traj(:,3:2:31);
%                 line(U',V','Color','green');
%                 text(1, 5, 'E');
%                 image = getframe(gcf);
%                 clf
%                 writeVideo(outputvideo,image);
%             end
%         end
%         close(outputvideo);
%     end
% end

% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi', conf.videopath, vi, j);
%         endframe = mov.NumberOfFrames;
%         for k = 1 : endframe - 16
%             load(sprintf('%s\\new_decompose_traj\\video_TrajOut\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
%         end
%     end
% end
%
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi', conf.videopath, vi, j);
%         endframe = mov.NumberOfFrames;
%         for k = 1 : endframe - 16
%             load(sprintf('%s\\new_decompose_traj\\video_TrajOut\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
%         end
%     end
% end

% µekmean«áªº­y¸ñ
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         traj = load(sprintf('I:\\jpl_seg\\new_decompose_traj\\center%d_%d.txt',vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         endframe = mov.NumberOfFrames;
%         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj\\kmean%d_%d.avi',conf.videopath,vi,j));
%         outputvideo.FrameRate = 5;
%         open(outputvideo);
%         for k = 1 : endframe
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             index = traj(:,33) == k - 15;
%             tmp_traj = traj(index,:);
%             if isempty(tmp_traj) == 0
%                 plot(tmp_traj(:,1),tmp_traj(:,17),'r*'); hold on
%                 U = tmp_traj(:,1:16);
%                 V = tmp_traj(:,17:32);
%                 line(U',V','Color','green');
%                 text(1, 5, 'E');
%                 image = getframe(gcf);
%                 clf
%                 writeVideo(outputvideo,image);
%             end
%         end
%         close(outputvideo);
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         traj = load(sprintf('I:\\jpl_seg\\new_decompose_traj\\center%d_%d.txt',vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         endframe = mov.NumberOfFrames;
%         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj\\kmean%d_%d.avi',conf.videopath,vi,j));
%         outputvideo.FrameRate = 5;
%         open(outputvideo);
%         for k = 1 : endframe
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             index = traj(:,33) == k - 15;
%             tmp_traj = traj(index,:);
%             if isempty(tmp_traj) == 0
%                 plot(tmp_traj(:,1),tmp_traj(:,17),'r*'); hold on
%                 U = tmp_traj(:,1:16);
%                 V = tmp_traj(:,17:32);
%                 line(U',V','Color','green');
%                 text(1, 5, 'E');
%                 image = getframe(gcf);
%                 clf
%                 writeVideo(outputvideo,image);
%             end
%         end
%         close(outputvideo);
%     end
% end

