% different distance function

actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath(genpath(conf.opticalflow));

videoout_control = 0;

alpha = 0.01;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
% 
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         endframe = mov.NumberOfFrames;
% 
%         allVx = [];
%         allVy = [];
% 
%         %         for k = 1 : endframe - 1
%         %             k
%         %             thisframe = read(mov,k);
%         %             nextframe = read(mov,k+1);
%         %
%         %             % TVL1
%         %             [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
%         %
%         %             allVx = cat(3,allVx,Vx);
%         %             allVy = cat(3,allVy,Vy);
%         %
%         %             TVL1_flow.allVx = allVx;
%         %             TVL1_flow.allVy = allVy;
%         %         end
% 
%         for k = endframe : -1 : 2
%             k
%             thisframe = read(mov,k);
%             nextframe = read(mov,k-1);
% 
%             % TVL1
%             [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
% 
%             allVx = cat(3,allVx,Vx);
%             allVy = cat(3,allVy,Vy);
% 
%             TVL1_backflow.allVx = allVx;
%             TVL1_backflow.allVy = allVy;
%         end
%         save(sprintf('%s\\TVL1_backopticalflow\\%d_%d.mat',conf.videopath,vi,j),'TVL1_backflow');
%     end
% end

%%
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        height = mov.height;
        width = mov.width;
        
        outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\forandback%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        
        % initial x,y location
        matrix_x = zeros(mov.height,mov.width);
        matrix_y = zeros(mov.height,mov.width);
        for iii = 1 : mov.width
            for jjj = 1 : mov.height
                matrix_x(jjj,iii) = iii;
                matrix_y(jjj,iii) = jjj;
            end
        end
        
        for k = 1 : endframe - 16
            load(sprintf('%s\\new_decompose_traj_thr_0.1\\video_TrajOut\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));

            figure(1)
            thisframe=read(mov,k+15);
            imshow(thisframe,'border','tight'); hold on
            figure(2)
            thisframe=read(mov,k+15);
            imshow(thisframe,'border','tight'); hold on
            
%             figure(3)
%             thisframe=read(mov,k+15);
%             imshow(thisframe,'border','tight'); hold on
%             plot(video_TrajOut(1:10:end,1),video_TrajOut(1:10:end,17),'r*');
%             hold on
%             line_x = video_TrajOut(1:10:end,1:16);
%             line_y = video_TrajOut(1:10:end,17:32);
%             line(line_x',line_y','Color','green');
%             text(1, 5, 'E');
%             clf
            k
            % create traj matrix
            zero_traj = zeros(size(video_TrajOut,1),32);
            traj = [video_TrajOut(:,1:32) zero_traj];
            
            med_traj = traj;
            
            % load optical flow
            load(sprintf('%s\\TVL1_backopticalflow\\%d_%d.mat',conf.videopath,vi,j));
            backallVx = TVL1_backflow.allVx;
            backallVy = TVL1_backflow.allVy;
            traj(:,33) = traj(:,16);
            traj(:,34) = traj(:,32);
            count = 17;
            % loop 16 frames
            for kkk = k + 14 : -1 : k
                % load this frame optical flow
                Vx = backallVx(:,:,kkk);
                Vy = backallVy(:,:,kkk);
                % add median filter
                med_Vx = medfilt2(Vx,[3 3]);
                med_Vy = medfilt2(Vy,[3 3]);
                
                tmp_x = traj(:,2*count-1);
                tmp_y = traj(:,2*count);
                tmp_u = interp2(matrix_x,matrix_y,Vx,tmp_x,tmp_y);
                tmp_v = interp2(matrix_x,matrix_y,Vy,tmp_x,tmp_y);
                xxx = tmp_x + tmp_u;
                yyy = tmp_y + tmp_v;
                
                min_x = xxx < 1;
                max_x = xxx > width;
                min_y = yyy < 1;
                max_y = yyy > height;
                xxx(min_x) = 1;
                xxx(max_x) = width;
                yyy(min_y) = 1;
                yyy(max_y) = height;
                
                traj(:,2*count-1+2) = xxx;
                traj(:,2*count+2) = yyy;
                
                med_tmp_x = med_traj(:,2*count-1);
                med_tmp_y = med_traj(:,2*count);
                med_tmp_u = interp2(matrix_x,matrix_y,med_Vx,med_tmp_x,med_tmp_y);
                med_tmp_v = interp2(matrix_x,matrix_y,med_Vy,med_tmp_x,med_tmp_y);
                med_xxx = med_tmp_x + med_tmp_u;
                med_yyy = med_tmp_y + med_tmp_v;
                
                med_min_x = med_xxx < 1;
                med_max_x = med_xxx > width;
                med_min_y = med_yyy < 1;
                med_max_y = med_yyy > height;
                med_xxx(med_min_x) = 1;
                med_xxx(med_max_x) = width;
                med_yyy(med_min_y) = 1;
                med_yyy(med_max_y) = height;
                
                med_traj(:,2*count-1+2) = med_xxx;
                med_traj(:,2*count+2) = med_yyy;
                
                count = count + 1;
                
            end
            % find the distance error
            distance_error = abs(traj(:,1) - traj(:,63)) + abs(traj(:,17) - traj(:,64));
            [III SSS] = sort(distance_error,'descend');
            
%             plot(traj(1:100:end,1),traj(1:100:end,2),'r*'); hold on
%             U = traj(1:100:end,1:2:31);
%             V = traj(1:100:end,2:2:32);
%             line(U',V','Color','green');
%             text(1, 5, 'traj');
%             image1 = getframe(gcf);
%             clf

            maxscore = III(fix(size(video_TrajOut,1)/2),1);
            outindex = III > 10;
            inindex = III<= 10;
            outindex = SSS(outindex,1);
            inindex = SSS(inindex,1);
            out_traj = traj(outindex,:);
            in_traj = traj(inindex,:);
            % plot out and in traj
            figure(1)
            plot(out_traj(1:10:end,1),out_traj(1:10:end,17),'r*'); hold on
            U = out_traj(1:10:end,1:16);
            V = out_traj(1:10:end,17:32);
            line(U',V','Color','green');
            text(1, 5, 'out traj');
            image1 = getframe(gcf);
            clf
            figure(2)
            plot(in_traj(1:10:end,1),in_traj(1:10:end,17),'r*'); hold on
            U = in_traj(1:10:end,1:16);
            V = in_traj(1:10:end,17:32);
            line(U',V','Color','green');
            text(1, 5, 'in traj');
            image2 = getframe(gcf);
            clf
            image = cat(2,image1.cdata,image2.cdata);
            writeVideo(outputvideo,image);
        end
        close(outputvideo);
    end
end


