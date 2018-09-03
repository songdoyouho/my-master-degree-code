actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
output_video = 0;

perframe_factor = 1.5;
pervideo_factor = 0.3;
perframe_index = 1;
pervideo_index = 1;

count = 0;
record = [];

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        tmp_record = [];
        tmp_record = [tmp_record vi j];
        outindex = [];
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            perframe_outputvideo = VideoWriter(sprintf('%s\\per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            perframe_outputvideo.FrameRate = 20;
            open(perframe_outputvideo);
            pervideo_outputvideo = VideoWriter(sprintf('%s\\per_video_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            pervideo_outputvideo.FrameRate = 20;
            open(pervideo_outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        if pervideo_index == 1% per video
                X1 = X(:,2:31);
                U = X1(:,1:2:29);
                V = X1(:,2:2:30);
                Traj = [U V];
                [pervideo_TrajAc,pervideo_outindex,EE,outinds,pervideo_TrajOut,pervideo_TrajIn,pervideo_TrajOutLow,pervideo_TrajOutE] = MotionDecomp(Traj,pervideo_factor);
                pervideo_outX = X(pervideo_outindex,:);  % 選完的 X
                pervideo_inX = X(not(pervideo_outindex),:);
                % t sne
                train_X = [pervideo_TrajOut; pervideo_TrajIn(1:10:end,:)];
                train_labels = [zeros(size(pervideo_TrajOut,1),1); ones(round(size(pervideo_TrajIn,1)/10),1)];
                mappedX = tsne(train_X, [], 2, [], 30);
                gscatter(mappedX(:,1), mappedX(:,2), train_labels);
                tmp_record = [tmp_record size(pervideo_outX,1) size(pervideo_inX,1) size(Traj,1) size(pervideo_outX,1)/size(pervideo_inX,1) size(pervideo_outX,1)/size(Traj,1)];
        end
        record = [record; tmp_record];
        all_label = cell(1,endframe+1-startframe);
        for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                % per video output
                figure(1) % 所有軌跡 traj
                imshow(thisframe,'border','tight');
                hold on
                figure(2) % global traj 第一層
                imshow(thisframe,'border','tight');
                hold on
                figure(3) % local traj 第一層
                imshow(thisframe,'border','tight');
                hold on
                figure(4) % rigid body component A 第二層
                imshow(thisframe,'border','tight');
                hold on
                figure(5) % local component Et 第二層
                imshow(thisframe,'border','tight');
                hold on
                figure(6) % camera motion component Ac 第二層
                imshow(thisframe,'border','tight');
                hold on
                % per frame output
                figure(7) 
                imshow(thisframe,'border','tight');
                hold on
                figure(8) 
                imshow(thisframe,'border','tight');
                hold on
                figure(9)
                imshow(thisframe,'border','tight');
                hold on
                figure(10) 
                imshow(thisframe,'border','tight');
                hold on
                figure(11)
                imshow(thisframe,'border','tight');
                hold on
                figure(12)
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            tmp_pervideo_TrajAc=pervideo_TrajAc(index,:);
            if perframe_index == 1% per frame
                if size(tmpX,1) >= 3
                    X1 = tmpX(:,2:31);
                    U = X1(:,1:2:29);
                    V = X1(:,2:2:30);
                    Traj = [U V];
                    [perframe_TrajAc,perframe_outindex,EE,outinds,perframe_TrajOut,perframe_TrajIn,perframe_TrajOutLow,perframe_TrajOutE] = MotionDecomp(Traj,perframe_factor);
                    perframe_outX = tmpX(perframe_outindex,:);  % 選完的 X
                else
                    if isempty(tmpX)
                        tmp_outindex = [];
                    else
                        tmp_outindex = logical(ones(1,size(tmpX,1)));
                    end
                end
            end
            % per frame
%             outindex = [outindex tmp_outindex];
%             label = double(tmp_outindex');
            % per video
            label = double(pervideo_outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=pervideo_outX(:,1)==k;
            tmp_pervideo_outX=pervideo_outX(index,:);
            tmp_pervideo_TrajOutE=pervideo_TrajOutE(index,:);
            tmp_pervideo_TrajOutLow=pervideo_TrajOutLow(index,:);
            index=pervideo_inX(:,1)==k;
            tmp_pervideo_inX=pervideo_inX(index,:);
            if output_video ==1
                figure(1)
                plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%                 plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'all input traj');
%                 pause(0.5);
                pervideo_image1 = getframe(gcf);
                clf
                figure(2)
                plot(tmp_pervideo_outX(:,2),tmp_pervideo_outX(:,3),'r*'); hold on
                U = tmp_pervideo_outX(:,2:2:30);
                V = tmp_pervideo_outX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'local traj');
%                 pause(0.5);
                pervideo_image2 = getframe(gcf);
                clf
                figure(3)
                plot(tmp_pervideo_inX(:,2),tmp_pervideo_inX(:,3),'r*'); hold on
                U = tmp_pervideo_inX(:,2:2:30);
                V = tmp_pervideo_inX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'global traj');
%                 pause(0.5);
                pervideo_image3 = getframe(gcf);
                clf
                figure(4)
                plot(tmp_pervideo_TrajOutLow(:,1),tmp_pervideo_TrajOutLow(:,16),'r*'); hold on
                U = tmp_pervideo_TrajOutLow(:,1:15);
                V = tmp_pervideo_TrajOutLow(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'A traj');
%                 pause(0.5);
                pervideo_image4 = getframe(gcf);
                clf
                figure(5)
                plot(tmp_pervideo_TrajOutE(:,1),tmp_pervideo_TrajOutE(:,16),'r*'); hold on
                U = tmp_pervideo_TrajOutE(:,1:15);
                V = tmp_pervideo_TrajOutE(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Et traj');
%                 pause(0.5);
                pervideo_image5 = getframe(gcf);
                clf
                figure(6)
                plot(tmp_pervideo_TrajAc(:,1),tmp_pervideo_TrajAc(:,16),'r*'); hold on
                U = tmp_pervideo_TrajAc(:,1:15);
                V = tmp_pervideo_TrajAc(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Ac traj');
%                 pause(0.5);
                pervideo_image6 = getframe(gcf);
                clf
                image1 = cat(2,pervideo_image1.cdata,pervideo_image2.cdata,pervideo_image3.cdata);
                image2 = cat(2,pervideo_image4.cdata,pervideo_image5.cdata,pervideo_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(pervideo_outputvideo,image);
                
                % per video output
                figure(7)
                plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%                 plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'all input traj');
%                 pause(0.5);
                perframe_image1 = getframe(gcf);
                clf
                figure(8)
                plot(perframe_TrajOut(:,1),perframe_TrajOut(:,16),'r*'); hold on
                U = perframe_TrajOut(:,1:15);
                V = perframe_TrajOut(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'local traj');
%                 pause(0.5);
                perframe_image2 = getframe(gcf);
                clf
                figure(9)
                plot(perframe_TrajIn(:,1),perframe_TrajIn(:,16),'r*'); hold on
                U = perframe_TrajIn(:,1:15);
                V = perframe_TrajIn(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'global traj');
%                 pause(0.5);
                perframe_image3 = getframe(gcf);
                clf
                figure(10)
                plot(perframe_TrajOutLow(:,1),perframe_TrajOutLow(:,16),'r*'); hold on
                U = perframe_TrajOutLow(:,1:15);
                V = perframe_TrajOutLow(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'A traj');
%                 pause(0.5);
                perframe_image4 = getframe(gcf);
                clf
                figure(11)
                plot(perframe_TrajOutE(:,1),perframe_TrajOutE(:,16),'r*'); hold on
                U = perframe_TrajOutE(:,1:15);
                V = perframe_TrajOutE(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Et traj');
%                 pause(0.5);
                perframe_image5 = getframe(gcf);
                clf
                figure(12)
                plot(perframe_TrajAc(:,1),perframe_TrajAc(:,16),'r*'); hold on
                U = perframe_TrajAc(:,1:15);
                V = perframe_TrajAc(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Ac traj');
%                 pause(0.5);
                perframe_image6 = getframe(gcf);
                clf
                image1 = cat(2,pervideo_image1.cdata,pervideo_image2.cdata,pervideo_image3.cdata);
                image2 = cat(2,pervideo_image4.cdata,pervideo_image5.cdata,pervideo_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(pervideo_outputvideo,image);
                image1 = cat(2,perframe_image1.cdata,perframe_image2.cdata,perframe_image3.cdata);
                image2 = cat(2,perframe_image4.cdata,perframe_image5.cdata,perframe_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(perframe_outputvideo,image);
            end
        end
        if output_video ==1
            close(pervideo_outputvideo);
            close(perframe_outputvideo);
        end
        count = count + 1;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        tmp_record = [];
        tmp_record = [tmp_record vi j];
        outindex = [];
        load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        if output_video ==1
            perframe_outputvideo = VideoWriter(sprintf('%s\\per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            perframe_outputvideo.FrameRate = 20;
            open(perframe_outputvideo);
            pervideo_outputvideo = VideoWriter(sprintf('%s\\per_video_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
            pervideo_outputvideo.FrameRate = 20;
            open(pervideo_outputvideo);
        end
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        if pervideo_index == 1% per video
                X1 = X(:,2:31);
                U = X1(:,1:2:29);
                V = X1(:,2:2:30);
                Traj = [U V];
                [pervideo_TrajAc,pervideo_outindex,EE,outinds,pervideo_TrajOut,pervideo_TrajIn,pervideo_TrajOutLow,pervideo_TrajOutE] = MotionDecomp(Traj,pervideo_factor);
                pervideo_outX = X(pervideo_outindex,:);  % 選完的 X
                pervideo_inX = X(not(pervideo_outindex),:);
                tmp_record = [tmp_record size(pervideo_outX,1) size(pervideo_inX,1) size(Traj,1) size(pervideo_outX,1)/size(pervideo_inX,1) size(pervideo_outX,1)/size(Traj,1)];
        end
        record = [record; tmp_record];
        all_label = cell(1,endframe+1-startframe);
        for k = startframe : endframe
            thisframe = read(mov,k);
            if output_video ==1
                % per video output
                figure(1) % 所有軌跡 traj
                imshow(thisframe,'border','tight');
                hold on
                figure(2) % global traj 第一層
                imshow(thisframe,'border','tight');
                hold on
                figure(3) % local traj 第一層
                imshow(thisframe,'border','tight');
                hold on
                figure(4) % rigid body component A 第二層
                imshow(thisframe,'border','tight');
                hold on
                figure(5) % local component Et 第二層
                imshow(thisframe,'border','tight');
                hold on
                figure(6) % camera motion component Ac 第二層
                imshow(thisframe,'border','tight');
                hold on
                % per frame output
                figure(7) 
                imshow(thisframe,'border','tight');
                hold on
                figure(8) 
                imshow(thisframe,'border','tight');
                hold on
                figure(9)
                imshow(thisframe,'border','tight');
                hold on
                figure(10) 
                imshow(thisframe,'border','tight');
                hold on
                figure(11)
                imshow(thisframe,'border','tight');
                hold on
                figure(12)
                imshow(thisframe,'border','tight');
                hold on
            end
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            tmp_pervideo_TrajAc=pervideo_TrajAc(index,:);
            if perframe_index == 1% per frame
                if size(tmpX,1) >= 3
                    X1 = tmpX(:,2:31);
                    U = X1(:,1:2:29);
                    V = X1(:,2:2:30);
                    Traj = [U V];
                    [perframe_TrajAc,perframe_outindex,EE,outinds,perframe_TrajOut,perframe_TrajIn,perframe_TrajOutLow,perframe_TrajOutE] = MotionDecomp(Traj,perframe_factor);
                    perframe_outX = tmpX(perframe_outindex,:);  % 選完的 X
                else
                    if isempty(tmpX)
                        tmp_outindex = [];
                    else
                        tmp_outindex = logical(ones(1,size(tmpX,1)));
                    end
                end
            end
            % per frame
%             outindex = [outindex tmp_outindex];
%             label = double(tmp_outindex');
            % per video
            label = double(pervideo_outindex(:,index)');
            all_label{1,k} = label;
            % selected
            index=pervideo_outX(:,1)==k;
            tmp_pervideo_outX=pervideo_outX(index,:);
            tmp_pervideo_TrajOutE=pervideo_TrajOutE(index,:);
            tmp_pervideo_TrajOutLow=pervideo_TrajOutLow(index,:);
            index=pervideo_inX(:,1)==k;
            tmp_pervideo_inX=pervideo_inX(index,:);
            if output_video ==1
                figure(1)
                plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%                 plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'all input traj');
%                 pause(0.5);
                pervideo_image1 = getframe(gcf);
                clf
                figure(2)
                plot(tmp_pervideo_outX(:,2),tmp_pervideo_outX(:,3),'r*'); hold on
                U = tmp_pervideo_outX(:,2:2:30);
                V = tmp_pervideo_outX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'local traj');
%                 pause(0.5);
                pervideo_image2 = getframe(gcf);
                clf
                figure(3)
                plot(tmp_pervideo_inX(:,2),tmp_pervideo_inX(:,3),'r*'); hold on
                U = tmp_pervideo_inX(:,2:2:30);
                V = tmp_pervideo_inX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'global traj');
%                 pause(0.5);
                pervideo_image3 = getframe(gcf);
                clf
                figure(4)
                plot(tmp_pervideo_TrajOutLow(:,1),tmp_pervideo_TrajOutLow(:,16),'r*'); hold on
                U = tmp_pervideo_TrajOutLow(:,1:15);
                V = tmp_pervideo_TrajOutLow(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'A traj');
%                 pause(0.5);
                pervideo_image4 = getframe(gcf);
                clf
                figure(5)
                plot(tmp_pervideo_TrajOutE(:,1),tmp_pervideo_TrajOutE(:,16),'r*'); hold on
                U = tmp_pervideo_TrajOutE(:,1:15);
                V = tmp_pervideo_TrajOutE(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Et traj');
%                 pause(0.5);
                pervideo_image5 = getframe(gcf);
                clf
                figure(6)
                plot(tmp_pervideo_TrajAc(:,1),tmp_pervideo_TrajAc(:,16),'r*'); hold on
                U = tmp_pervideo_TrajAc(:,1:15);
                V = tmp_pervideo_TrajAc(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Ac traj');
%                 pause(0.5);
                pervideo_image6 = getframe(gcf);
                clf
                image1 = cat(2,pervideo_image1.cdata,pervideo_image2.cdata,pervideo_image3.cdata);
                image2 = cat(2,pervideo_image4.cdata,pervideo_image5.cdata,pervideo_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(pervideo_outputvideo,image);
                
                % per video output
                figure(7)
                plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%                 plot(now_tmpX(:,2),now_tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:30);
                V = tmpX(:,3:2:31);
                line(U',V','Color','green');
                text(1, 5, 'all input traj');
%                 pause(0.5);
                perframe_image1 = getframe(gcf);
                clf
                figure(8)
                plot(perframe_TrajOut(:,1),perframe_TrajOut(:,16),'r*'); hold on
                U = perframe_TrajOut(:,1:15);
                V = perframe_TrajOut(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'local traj');
%                 pause(0.5);
                perframe_image2 = getframe(gcf);
                clf
                figure(9)
                plot(perframe_TrajIn(:,1),perframe_TrajIn(:,16),'r*'); hold on
                U = perframe_TrajIn(:,1:15);
                V = perframe_TrajIn(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'global traj');
%                 pause(0.5);
                perframe_image3 = getframe(gcf);
                clf
                figure(10)
                plot(perframe_TrajOutLow(:,1),perframe_TrajOutLow(:,16),'r*'); hold on
                U = perframe_TrajOutLow(:,1:15);
                V = perframe_TrajOutLow(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'A traj');
%                 pause(0.5);
                perframe_image4 = getframe(gcf);
                clf
                figure(11)
                plot(perframe_TrajOutE(:,1),perframe_TrajOutE(:,16),'r*'); hold on
                U = perframe_TrajOutE(:,1:15);
                V = perframe_TrajOutE(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Et traj');
%                 pause(0.5);
                perframe_image5 = getframe(gcf);
                clf
                figure(12)
                plot(perframe_TrajAc(:,1),perframe_TrajAc(:,16),'r*'); hold on
                U = perframe_TrajAc(:,1:15);
                V = perframe_TrajAc(:,16:30);
                line(U',V','Color','green');
                text(1, 5, 'Ac traj');
%                 pause(0.5);
                perframe_image6 = getframe(gcf);
                clf
                image1 = cat(2,pervideo_image1.cdata,pervideo_image2.cdata,pervideo_image3.cdata);
                image2 = cat(2,pervideo_image4.cdata,pervideo_image5.cdata,pervideo_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(pervideo_outputvideo,image);
                image1 = cat(2,perframe_image1.cdata,perframe_image2.cdata,perframe_image3.cdata);
                image2 = cat(2,perframe_image4.cdata,perframe_image5.cdata,perframe_image6.cdata);
                image = cat(1,image1,image2);
                writeVideo(perframe_outputvideo,image);
            end
        end
        if output_video ==1
            close(pervideo_outputvideo);
            close(perframe_outputvideo);
        end
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
            outputvideo.FrameRate = 20;
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
% 
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\invalid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
%         fprintf('%s\\motion_all_label\\outindex%d_%d.mat\n', conf.tmppath, vi,j);
%         if valid_output_video ==1
%             outputvideo = VideoWriter(sprintf('%s\\new_valid_per_frame_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
%             outputvideo.FrameRate = 20;
%         end
%         
%         % calculate mean and var
%         traj = X(:,2:31);
%         norm = 1/15;
%         mean_x = zeros(size(traj,1),1);
%         mean_y = zeros(size(traj,1),1);
%         for kkk = 1 : 15
%             mean_x = mean_x + traj(:,2*kkk-1);
%             mean_y = mean_y + traj(:,2*kkk);
%         end
%         mean_x = mean_x * norm;
%         mean_y = mean_y * norm;
%         
%         var_x = zeros(size(traj,1),1);
%         var_y = zeros(size(traj,1),1);
%         for kkk = 1 : 15
%             tmp_x = traj(:,2*kkk-1) - mean_x;
%             tmp_y = traj(:,2*kkk) - mean_y;
%             var_x = var_x + tmp_x .* tmp_x;
%             var_y = var_y + tmp_y .* tmp_y;
%         end
%                 
%         var_x = var_x * norm;
%         var_y = var_y * norm;
%         var_x = sqrt(var_x);
%         var_y = sqrt(var_y);
%         
%         minindex_x = var_x < sqrt(3); % and
%         minindex_y = var_y < sqrt(3);
%         
%         minindex = minindex_x + minindex_y;
%         minindex = minindex == 2; % 1 是不要的 0 是要留下的
%         
%         maxindex_x = var_x > 50; % or
%         maxindex_y = var_y > 50;
%         
%         cur_max = zeros(size(traj,1),1);
%         length = zeros(size(traj,1),1);
%         length(:,1) = 15;
%         disp_sum = zeros(size(traj,1),1);
%         disp_max = zeros(size(traj,1),1);
%         for kkk = 1 : 14
%             tmpx = traj(:,2*(kkk+1)-1) - traj(:,2*kkk-1);
%             tmpy = traj(:,2*(kkk+1)) - traj(:,2*kkk);
%             tmppp = sqrt(tmpx .* tmpx + tmpy .* tmpy);
%             length = length + tmppp;
%             disp_sum = disp_sum + tmppp;
%             for mmm = 1 : size(traj,1)
%                 if disp_max(mmm,1) < tmppp(mmm,1)
%                     disp_max(mmm,1) = tmppp(mmm,1);
%                 end
%                 if cur_max(mmm,1) < tmppp(mmm,1)
%                     cur_max(mmm,1) = tmppp(mmm,1);
%                 end
%             end
%         end
%         cameraindex = disp_max <= 1;
%         curindex1 = cur_max > 20;
%         curindex2 = cur_max > length * 0.7;
%         curindex = logical(curindex1 + curindex2);      
%         
%         validindex = minindex + maxindex_x + maxindex_y + curindex + cameraindex;
%         validindex = validindex == 0; % 1是要的 0是不要的
%         
%         new_X = X(validindex,:); % 找到 valid traj
%         new_outindex = logical(outindex(:,validindex)); % 找到 valid traj中的local traj!!!
%         outX = new_X(new_outindex,:); %local traj
%         
%         startframe = X(1,1);
%         endframe = mov.NumberOfFrames;
%         for k = startframe : endframe
%             thisframe = read(mov,k);
%             if valid_output_video ==1
%                 imshow(thisframe,'border','tight');
%                 hold on
%             end
%             % this frame
%             index=new_X(:,1)==k;
%             tmpX=new_X(index,:);
%             % selected
%             index=outX(:,1)==k;
%             now_tmpX=outX(index,:);
%             if valid_output_video ==1
%                 %                 plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
%                 plot(now_tmpX(:,30),now_tmpX(:,31),'r*'); hold on
%                 U = now_tmpX(:,2:2:30);
%                 V = now_tmpX(:,3:2:31);
%                 line(U',V');
%                 pause(0.1);
%                 image = getframe(gcf);
%                 clf
%                 open(outputvideo);
%                 writeVideo(outputvideo,image);
%             end
%         end
%         if valid_output_video ==1
%             close(outputvideo);
%             clf
%         end
%         save(sprintf('%s\\motion_all_label\\validindex%d_%d.mat', conf.tmppath, vi,j),'validindex');
%     end
% end
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
