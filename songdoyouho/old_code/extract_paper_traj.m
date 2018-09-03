opengl('save', 'software');

actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
opticalflow = opticalFlowFarneback;
addpath (genpath('C:\\Users\\diesel\\Desktop\\brox\\'));

matrix_x = zeros(240,320);
matrix_y = zeros(240,320);
for iii = 1 : 320
    for jjj = 1 : 240
        matrix_x(jjj,iii) = iii;
        matrix_y(jjj,iii) = jjj;
    end
end

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        % create traj matrix
        traj = zeros(76800, 2 * (endframe - 1));
        count = 1;
        for iii = 1 : 320
            for jjj = 1 : 240
                traj(count,1) = iii;
                traj(count,2) = jjj;
                count = count + 1;
            end
        end
        
        for k = 1 : endframe - 1
            k
            thisframe = read(mov,k);
            nextframe = read(mov,k+1);
%             imshow(thisframe,'border','tight');
            frameGray = rgb2gray(thisframe);
            flow = estimateFlow(opticalflow,frameGray);
%             [u, v] = optic_flow_brox(thisframe, nextframe, 10, 100, 3, 1, 0);
            out_index = [];
            if k == 1 % initial
                for mmm = 1 : size(traj,1)
                    tmp_x = traj(mmm,1);
                    tmp_y = traj(mmm,2);
                    % 找 u , v
                    tmp_u = flow.Vx(tmp_y,tmp_x);
                    tmp_v = flow.Vy(tmp_y,tmp_x);
                    xxx = tmp_x + tmp_u;
                    yyy = tmp_y + tmp_v;
                    % 如果超出邊界，就等於邊界                  
                    if xxx < 1
                        xxx = 1;
                    end
                    if yyy < 1
                        yyy = 1;
                    end
                    if xxx > 320
                        xxx = 320;
                    end
                    if yyy > 240
                        yyy = 240;
                    end
                    traj(mmm,3) = xxx;
                    traj(mmm,4) = yyy;
                end
            else
                tmp_x = traj(:,2*k-1);
                tmp_y = traj(:,2*k);
                tmp_u = interp2(matrix_x,matrix_y,flow.Vx,tmp_x,tmp_y);
                tmp_v = interp2(matrix_x,matrix_y,flow.Vy,tmp_x,tmp_y);
                xxx = tmp_x + tmp_u;
                yyy = tmp_y + tmp_v;
                
                min_x = xxx < 1;
                max_x = xxx > 320;
                min_y = yyy < 1;
                max_y = yyy > 240;
                xxx(min_x) = 1;
                xxx(max_x) = 320;
                yyy(min_y) = 1;
                yyy(max_y) = 240;

                traj(:,2*k-1+2) = xxx;
                traj(:,2*k+2) = yyy;
            end
        end
        for mmm = 1 : size(traj,1)
            tmp_xxx = traj(mmm,end-1);
            tmp_yyy = traj(mmm,end);
            if (tmp_xxx == 1 || tmp_yyy == 1 || tmp_xxx == 320 || tmp_yyy == 240)
                out_index = [out_index; 0];
            else
                out_index = [out_index; 1];
            end
        end
        traj = traj(logical(out_index),:);
%         save(sprintf('%s\\one2end_traj\\%d_%d.mat',conf.videopath,vi,j),'traj');
%         fprintf('%s\\one2end_traj\\%d_%d.mat\n',conf.videopath,vi,j);
        % decompose traj
        U = traj(:,1:2:size(traj,2)-1);
        V = traj(:,2:2:size(traj,2));
        TRAJ = [U V];
        [video_TrajAc,video_outindex,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,pervideo_TrajOutE] = MotionDecomp(TRAJ,1);
        % t sne
        train_X = [video_TrajOut; video_TrajIn(1:10:end,:)];
        train_labels = [zeros(size(video_TrajOut,1),1); ones(round(size(video_TrajIn,1)/10),1)];
        mappedX = tsne(train_X, [], 2, [], 30);
        gscatter(mappedX(:,1), mappedX(:,2), train_labels);
        fprintf('decompose finish\n');
        % plot traj and save
%         outputvideo = VideoWriter(sprintf('%s\\one2end_show_traj_videos\\%d_%d.avi',conf.videopath,vi,j));
        fullvideo = VideoWriter(sprintf('%s\\brox_traj\\%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(fullvideo);
        for k = 2 : endframe - 1
            figure(1)
            thisframe = read(mov,k);
            imshow(thisframe,'border','tight');hold on
            figure(2)
            thisframe = read(mov,k);
            imshow(thisframe,'border','tight');hold on
            % 畫線 or 箭頭?
            figure(1)
            line_x = video_TrajOut(:,2:k+1);
            line_y = video_TrajOut(:,size(video_TrajOut,2)/2+2:size(video_TrajOut,2)/2+k+1);
            line(line_x',line_y','Color','green');
            image1 = getframe(gcf);
            clf
            figure(2)
            line_x = TRAJ(1:100:end,2:k+1);
            line_y = TRAJ(1:100:end,size(TRAJ,2)/2+2:size(TRAJ,2)/2+k+1);
            line(line_x',line_y','Color','green');
            image2 = getframe(gcf);
            image = cat(2,image1.cdata,image2.cdata);
            writeVideo(fullvideo,image);
            clf
        end
        close(fullvideo);
    end
end

