actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
valid_output_video = 1;
output_video = 0;

rg_rate = cell(10,4);
count = 0;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        rg_rate{j,1} = sprintf('%d',j);
        outindex = [];
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 10;
            open(outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        % per video
        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [TrajAc,EE,outindex,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);  % 選完的 X
        if isempty(rg_rate{j,2})
            rg_rate{j,2}=size(outX,1);
            rg_rate{j,3}=size(X,1)-size(outX,1);
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        else
            rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
            rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        end
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
            % per frame
%             if size(tmpX,1) >= 3
%                 X1 = tmpX(:,2:31);
%                 U = X1(:,1:2:29);
%                 V = X1(:,2:2:30);
%                 Traj = [U V];
%                 [tmp_outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
%                 outX = tmpX(tmp_outindex,:);  % 選完的 X
%                 if isempty(rg_rate{j,2})
%                     rg_rate{j,2}=size(outX,1);
%                     rg_rate{j,3}=size(X,1)-size(outX,1);
%                     rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
%                 else
%                     rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
%                     rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
%                     rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
%                 end
%             else
%                 if isempty(tmpX)
%                     tmp_outindex = [];
%                 else
%                     tmp_outindex = logical(ones(1,size(tmpX,1)));
%                 end
%             end
%             outindex = [outindex tmp_outindex];
%             label = double(tmp_outindex');
            
            label = double(outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V');
                pause(0.5);
                image = getframe(gcf);
                clf
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
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        rg_rate{j,1} = sprintf('%d',j);
        outindex = [];
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 10;
            open(outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        % per video
        X1 = X(:,2:31);
        U = X1(:,1:2:29);
        V = X1(:,2:2:30);
        Traj = [U V];
        [TrajAc,EE,outindex,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
        outX = X(outindex,:);  % 選完的 X
        if isempty(rg_rate{j,2})
            rg_rate{j,2}=size(outX,1);
            rg_rate{j,3}=size(X,1)-size(outX,1);
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        else
            rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
            rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
            rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
        end
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
            % per frame
%             if size(tmpX,1) >= 3
%                 X1 = tmpX(:,2:31);
%                 U = X1(:,1:2:29);
%                 V = X1(:,2:2:30);
%                 Traj = [U V];
%                 [tmp_outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
%                 outX = tmpX(tmp_outindex,:);  % 選完的 X
%                 if isempty(rg_rate{j,2})
%                     rg_rate{j,2}=size(outX,1);
%                     rg_rate{j,3}=size(X,1)-size(outX,1);
%                     rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
%                 else
%                     rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
%                     rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
%                     rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
%                 end
%             else
%                 if isempty(tmpX)
%                     tmp_outindex = [];
%                 else
%                     tmp_outindex = logical(ones(1,size(tmpX,1)));
%                 end
%             end
%             outindex = [outindex tmp_outindex];
%             label = double(tmp_outindex');
            
            label = double(outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if output_video ==1
                plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V');
                pause(0.5);
                image = getframe(gcf);
                clf
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


%%  is valid 篩選
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        fprintf('%s\\motion_all_label\\outindex%d_%d.mat\n', conf.tmppath, vi,j);
        if valid_output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\new_valid_per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 10;
        end
        
        % calculate mean and var
        traj = X(:,2:31);
        norm = 1/15;
        mean_x = zeros(size(traj,1),1);
        mean_y = zeros(size(traj,1),1);
        for kkk = 1 : 15
            mean_x = mean_x + traj(:,2*kkk-1);
            mean_y = mean_y + traj(:,2*kkk);
        end
        mean_x = mean_x * norm;
        mean_y = mean_y * norm;
        
        var_x = zeros(size(traj,1),1);
        var_y = zeros(size(traj,1),1);
        for kkk = 1 : 15
            tmp_x = traj(:,2*kkk-1) - mean_x;
            tmp_y = traj(:,2*kkk) - mean_y;
            var_x = var_x + tmp_x .* tmp_x;
            var_y = var_y + tmp_y .* tmp_y;
        end
        
        var_x = var_x * norm;
        var_y = var_y * norm;
        var_x = sqrt(var_x);
        var_y = sqrt(var_y);
        
        minindex_x = var_x < sqrt(3); % and
        minindex_y = var_y < sqrt(3);
        
        minindex = minindex_x + minindex_y;
        minindex = minindex == 2; % 1 是不要的 0 是要留下的
        
        maxindex_x = var_x > 50; % or
        maxindex_y = var_y > 50;
        
        cur_max = zeros(size(traj,1),1);
        length = zeros(size(traj,1),1);
        length(:,1) = 15;
        disp_sum = zeros(size(traj,1),1);
        disp_max = zeros(size(traj,1),1);
        for kkk = 1 : 14
            tmpx = traj(:,2*(kkk+1)-1) - traj(:,2*kkk-1);
            tmpy = traj(:,2*(kkk+1)) - traj(:,2*kkk);
            tmppp = sqrt(tmpx .* tmpx + tmpy .* tmpy);
            length = length + tmppp;
            disp_sum = disp_sum + tmppp;
            for mmm = 1 : size(traj,1)
                if disp_max(mmm,1) < tmppp(mmm,1)
                    disp_max(mmm,1) = tmppp(mmm,1);
                end
                if cur_max(mmm,1) < tmppp(mmm,1)
                    cur_max(mmm,1) = tmppp(mmm,1);
                end
            end
        end
        cameraindex = disp_max <= 1;
        curindex1 = cur_max > 20;
        curindex2 = cur_max > length * 0.7;
        curindex = logical(curindex1 + curindex2);
        
        validindex = minindex + maxindex_x + maxindex_y + curindex + cameraindex;
        validindex = validindex == 0; % 1是要的 0是不要的
        
        new_X = X(validindex,:); % 找到 valid traj
        new_outindex = logical(outindex(:,validindex)); % 找到 valid traj中的local traj!!!
        outX = new_X(new_outindex,:); %local traj
        
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        for k = startframe : endframe
            thisframe = read(mov,k);
            if valid_output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=new_X(:,1)==k;
            tmpX=new_X(index,:);
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if valid_output_video ==1
                %                 plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,30),now_tmpX(:,31),'r*'); hold on
                U = now_tmpX(:,2:2:30);
                V = now_tmpX(:,3:2:31);
                line(U',V');
                pause(0.1);
                image = getframe(gcf);
                clf
                open(outputvideo);
                writeVideo(outputvideo,image);
            end
        end
        if valid_output_video ==1
            close(outputvideo);
            clf
        end
        save(sprintf('%s\\motion_all_label\\validindex%d_%d.mat', conf.tmppath, vi,j),'validindex');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
        fprintf('%s\\motion_all_label\\outindex%d_%d.mat\n', conf.tmppath, vi,j);
        if valid_output_video ==1
            outputvideo = VideoWriter(sprintf('%s\\new_valid_per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 10;
        end
        
        % calculate mean and var
        traj = X(:,2:31);
        norm = 1/15;
        mean_x = zeros(size(traj,1),1);
        mean_y = zeros(size(traj,1),1);
        for kkk = 1 : 15
            mean_x = mean_x + traj(:,2*kkk-1);
            mean_y = mean_y + traj(:,2*kkk);
        end
        mean_x = mean_x * norm;
        mean_y = mean_y * norm;
        
        var_x = zeros(size(traj,1),1);
        var_y = zeros(size(traj,1),1);
        for kkk = 1 : 15
            tmp_x = traj(:,2*kkk-1) - mean_x;
            tmp_y = traj(:,2*kkk) - mean_y;
            var_x = var_x + tmp_x .* tmp_x;
            var_y = var_y + tmp_y .* tmp_y;
        end
        
        var_x = var_x * norm;
        var_y = var_y * norm;
        var_x = sqrt(var_x);
        var_y = sqrt(var_y);
        
        minindex_x = var_x < sqrt(3); % and
        minindex_y = var_y < sqrt(3);
        
        minindex = minindex_x + minindex_y;
        minindex = minindex == 2; % 1 是不要的 0 是要留下的
        
        maxindex_x = var_x > 50; % or
        maxindex_y = var_y > 50;
        
        cur_max = zeros(size(traj,1),1);
        length = zeros(size(traj,1),1);
        length(:,1) = 15;
        disp_sum = zeros(size(traj,1),1);
        disp_max = zeros(size(traj,1),1);
        for kkk = 1 : 14
            tmpx = traj(:,2*(kkk+1)-1) - traj(:,2*kkk-1);
            tmpy = traj(:,2*(kkk+1)) - traj(:,2*kkk);
            tmppp = sqrt(tmpx .* tmpx + tmpy .* tmpy);
            length = length + tmppp;
            disp_sum = disp_sum + tmppp;
            for mmm = 1 : size(traj,1)
                if disp_max(mmm,1) < tmppp(mmm,1)
                    disp_max(mmm,1) = tmppp(mmm,1);
                end
                if cur_max(mmm,1) < tmppp(mmm,1)
                    cur_max(mmm,1) = tmppp(mmm,1);
                end
            end
        end
        cameraindex = disp_max <= 1;
        curindex1 = cur_max > 20;
        curindex2 = cur_max > length * 0.7;
        curindex = logical(curindex1 + curindex2);
        
        validindex = minindex + maxindex_x + maxindex_y + curindex + cameraindex;
        validindex = validindex == 0; % 1是要的 0是不要的
        
        new_X = X(validindex,:); % 找到 valid traj
        new_outindex = logical(outindex(:,validindex)); % 找到 valid traj中的local traj!!!
        outX = new_X(new_outindex,:); %local traj
        
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        for k = startframe : endframe
            thisframe = read(mov,k);
            if valid_output_video ==1
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=new_X(:,1)==k;
            tmpX=new_X(index,:);
            % selected
            index=outX(:,1)==k;
            now_tmpX=outX(index,:);
            if valid_output_video ==1
                %                 plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
                plot(now_tmpX(:,30),now_tmpX(:,31),'r*'); hold on
                U = now_tmpX(:,2:2:30);
                V = now_tmpX(:,3:2:31);
                line(U',V');
                pause(0.1);
                image = getframe(gcf);
                clf
                open(outputvideo);
                writeVideo(outputvideo,image);
            end
        end
        if valid_output_video ==1
            close(outputvideo);
            clf
        end
        save(sprintf('%s\\motion_all_label\\validindex%d_%d.mat', conf.tmppath, vi,j),'validindex');
    end
end
%%
% if strcmp(choose_dataset,'dog')
%     for j=1:actnum
%         for i=1:numel(tridx{j,1})
%             vi=tridx{j,1}(1,i);
%             if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
%                 fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
%                 load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
%                 load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
%                 for k = 1 : size(all_label,2)
%                     tmp_cell = all_label{1,k};
%                     if isempty(tmp_cell)==0
%                         %                     tmp_cell = double(not(tmp_cell));
%                         tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
%                         all_label{1,k} = tmp_cell;
%                     end
%                 end
%                 outindex = not(outindex);
%                 save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
%                 save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
%             end
%         end
%     end
%
%     for j=1:actnum
%         for i=1:numel(teidx{j,1})
%             vi=teidx{j,1}(1,i);
%             if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
%                 fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
%                 load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
%                 load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
%                 for k = 1 : size(all_label,2)
%                     tmp_cell = all_label{1,k};
%                     if isempty(tmp_cell)==0
%                         %                     tmp_cell = double(not(tmp_cell));
%                         tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
%                         all_label{1,k} = tmp_cell;
%                     end
%                 end
%                 outindex = not(outindex);
%                 save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
%                 save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
%             end
%         end
%     end
% end
% if strcmp(choose_dataset,'jpl')
%     for j=1:actnum
%         for i=1:numel(tridx{j,1})
%             vi=tridx{j,1}(1,i);
%             if j == 2 || j == 3 || j == 6
%                 fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
%                 load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
%                 load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
%                 for k = 1 : size(all_label,2)
%                     tmp_cell = all_label{1,k};
%                     if isempty(tmp_cell)==0
%                         %                     tmp_cell = double(not(tmp_cell));
%                         tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
%                         all_label{1,k} = tmp_cell;
%                     end
%                 end
%                 outindex = not(outindex);
%                 save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
%                 save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
%             end
%         end
%     end
%
%     for j=1:actnum
%         for i=1:numel(teidx{j,1})
%             vi=teidx{j,1}(1,i);
%             if j == 2 || j == 3 || j == 6
%                 fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
%                 load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
%                 load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
%                 for k = 1 : size(all_label,2)
%                     tmp_cell = all_label{1,k};
%                     if isempty(tmp_cell)==0
%                         %                     tmp_cell = double(not(tmp_cell));
%                         tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
%                         all_label{1,k} = tmp_cell;
%                     end
%                 end
%                 outindex = not(outindex);
%                 save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
%                 save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
%             end
%         end
%     end
% end
rmpath(genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
