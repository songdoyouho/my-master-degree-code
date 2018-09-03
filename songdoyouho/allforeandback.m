actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

traj_length = 16;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        height = mov.height;
        width = mov.width;
        
        outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\middle%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 5;
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
        
        % load optical flow
        load(sprintf('%s\\TVL1_opticalflow\\%d_%d.mat',conf.videopath,vi,j));
        allVx = TVL1_flow.allVx;
        allVy = TVL1_flow.allVy;
        
        % create foreward trajectory
        for k = 1 : endframe - traj_length
            thisframe=read(mov,k+traj_length);
            figure(1)
            imshow(thisframe,'border','tight'); hold on
            figure(2)
            imshow(thisframe,'border','tight'); hold on
            k
            % create traj matrix
            traj = zeros( height * width, traj_length * 2);
            count = 1;
            for iii = 1 : width
                for jjj = 1 : height
                    traj(count,1) = iii;
                    traj(count,2) = jjj;
                    count = count + 1;
                end
            end
            count = 1;
            med_traj = traj;
            % loop traj_length frames
            for kkk = k : k + traj_length - 2
                % load this frame optical flow
                Vx = allVx(:,:,kkk);
                Vy = allVy(:,:,kkk);
                % add median filter
                med_Vx = medfilt2(Vx,[3 3]);
                med_Vy = medfilt2(Vy,[3 3]);
                if count == 1
                    tic
                    for mmm = 1 : size(traj,1)
                        tmp_x = traj(mmm,1);
                        tmp_y = traj(mmm,2);
                        tmp_med_x = med_traj(mmm,1);
                        tmp_med_y = med_traj(mmm,2);
                        % find u , v
                        tmp_u = Vx(tmp_y,tmp_x);
                        tmp_med_u = med_Vx(tmp_med_y,tmp_med_x);
                        tmp_v = Vy(tmp_y,tmp_x);
                        tmp_med_v = med_Vy(tmp_med_y,tmp_med_x);
                        xxx = tmp_x + tmp_u;
                        med_xxx = tmp_med_x + tmp_med_u;
                        yyy = tmp_y + tmp_v;
                        med_yyy = tmp_med_x + tmp_med_v;
                        % if out of border then set to the border
                        if xxx < 1
                            xxx = 1;
                        end
                        if yyy < 1
                            yyy = 1;
                        end
                        if xxx > width
                            xxx = width;
                        end
                        if yyy > height
                            yyy = height;
                        end
                        traj(mmm,3) = xxx;
                        traj(mmm,4) = yyy;
                        if med_xxx < 1
                            med_xxx = 1;
                        end
                        if med_yyy < 1
                            med_yyy = 1;
                        end
                        if med_xxx > width
                            med_xxx = width;
                        end
                        if med_yyy > height
                            med_yyy = height;
                        end
                        med_traj(mmm,3) = med_xxx;
                        med_traj(mmm,4) = med_yyy;
                    end
                    count = 2;
                    toc
                else
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
            end
            
            
            
            
            %                 figure(1)
            %                 thisframe=read(mov,k+15);
            %                 imshow(thisframe,'border','tight'); hold on
            %                 figure(2)
            %                 thisframe=read(mov,k+15);
            %                 imshow(thisframe,'border','tight'); hold on
            
            %             figure(3)
            %             thisframe=read(mov,k+15);
            %             imshow(thisframe,'border','tight'); hold on
            %             plot(video_TrajOut(1:10:end,1),video_TrajOut(1:10:end,17),'r*');
            %             hold on
            %             line_x = video_TrajOut(1:10:end,1:traj_length);
            %             line_y = video_TrajOut(1:10:end,17:32);
            %             line(line_x',line_y','Color','green');
            %             text(1, 5, 'E');
            %             clf
            k
            % create backward trajectory matrix
            zero_traj = zeros(size(traj,1),traj_length * 2);
            traj = [traj(:,1:traj_length * 2) zero_traj];
            
            med_traj = traj;
            
            % load optical flow
            load(sprintf('%s\\TVL1_backopticalflow\\%d_%d.mat',conf.videopath,vi,j));
            backallVx = TVL1_backflow.allVx;
            backallVy = TVL1_backflow.allVy;
            traj(:,traj_length * 2 + 1) = traj(:,traj_length * 2 - 1);
            traj(:,traj_length * 2 + 2) = traj(:,traj_length * 2);
            count = traj_length + 1;
            % loop traj_length frames
            for kkk = k + traj_length - 2 : -1 : k
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
            % calculate forward and backward error
            distance_error = sqrt( (traj(:,1) - traj(:,size(traj,2) - 1)).*(traj(:,1) - traj(:,size(traj,2) - 1)) + (traj(:,2) - traj(:,size(traj,2))).*(traj(:,2) - traj(:,size(traj,2))) );
            [III SSS] = sort(distance_error,'descend');
%             figure(3)
%             histogram(distance_error);
%             title('length = 2')
%             xlabel('error value');
%             ylabel('number of times')
            
            maxscore = III(fix(size(traj,1)/2),1);
            outindex = III > maxscore;
            inindex = III<= maxscore;
            outindex = SSS(outindex,1);
            inindex = SSS(inindex,1);
            out_traj = traj(outindex,:);
            in_traj = traj(inindex,:);
            % plot out and in traj
            figure(1)
            plot(out_traj(1:10:end,1),out_traj(1:10:end,2),'r*'); hold on
            U = out_traj(1:10:end,1:2:traj_length*2-1);
            V = out_traj(1:10:end,2:2:traj_length*2);
            line(U',V','Color','green');
            text(1, 5, 'out traj');
            image1 = getframe(gcf);
            clf
            figure(2)
            plot(in_traj(1:10:end,1),in_traj(1:10:end,2),'r*'); hold on
            U = in_traj(1:10:end,1:2:traj_length*2-1);
            V = in_traj(1:10:end,2:2:traj_length*2);
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