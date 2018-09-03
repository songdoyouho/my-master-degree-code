actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% toolbox path
addpath(genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
addpath(genpath('C:\\Users\\diesel\\Desktop\\TVL1\\'));

videoout_control = 0;

opticalflow = opticalFlowFarneback;

% optical flow parameters
alpha = 0.01;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        
		% initial x , y locations
        matrix_x = zeros(mov.height,mov.width);
        matrix_y = zeros(mov.height,mov.width);
        for iii = 1 : mov.width
            for jjj = 1 : mov.height
                matrix_x(jjj,iii) = iii;
                matrix_y(jjj,iii) = jjj;
            end
        end
        
        % create traj matrix
        traj = zeros( mov.height*mov.width, 2 * (endframe-1));
        count = 1;
        for iii = 1 : mov.width
            for jjj = 1 : mov.height
                traj(count,1) = iii;
                traj(count,2) = jjj;
                count = count + 1;
            end
        end
        
        for k = 1 : endframe - 1
            k
            thisframe = read(mov,k);
            nextframe = read(mov,k+1);
            % brox
            %         [Vx, Vy, x, y, im] = optic_flow_brox(thisframe, nextframe, 10, 100, 3, 1, 0);
            %     figure(4)
            %     imshow(thisframe,'border','tight');
            %     hold on
            % farneback
            %         frameGray = rgb2gray(thisframe);
            %         flow = estimateFlow(opticalflow,frameGray);
            %         Vx = flow.Vx;
            %         Vy = flow.Vy;
            %     plot(flow,'DecimationFactor',[5 5]);
            %     image = getframe(gcf);
            %     clf
            %     writeVideo(opticalvideo,image);
            
            % TVL1
            [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
            
            out_index = [];
            if k == 1 % initial
                for mmm = 1 : size(traj,1)
                    tmp_x = traj(mmm,1);
                    tmp_y = traj(mmm,2);
                    % find u , v
                    tmp_u = Vx(tmp_y,tmp_x);
                    tmp_v = Vy(tmp_y,tmp_x);
                    xxx = tmp_x + tmp_u;
                    yyy = tmp_y + tmp_v;
                    % if exceed border than equal to border
                    if xxx < 1
                        xxx = 1;
                    end
                    if yyy < 1
                        yyy = 1;
                    end
                    if xxx > mov.width
                        xxx = mov.width;
                    end
                    if yyy > mov.height
                        yyy = mov.height;
                    end
                    traj(mmm,3) = xxx;
                    traj(mmm,4) = yyy;
                end
            else
                tmp_x = traj(:,2*k-1);
                tmp_y = traj(:,2*k);
                tmp_u = interp2(matrix_x,matrix_y,Vx,tmp_x,tmp_y);
                tmp_v = interp2(matrix_x,matrix_y,Vy,tmp_x,tmp_y);
                xxx = tmp_x + tmp_u;
                yyy = tmp_y + tmp_v;
                
                min_x = xxx < 1;
                max_x = xxx > mov.width;
                min_y = yyy < 1;
                max_y = yyy > mov.height;
                xxx(min_x) = 1;
                xxx(max_x) = mov.width;
                yyy(min_y) = 1;
                yyy(max_y) = mov.height;
                
                traj(:,2*k-1+2) = xxx;
                traj(:,2*k+2) = yyy;
            end
        end
        
        % remove the traj which end on the border
%         for mmm = 1 : size(traj,1)
%             tmp_xxx = traj(mmm,end-1);
%             tmp_yyy = traj(mmm,end);
%             if (tmp_xxx == 1 || tmp_yyy == 1 || tmp_xxx == mov.width || tmp_yyy == mov.height)
%                 out_index = [out_index; 0];
%             else
%                 out_index = [out_index; 1];
%             end
%         end
        
%         traj = traj(logical(out_index),:);
        
        save(sprintf('I:\\jpl_seg\\one2end_traj\\TVL1_traj_%d_%d.mat',vi,j),'traj');
        
        % decompose traj
        U = traj(:,1:2:size(traj,2)-1);
        V = traj(:,2:2:size(traj,2));
        TRAJ = [U V];
        [video_TrajAc,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,video_TrajOutE] = MotionDecomp(TRAJ,0.3);
        fprintf('decompose finish\n');
        % plot traj and save
        if videoout_control == 1
            outputvideo = VideoWriter(sprintf('%s\\one2end_show_traj_videos\\TVL1_%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 5;
            open(outputvideo);
            
            for k = 1 : endframe - 2
                thisframe = read(mov,k);
                figure(1)
                imshow(thisframe,'border','tight');
                figure(2)
                imshow(thisframe,'border','tight');
                
                figure(1)
                line_x = video_TrajOut(1:100:end,1:k+1);
                line_y = video_TrajOut(1:100:end,size(video_TrajOut,2)/2+1:size(video_TrajOut,2)/2+k+1);
                line(line_x',line_y','Color','blue');
                text(1, 5, 'after decomp global traj');
                image1 = getframe(gcf);
                clf
                figure(2)
                line_x = U(1:100:end,1:k+1);
                line_y = V(1:100:end,1:k+1);
                line(line_x',line_y','Color','blue');
                text(1, 5, 'original traj');
                image3 = getframe(gcf);
                image = cat(2,image3.cdata,image1.cdata);
                writeVideo(outputvideo,image);
                clf
            end
            close(outputvideo);
        end
        
        fid = fopen(sprintf('%s\\decompose_traj\\%d_%d.txt',conf.videopath,vi,j), 'wt');
        for iii = 1 : size(video_TrajOut,1)
            for jjj = 1 : size(video_TrajOut,2)
                fprintf(fid, '%f ', video_TrajOut(iii,jjj));
            end
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        
        matrix_x = zeros(mov.height,mov.width);
        matrix_y = zeros(mov.height,mov.width);
        for iii = 1 : mov.width
            for jjj = 1 : mov.height
                matrix_x(jjj,iii) = iii;
                matrix_y(jjj,iii) = jjj;
            end
        end
        
        % create traj matrix
        traj = zeros( mov.height*mov.width, 2 * (endframe-1));
        count = 1;
        for iii = 1 : mov.width
            for jjj = 1 : mov.height
                traj(count,1) = iii;
                traj(count,2) = jjj;
                count = count + 1;
            end
        end
        
        for k = 1 : endframe - 1
            k
            thisframe = read(mov,k);
            nextframe = read(mov,k+1);
            % brox
            %         [Vx, Vy, x, y, im] = optic_flow_brox(thisframe, nextframe, 10, 100, 3, 1, 0);
            %     figure(4)
            %     imshow(thisframe,'border','tight');
            %     hold on
            % farneback
            %         frameGray = rgb2gray(thisframe);
            %         flow = estimateFlow(opticalflow,frameGray);
            %         Vx = flow.Vx;
            %         Vy = flow.Vy;
            %     plot(flow,'DecimationFactor',[5 5]);
            %     image = getframe(gcf);
            %     clf
            %     writeVideo(opticalvideo,image);
            
            % TVL1
            [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
            
            out_index = [];
            if k == 1 % initial
                for mmm = 1 : size(traj,1)
                    tmp_x = traj(mmm,1);
                    tmp_y = traj(mmm,2);
                    % 找 u , v
                    tmp_u = Vx(tmp_y,tmp_x);
                    tmp_v = Vy(tmp_y,tmp_x);
                    xxx = tmp_x + tmp_u;
                    yyy = tmp_y + tmp_v;
                    % 如果超出邊界，就等於邊界
                    if xxx < 1
                        xxx = 1;
                    end
                    if yyy < 1
                        yyy = 1;
                    end
                    if xxx > mov.width
                        xxx = mov.width;
                    end
                    if yyy > mov.height
                        yyy = mov.height;
                    end
                    traj(mmm,3) = xxx;
                    traj(mmm,4) = yyy;
                end
            else
                tmp_x = traj(:,2*k-1);
                tmp_y = traj(:,2*k);
                tmp_u = interp2(matrix_x,matrix_y,Vx,tmp_x,tmp_y);
                tmp_v = interp2(matrix_x,matrix_y,Vy,tmp_x,tmp_y);
                xxx = tmp_x + tmp_u;
                yyy = tmp_y + tmp_v;
                
                min_x = xxx < 1;
                max_x = xxx > mov.width;
                min_y = yyy < 1;
                max_y = yyy > mov.height;
                xxx(min_x) = 1;
                xxx(max_x) = mov.width;
                yyy(min_y) = 1;
                yyy(max_y) = mov.height;
                
                traj(:,2*k-1+2) = xxx;
                traj(:,2*k+2) = yyy;
            end
        end
        
        % 刪除邊界上面的點
%         for mmm = 1 : size(traj,1)
%             tmp_xxx = traj(mmm,end-1);
%             tmp_yyy = traj(mmm,end);
%             if (tmp_xxx == 1 || tmp_yyy == 1 || tmp_xxx == mov.width || tmp_yyy == mov.height)
%                 out_index = [out_index; 0];
%             else
%                 out_index = [out_index; 1];
%             end
%         end
%         
%         traj = traj(logical(out_index),:);
        
        save(sprintf('I:\\jpl_seg\\one2end_traj\\TVL1_traj_%d_%d.mat',vi,j),'traj');
        
        % decompose traj
        U = traj(:,1:2:size(traj,2)-1);
        V = traj(:,2:2:size(traj,2));
        TRAJ = [U V];
        [video_TrajAc,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,video_TrajOutE] = MotionDecomp(TRAJ,0.3);
        fprintf('decompose finish\n');
        % plot traj and save
        if videoout_control == 1
            outputvideo = VideoWriter(sprintf('%s\\one2end_show_traj_videos\\TVL1_%d_%d.avi',conf.videopath,vi,j));
            outputvideo.FrameRate = 5;
            open(outputvideo);
            
            for k = 1 : endframe - 2
                thisframe = read(mov,k);
                figure(1)
                imshow(thisframe,'border','tight');
                figure(2)
                imshow(thisframe,'border','tight');
                % 畫線 or 箭頭?
                figure(1)
                line_x = video_TrajOut(1:100:end,1:k+1);
                line_y = video_TrajOut(1:100:end,size(video_TrajOut,2)/2+1:size(video_TrajOut,2)/2+k+1);
                line(line_x',line_y','Color','blue');
                text(1, 5, 'after decomp global traj');
                image1 = getframe(gcf);
                clf
                figure(2)
                line_x = U(1:100:end,1:k+1);
                line_y = V(1:100:end,1:k+1);
                line(line_x',line_y','Color','blue');
                text(1, 5, 'original traj');
                image3 = getframe(gcf);
                image = cat(2,image3.cdata,image1.cdata);
                writeVideo(outputvideo,image);
                clf
            end
            close(outputvideo);
        end
        
        fid = fopen(sprintf('%s\\decompose_traj\\%d_%d.txt',conf.videopath,vi,j), 'wt');
        for iii = 1 : size(video_TrajOut,1)
            for jjj = 1 : size(video_TrajOut,2)
                fprintf(fid, '%f ', video_TrajOut(iii,jjj));
            end
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
end
