actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         load(sprintf('%s\\feature%d_%d.mat',conf.videopath,vi,j)); %new_decompose_traj_thr_0.1\\
%         improved = X;
%         load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         endframe = mov.NumberOfFrames;
%         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\combine%d_%d.avi',conf.videopath,vi,j));
%         outputvideo.FrameRate = 10;
%         open(outputvideo);
%         for k = 1 : endframe
%             figure(1)
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             figure(2)
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             imp_index = improved(:,1) == k;
%             tmp_imptraj = improved(imp_index,:); 
%             index = X(:,1) == k;
%             tmp_traj = X(index,:);
%             if isempty(tmp_imptraj) == 0
%                 figure(1)
%                 plot(tmp_imptraj(:,2),tmp_imptraj(:,3),'r*'); hold on
%                 U = tmp_imptraj(:,2:2:30);
%                 V = tmp_imptraj(:,3:2:31);
%                 line(U',V','Color','green');
%                 text(1, 5, 'improved trajectory');
%                 image1 = getframe(gcf);
%                 clf
%                 figure(2)
%                 plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
%                 U = tmp_traj(:,2:2:30);
%                 V = tmp_traj(:,3:2:31);
%                 line(U',V','Color','green');
%                 text(1, 5, 'our trajectory');
%                 image2 = getframe(gcf);
%                 clf
%                 image = cat(2,image1.cdata,image2.cdata);
%                 writeVideo(outputvideo,image);
%             end
%         end
%         close(outputvideo);
%     end
% end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat',conf.videopath,vi,j)); %new_decompose_traj_thr_0.1\\
        improved = X;
        load(sprintf('%s\\new_decompose_traj_thr_0.1\\feature%d_%d.mat',conf.videopath,vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\combine%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        for k = 1 : endframe
            figure(1)
            thisframe = read(mov,k);
            imshow(thisframe,'border','tight');
            hold on
            figure(2)
            thisframe = read(mov,k);
            imshow(thisframe,'border','tight');
            hold on
            imp_index = improved(:,1) == k;
            tmp_imptraj = improved(imp_index,:); 
            index = X(:,1) == k;
            tmp_traj = X(index,:);
            if isempty(tmp_imptraj) == 0
                figure(1)
                plot(tmp_imptraj(:,2),tmp_imptraj(:,3),'r*'); hold on
                U = tmp_imptraj(:,2:2:30);
                V = tmp_imptraj(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'improved trajectory');
                image1 = getframe(gcf);
                clf
                figure(2)
                plot(tmp_traj(:,2),tmp_traj(:,3),'r*'); hold on
                U = tmp_traj(:,2:2:30);
                V = tmp_traj(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'our trajectory');
                image2 = getframe(gcf);
                clf
                image = cat(2,image1.cdata,image2.cdata);
                writeVideo(outputvideo,image);
            end
        end
        close(outputvideo);
    end
end

