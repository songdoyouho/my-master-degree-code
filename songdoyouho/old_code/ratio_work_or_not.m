actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
rg_rate = cell(conf.videonumber,5);
count = 1; 
output_video = 0;
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        rg_rate{count,1} = sprintf('%d',vi);
        rg_rate{count,2} = sprintf('%d',j);
        % load feature
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;

        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\per_video_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 20;
            open(outputvideo);
        end
        
        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);  % 選完的 X
        if isempty(rg_rate{count,3})
            rg_rate{count,3}=size(outX,1);
            rg_rate{count,4}=size(X,1)-size(outX,1);
            rg_rate{count,5}=rg_rate{count,3}/rg_rate{count,4};
        else
            rg_rate{count,3}=size(outX,1);
            rg_rate{count,4}=size(X,1)-size(outX,1);
            rg_rate{count,5}=rg_rate{count,3}/rg_rate{count,4};
        end
        count = count + 1;
        
         for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                %U = tmpX(:,2:2:30);
                %V = tmpX(:,3:2:31);
                %line(U',V');
                pause(0.5);
                image = getframe(gcf);
                writeVideo(outputvideo,image);
                clf
            end            
        end
        if output_video ==1
            close(outputvideo);
        end
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        rg_rate{count,1} = sprintf('%d',vi);
        rg_rate{count,2} = sprintf('%d',j);
        % load feature
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        
        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\per_video_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 20;
            open(outputvideo);
        end

        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);  % 選完的 X
        if isempty(rg_rate{count,3})
            rg_rate{count,3}=size(outX,1);
            rg_rate{count,4}=size(X,1)-size(outX,1);
            rg_rate{count,5}=rg_rate{count,3}/rg_rate{count,4};
        else
            rg_rate{count,3}=size(outX,1);
            rg_rate{count,4}=size(X,1)-size(outX,1);
            rg_rate{count,5}=rg_rate{count,3}/rg_rate{count,4};
        end
        count = count + 1;
        
         for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
               % U = tmpX(:,2:2:30);
               % V = tmpX(:,3:2:31);
                %line(U',V');
                pause(0.5);
                image = getframe(gcf);
                writeVideo(outputvideo,image);
                clf
            end            
        end
        if output_video ==1
            close(outputvideo);
        end
    end
end