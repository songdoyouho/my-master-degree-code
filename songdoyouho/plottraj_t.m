actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1%:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load frame number
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        record = [];
        for k = 1 : endframe -16
            load(sprintf('%s\\new_decompose_traj_thr_0.1\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
            % take this frame's feature out
%             index=X(:,1)==k;
%             tmpX=X(index,:);
%             tmp = [size(tmpX,1) k-15 size(video_TrajEt,1)];
            tmp = [size(video_TrajEt,1) k];
            record = [record; tmp];
        end
        plot(record(:,2),record(:,1)); hold on 
        xlabel('time')
        ylabel('trajectory number before k-means')
    end
end
legend('shake hand','hug','pet','wave','point','punch','throw');