actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
featurenum=fix(256000/(conf.videonumber/2));
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));

all_local_traj = [];
all_global_traj = [];

show_video = 1;

global_FACTOR = 0.1;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load invalid dense traj
        load(sprintf('%s\\16frame_traj\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\16frame_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
        invalid_dense_traj = X;
        % load valid improved traj
%         load(sprintf('%s\\valid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\valid_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         valid_improved_traj = X;
        
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        if show_video ==1
%             global_outputvideo = VideoWriter(sprintf('%s\\global_outputvideo\\%d_%d.avi',conf.videopath,vi,j));
%             global_outputvideo.FrameRate = 10;
%             open(global_outputvideo);
%             local_outputvideo = VideoWriter(sprintf('%s\\local_outputvideo\\%d_%d.avi',conf.videopath,vi,j));
%             local_outputvideo.FrameRate = 10;
%             open(local_outputvideo);
            original_outputvideo = VideoWriter(sprintf('%s\\original_outputvideo\\%d_%d.avi',conf.videopath,vi,j));
            original_outputvideo.FrameRate = 10;
            open(original_outputvideo);
        end
        % motion decomp
        X1 = invalid_dense_traj(:,2:33);
        U = X1(:,1:2:31);
        V = X1(:,2:2:32);
        Traj = [U V];
        [global_TrajAc,perc,global_inindex,global_outindex,global_EE,global_outinds,global_TrajOut,global_TrajIn,global_TrajOutLow,global_TrajOutE]...
        = MotionDecomp(Traj,global_FACTOR); % 取 global_inindex
%         local_invalid_dense_traj = invalid_dense_traj(global_outindex,:);
        % 這邊寫txt output，要加入frame num跟iscale
%         fid = fopen(sprintf('%s\\output_global_and_local_traj\\global_traj_%d_%d.txt',conf.videopath,vi,j),'w');
% %         fprintf(fid,'%d %d\n',size(global_TrajAc,1),size(global_TrajAc,2)+2);
%         for iii = 1 : size(global_TrajAc,1)
%             for jjj = 1 : size(global_TrajAc,2)
%                 if jjj == 1
%                     fprintf(fid,'%d ',invalid_dense_traj(iii,1));
%                 end
%                 fprintf(fid,'%f ',global_TrajAc(iii,jjj));
%                 if jjj == size(global_TrajAc,2)
%                     fprintf(fid,'%d ',invalid_dense_traj(iii,430));
%                     fprintf(fid,'\n');
%                 end
%             end
%         end
%         fclose(fid);
%         fid = fopen(sprintf('%s\\output_global_and_local_traj\\local_traj_%d_%d.txt',conf.videopath,vi,j),'w');
% %         fprintf(fid,'%d %d\n',size(global_TrajOutE,1),size(global_TrajOutE,2)+2);
%         for iii = 1 : size(global_TrajOutE,1)
%             for jjj = 1 : size(global_TrajOutE,2)
%                 if jjj == 1
%                     fprintf(fid,'%d ',local_invalid_dense_traj(iii,1));
%                 end
%                 fprintf(fid,'%f ',global_TrajOutE(iii,jjj));
%                 if jjj == size(global_TrajOutE,2)
%                     fprintf(fid,'%d ',local_invalid_dense_traj(iii,430));
%                     fprintf(fid,'\n');
%                 end
%             end
%         end
%         fclose(fid);
        
        final_invalid_dense_traj = invalid_dense_traj(global_inindex,:);
        
        local_invalid_dense_traj = invalid_dense_traj(global_outindex,:);
        
        if show_video == 1
            for k = startframe : endframe
                thisframe = read(mov,k);
                figure(1)
                imshow(thisframe,'border','tight');
                hold on
%                 figure(2)
%                 imshow(thisframe,'border','tight');
%                 hold on
%                 figure(3)
%                 imshow(thisframe,'border','tight');
%                 hold on
%                 figure(4)
%                 imshow(thisframe,'border','tight');
%                 hold on
%                 % this frame
                index=invalid_dense_traj(:,1)==k;
                tmpX=invalid_dense_traj(index,:);
                figure(1)
                text(1, 5, 'all traj');
                plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
                U = tmpX(:,2:2:32);
                V = tmpX(:,3:2:33);
                line(U',V','Color','green');
                %     pause(0.5);
                pervideo_image1 = getframe(gcf);
                clf
                writeVideo(original_outputvideo,pervideo_image1);
%                 figure(2) % selected traj
%                 text(1, 5, 'foreground traj');
%                 index=local_invalid_dense_traj(:,1)==k;
%                 now_tmpX=local_invalid_dense_traj(index,:);
%                 %     plot(tmpX(:,2),tmpX(:,3),'g*'); hold on
%                 plot(now_tmpX(:,30),now_tmpX(:,31),'r*'); hold on
%                 U = now_tmpX(:,2:2:30);
%                 V = now_tmpX(:,3:2:31);
%                 line(U',V','Color','yellow');
%                 %     pause(0.5);
%                 pervideo_image2 = getframe(gcf);
%                 clf
%                 figure(3)
%                 text(1, 5, 'camera component traj');
%                 index=invalid_dense_traj(:,1)==k;
%                 now_tmpX=global_TrajAc(index,:);
%                 plot(now_tmpX(:,16),now_tmpX(:,32),'r*'); hold on
%                 %     plot(TrajOutLow(:,1),TrajOutLow(:,16),'g*'); hold on
%                 U = now_tmpX(:,1:16);
%                 V = now_tmpX(:,17:32);
%                 line(U',V','Color','green');
%                 %     pause(0.5);
%                 TrajOutLow_image = getframe(gcf);
%                 clf
%                 writeVideo(global_outputvideo,TrajOutLow_image);
%                 figure(4)
%                 text(1, 5, 'object component traj');
%                 index=local_invalid_dense_traj(:,1)==k;
%                 now_tmpX=global_TrajOutE(index,:);
%                 plot(now_tmpX(:,16),now_tmpX(:,32),'r*'); hold on
%                 %     plot(TrajOutE(:,1),TrajOutE(:,16),'r*'); hold on
%                 U = now_tmpX(:,1:16);
%                 V = now_tmpX(:,17:32);
%                 line(U',V','Color','yellow');
%                 %     pause(0.5);
%                 TrajOutE_image = getframe(gcf);
%                 clf
%                 writeVideo(local_outputvideo,TrajOutE_image);
%                 image1 = cat(2,pervideo_image1.cdata,pervideo_image2.cdata);
%                 image2 = cat(2,TrajOutLow_image.cdata,TrajOutE_image.cdata);
%                 image = cat(1,image1,image2);
%                 writeVideo(outputvideo,image);
%                 clf
            end
%             close(outputvideo);
        end
%         save(sprintf('%s\\going_to_encoding_traj\\global_feature%d_%d.mat', conf.videopath, vi, j),'final_invalid_dense_traj');
        
        % select feature for training GMM
%         if size(final_invalid_dense_traj,1)<featurenum
%             all_global_traj = [all_global_traj; final_invalid_dense_traj];
%         else
%             idid=randperm(size(final_invalid_dense_traj,1),featurenum);
%             X_idx = 1:size(final_invalid_dense_traj,1);
%             idx = ismember(X_idx,idid);
%             idx=idx';
%             final_invalid_dense_traj = final_invalid_dense_traj(idx,:);
%             all_global_traj = [all_global_traj; final_invalid_dense_traj];
%         end
        
%         all_global_traj = [all_global_traj; final_invalid_dense_traj];
        
%         X1 = valid_improved_traj(:,2:31);
%         U = X1(:,1:2:29);
%         V = X1(:,2:2:30);
%         Traj = [U V];
%         [local_TrajAAc,perc,local_inindex,local_outindex,local_EE,local_outinds,local_TrajOut,local_TrajIn,local_TrajOutLow,local_TrajOutE]...
%         = MotionDecomp(Traj,FACTOR); % 取 local_outindex       
%     
%         final_valid_improved_traj = valid_improved_traj(local_outindex,:);
%         
%         save(sprintf('%s\\going_to_encoding_traj\\local_feature%d_%d.mat', conf.videopath, vi, j),'final_valid_improved_traj');
%         
%         all_local_traj = [all_local_traj; final_valid_improved_traj];       
    end
end

