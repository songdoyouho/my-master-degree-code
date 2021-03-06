actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath(genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));

alpha = 0.01;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

interval_num = 1;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        height = mov.height;
        width = mov.width;
        
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
        
        for k = 1 : interval_num : endframe - 16
            thisframe=read(mov,k+14);
            imshow(thisframe,'border','tight'); hold on
            k
            % create traj matrix
            traj = zeros( height * width, 32);
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
            % loop 16 frames
            for kkk = k : k + 14
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
                        % 找 u , v
                        tmp_u = Vx(tmp_y,tmp_x);
                        tmp_med_u = med_Vx(tmp_med_y,tmp_med_x);
                        tmp_v = Vy(tmp_y,tmp_x);
                        tmp_med_v = med_Vy(tmp_med_y,tmp_med_x);
                        xxx = tmp_x + tmp_u;
                        med_xxx = tmp_med_x + tmp_med_u;
                        yyy = tmp_y + tmp_v;
                        med_yyy = tmp_med_x + tmp_med_v;
                        % 如果超出邊界，就等於邊界
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
            
            % cut traj num into half
            U = traj(1:2:end,1:2:size(traj,2)-1);
            V = traj(1:2:end,2:2:size(traj,2));
            TRAJ = [U V];
            % decompose traj
            tic
            [video_TrajAc,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,video_TrajEt] = MotionDecomp(TRAJ,0.1);
            fprintf('decompose finish\n');
            toc
            
            plot(video_TrajEt(1:10:end,1),video_TrajEt(1:10:end,17),'r*'); hold on
            U = video_TrajEt(1:10:end,1:16);
            V = video_TrajEt(1:10:end,17:32);
            line(U',V','Color','green');
            text(1, 5, 'Et');
            image = getframe(gcf);
            clf
        end        
    end
end

