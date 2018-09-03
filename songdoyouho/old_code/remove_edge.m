actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
plotabc = 0;
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('I:\\jpl_seg\\new_decompose_traj\\feature%d_%d.mat',vi,j));
        index1 = X(:,2) <= 2;
        index2 = X(:,3) <= 2;
        index3 = X(:,2) >= 319;
        index4 = X(:,3) >= 239;
        index = index1 + index2 + index3 + index4;
        index = index == 0;
        newX = X(index,:);
        index = index == 0;
        delX = X(index,:);
%         index1 = X(:,30) <= 2;
%         index2 = X(:,31) <= 2;
%         index3 = X(:,30) >= 319;
%         index4 = X(:,31) >= 239;
%         index = index1 + index2 + index3 + index4;
%         index = index == 0;
%         newX = X(index,:);
%         index = index == 0;
%         delX = X(index,:);
        
        if plotabc == 1
            % plot remaining traj
            mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
            endframe = mov.NumberOfFrames;
            outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj\\remain%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 5;
            open(outputvideo);
            for k = 1 : endframe
                thisframe = read(mov,k);
                imshow(thisframe,'border','tight');
                hold on
                index = newX(:,1) == k;
                tmp_traj = newX(index,:);
                index = delX(:,1) == k;
                del_traj = delX(index,:);
                if isempty(tmp_traj) == 0
                    plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                    U = tmp_traj(:,2:2:30);
                    V = tmp_traj(:,3:2:31);
                    line(U',V','Color','green');
                    text(1, 5, 'E');
                    hold on
                    plot(del_traj(:,2),del_traj(:,3),'b*'); hold on
                    U = del_traj(:,2:2:30);
                    V = del_traj(:,3:2:31);
                    line(U',V','Color','yellow');
                    hold on
                    
                    image = getframe(gcf);
                    clf
                    writeVideo(outputvideo,image);
                end
            end
            close(outputvideo);
        end
        X = newX;
        save(sprintf('I:\\jpl_seg\\new_decompose_traj\\remain_feature%d_%d.mat',vi,j),'X');
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('I:\\jpl_seg\\new_decompose_traj\\feature%d_%d.mat',vi,j));
        index1 = X(:,2) <= 2;
        index2 = X(:,3) <= 2;
        index3 = X(:,2) >= 319;
        index4 = X(:,3) >= 239;
        index = index1 + index2 + index3 + index4;
        index = index == 0;
        newX = X(index,:);
        index = index == 0;
        delX = X(index,:);
        
        if plotabc == 1
            % plot remaining traj
            mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
            endframe = mov.NumberOfFrames;
            outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj\\remain%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 5;
            open(outputvideo);
            for k = 1 : endframe
                thisframe = read(mov,k);
                imshow(thisframe,'border','tight');
                hold on
                index = newX(:,1) == k;
                tmp_traj = newX(index,:);
                index = delX(:,1) == k;
                del_traj = delX(index,:);
                if isempty(tmp_traj) == 0
                    plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                    U = tmp_traj(:,2:2:30);
                    V = tmp_traj(:,3:2:31);
                    line(U',V','Color','green');
                    text(1, 5, 'E');
                    hold on
                    plot(del_traj(:,2),del_traj(:,3),'b*'); hold on
                    U = del_traj(:,2:2:30);
                    V = del_traj(:,3:2:31);
                    line(U',V','Color','yellow');
                    hold on
                    
                    image = getframe(gcf);
                    clf
                    writeVideo(outputvideo,image);
                end
            end
            close(outputvideo);
        end
        X = newX;
        save(sprintf('I:\\jpl_seg\\new_decompose_traj\\remain_feature%d_%d.mat',vi,j),'X');
    end
end