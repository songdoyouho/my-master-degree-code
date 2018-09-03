actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        outputvideo = VideoWriter(sprintf('%s\\newAEACET\\TVL1_%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 5;
        open(outputvideo);
        for k = 16 : endframe - 1
            load(sprintf('%s\\new_decompose_traj\\video_TrajAc\\%d_%d\\%d.mat',conf.videopath,vi,j,k));
            load(sprintf('%s\\new_decompose_traj\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k));
            load(sprintf('%s\\new_decompose_traj\\video_TrajIn\\%d_%d\\%d.mat',conf.videopath,vi,j,k));
            load(sprintf('%s\\new_decompose_traj\\video_TrajOut\\%d_%d\\%d.mat',conf.videopath,vi,j,k));
            thisframe = read(mov,k);
            figure(1)
            imshow(thisframe,'border','tight');
            hold on
            figure(2)
            imshow(thisframe,'border','tight');
            hold on
            figure(3)
            imshow(thisframe,'border','tight');
            hold on
            figure(4)
            imshow(thisframe,'border','tight');
            hold on
            
            figure(1)
            plot(video_TrajOut(1:10:end,1),video_TrajOut(1:10:end,17),'r*');
            hold on
            line_x = video_TrajOut(1:10:end,1:16);
            line_y = video_TrajOut(1:10:end,17:32);
            line(line_x',line_y','Color','green');
            text(1, 5, 'E');
            image1 = getframe(gcf);
            clf
            % µe A
            figure(2)
            plot(video_TrajIn(1:100:end,1),video_TrajIn(1:100:end,17),'r*');
            hold on
            line_x = video_TrajIn(1:100:end,1:16);
            line_y = video_TrajIn(1:100:end,17:32);
            line(line_x',line_y','Color','green');
            text(1, 5, 'A');
            image2 = getframe(gcf);
            clf
            
            % µe Ac
            figure(3)
            plot(video_TrajAc(1:100:end,1),video_TrajAc(1:100:end,17),'r*');
            hold on
            line_x = video_TrajAc(1:100:end,1:16);
            line_y = video_TrajAc(1:100:end,17:32);
            line(line_x',line_y','Color','green');
            text(1, 5, 'Ac');
            image3 = getframe(gcf);
            clf
            
            % µe Et
            figure(4)
            plot(video_TrajEt(1:10:end,1),video_TrajEt(1:10:end,17),'r*');
            hold on
            line_x = video_TrajEt(1:10:end,1:16);
            line_y = video_TrajEt(1:10:end,17:32);
            line(line_x',line_y','Color','green');
            text(1, 5, 'Et');
            image4 = getframe(gcf);
            clf
            
            image11 = cat(2,image2.cdata,image1.cdata);
            image22 = cat(2,image3.cdata,image4.cdata);
            image = [image11; image22];
            figure(5)
            imshow(image,'border','tight');
            image = getframe(gcf);
            writeVideo(outputvideo,image);
            clf
        end
        close(outputvideo);        
    end
end
