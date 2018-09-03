function motion_decomp( conf, FACTOR , choose_dataset )
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
output_video = 0;

rg_rate = cell(10,4);
count = 0;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        %         rg_rate{count,1} = sprintf('%d_%d',vi,j);
        rg_rate{j,1} = sprintf('%d',j);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));%all_improved_traj\\
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j); %all_improved_traj\\
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\all_motion_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 20;
            open(outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);
        if isempty(rg_rate{j,2})
            rg_rate{j,2}=size(outX,1);
            rg_rate{j,3}=size(X,1)-size(outX,1);
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        else
            rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
            rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        end
        %         rg_rate{count,2}=size(outX,1);
        %         rg_rate{count,3}=size(X,1)-size(outX,1);
        %         rg_rate{count,4}=rg_rate{count,2}/rg_rate{count,3};
        all_label = cell(1,endframe+1-startframe);
        for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            label = double(outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                pause(0.1);
                image = getframe(gcf);
                writeVideo(outputvideo,image);
            end
        end
        if output_video ==1
            close(outputvideo);
            clf
        end
        save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
        save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
        count = count + 1;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        %         rg_rate{count,1} = sprintf('%d_%d',vi,j);
        rg_rate{j,1} = sprintf('%d',j);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));%all_improved_traj\\
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j); %all_improved_traj\\
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\all_motion_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 20;
            open(outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);
        if isempty(rg_rate{j,2})
            rg_rate{j,2}=size(outX,1);
            rg_rate{j,3}=size(X,1)-size(outX,1);
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        else
            rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
            rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        end
        %         rg_rate{count,2}=size(outX,1);
        %         rg_rate{count,3}=size(X,1)-size(outX,1);
        %         rg_rate{count,4}=rg_rate{count,2}/rg_rate{count,3};
        all_label = cell(1,endframe+1-startframe);
        for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            label = double(outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                pause(0.1);
                image = getframe(gcf);
                writeVideo(outputvideo,image);
            end
        end
        if output_video ==1
            close(outputvideo);
            clf
        end
        save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
        save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
        count = count + 1;
    end
end

if strcmp(choose_dataset,'dog')
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
    
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
end
if strcmp(choose_dataset,'jpl')
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            if j == 2 || j == 3 || j == 6 
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
    
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            if j == 2 || j == 3 || j == 6 
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
end
rmpath(genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
%% per frame motion decomp
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         numframe = mov.NumberOfFrames;
%         X1 = X(:,2:31);
%         U = X1(:,1:2:29);
%         V = X1(:,2:2:30);
%         Traj = [U V];
%         for k = 1 : numframe
%             thisframe = read(mov,k);
%             imshow(thisframe,'border','tight');
%             hold on
%             index=X(:,1)==k;
%             tmpX=X(index,:);
%             if isempty(tmpX)==0
%                 X1 = tmpX(:,2:31);
%                 U = X1(:,1:2:29);
%                 V = X1(:,2:2:30);
%                 Traj = [U V];
%                 [EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,10);
%                 outX = tmpX(outinds,:);
%                 index=outX(:,1)==k;
%                 now_tmpX=outX(index,:);
%                 plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%                 plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
%                 pause(0.1);
%             end
%         end
%         clf
%     end
% end
end

