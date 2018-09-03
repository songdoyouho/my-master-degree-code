zactnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath ('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\Oreifej_RPCA\\RASL_toolbox\\');
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         startframe=X(1,1);
%         endframe=X(size(X,1),1);
%         traj = X(:,2:31);
%         Traj = [];
%         for loop = 1:15
%             Traj = [Traj traj(:,2*loop-1)];
%         end
%         for loop = 1:15
%             Traj = [Traj traj(:,2*loop)];
%         end
%         [outindS,inindS,TrajOut,TrajIn,TrajOutLow,TrajOutE] =  MotionDecomp(Traj,1); % 要設thr，把index取出來
%         tmp = 1:size(X,1);
%         [qwe asd tmpp] = intersect(outindS,tmp);
%         tmppp = zeros(size(tmp));
%         tmppp(tmpp)=1;
%         selected_X = X(logical(tmppp)',:);
%         for k=startframe:endframe
%             thisFrame = read(mov, k);
%             imshow(thisFrame,'border','tight','initialmagnification','fit');
%             hold on
%              % take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
%             selected_index=selected_X(:,1)==k;
%             now_selected_tmpX=selected_X(selected_index,:);
%             plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
%             plot(now_selected_tmpX(:,2),now_selected_tmpX(:,3),'r*');  hold on
%             pause(0.001);
%         end
%         clf;
%     end
% end
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load features
        load(sprintf('F:\\densetraj\\feature%d_%d.mat', vi, j));
        fprintf('F:\\densetraj\\feature%d_%d.mat\n', vi, j);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         outputvideo = VideoWriter(sprintf('%s\\large_selection\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
%         open(outputvideo);
        startframe=X(1,1);
        endframe=X(size(X,1),1);
        
        for k=startframe:endframe
            thisFrame = read(mov, k);
            imshow(thisFrame,'border','tight','initialmagnification','fit');
            hold on
            % take this frame's feature out
            index=X(:,1)==k;
            now_tmpX=X(index,:);
            
            traj = now_tmpX(:,2:31);
            Traj = [];
            for loop = 1:15
                Traj = [Traj traj(:,2*loop-1)];
            end
            for loop = 1:15
                Traj = [Traj traj(:,2*loop)];
            end
            if size(now_tmpX,1) < 10
                now_selected_tmpX = now_tmpX;
            else
%                 [outindS,inindS,TrajOut,TrajIn,TrajOutLow,TrajOutE] =  MotionDecomp(Traj,5); % 要設thr，把index取出來
                EE = MotionDecomp(Traj,5);
                [aaa, bbb] = sort(EE,'ascend');
                tmp = 1:size(now_tmpX,1);
                [qwe ,asd, tmpp] = intersect(bbb(1,1:fix(size(bbb,2)/2)),tmp);
                tmppp = zeros(size(tmp));
                tmppp(tmpp)=1;
                selected_X = now_tmpX(logical(tmppp)',:);
                selected_index=selected_X(:,1)==k;
                now_selected_tmpX=selected_X(selected_index,:);
            end
            plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
            plot(now_selected_tmpX(:,2),now_selected_tmpX(:,3),'r*');  hold on
            pause(0.001);
%             image = getframe(gcf);
%             writeVideo(outputvideo,image);
        end
%         close(outputvideo);
        clf;
    end
end

% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         % load features
%         load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
%         fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         outputvideo = VideoWriter(sprintf('%s\\large_selection\\%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
%         open(outputvideo);
%         startframe=X(1,1);
%         endframe=X(size(X,1),1);
%         
%         for k=startframe:endframe
%             thisFrame = read(mov, k);
%             imshow(thisFrame,'border','tight','initialmagnification','fit');
%             hold on
%             % take this frame's feature out
%             index=X(:,1)==k;
%             now_tmpX=X(index,:);
%             
%             traj = now_tmpX(:,2:31);
%             Traj = [];
%             for loop = 1:15
%                 Traj = [Traj traj(:,2*loop-1)];
%             end
%             for loop = 1:15
%                 Traj = [Traj traj(:,2*loop)];
%             end
%             if size(now_tmpX,1) < 10
%                 now_selected_tmpX = now_tmpX;
%             else
% %                 [outindS,inindS,TrajOut,TrajIn,TrajOutLow,TrajOutE] =  MotionDecomp(Traj,5); % 要設thr，把index取出來
%                 EE = MotionDecomp(Traj,5);
%                 [aaa, bbb] = sort(EE,'ascend');
%                 tmp = 1:size(now_tmpX,1);
%                 [qwe ,asd, tmpp] = intersect(bbb(1,1:fix(size(bbb,2)/2)),tmp);
%                 tmppp = zeros(size(tmp));
%                 tmppp(tmpp)=1;
%                 selected_X = now_tmpX(logical(tmppp)',:);
%                 selected_index=selected_X(:,1)==k;
%                 now_selected_tmpX=selected_X(selected_index,:);
%             end
%             plot(now_tmpX(:,2),now_tmpX(:,3),'g*'); hold on
%             plot(now_selected_tmpX(:,2),now_selected_tmpX(:,3),'r*');  hold on
%             pause(0.001);
%             image = getframe(gcf);
%             writeVideo(outputvideo,image);
%         end
%         close(outputvideo);
%         clf;
%     end
% end