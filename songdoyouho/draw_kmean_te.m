actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
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