actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        bestvideo = VideoReader(sprintf('%s\\new_decompose_traj_thr_0.1\\best\\Et_iscamkmean%d_%d.avi', conf.videopath, vi, j));
        endframe = bestvideo.NumberOfFrames;
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
        outputvideo = VideoWriter(sprintf('%s\\compare\\TVL1_%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        for k = 1 : endframe
            frame = read(mov,k);
            imshow(frame,'border','tight');
            hold on
            index = X(:,1) == k;
            tmp_traj = X(index,:); 
            if isempty(tmp_traj) == 0
                thisframe = read(bestvideo,k-14);
                plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                U = tmp_traj(:,2:2:30);
                V = tmp_traj(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'after map');
                image1 = getframe(gcf);
                clf
                image = cat(2,image1.cdata,thisframe);
%                 imshow(image);
                writeVideo(outputvideo,image);
            end
        end
        close(outputvideo);
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        bestvideo = VideoReader(sprintf('%s\\new_decompose_traj_thr_0.1\\best\\Et_iscamkmean%d_%d.avi', conf.videopath, vi, j));
        endframe = bestvideo.NumberOfFrames;
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
        outputvideo = VideoWriter(sprintf('%s\\compare\\TVL1_%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        for k = 1 : endframe
            frame = read(mov,k);
            imshow(frame,'border','tight');
            hold on
            index = X(:,1) == k;
            tmp_traj = X(index,:); 
            if isempty(tmp_traj) == 0
                thisframe = read(bestvideo,k-14);
                plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                U = tmp_traj(:,2:2:30);
                V = tmp_traj(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'after map');
                image1 = getframe(gcf);
                clf
                image = cat(2,image1.cdata,thisframe);
                imshow(image);
                writeVideo(outputvideo,image);
            end
        end
        close(outputvideo);
    end
end