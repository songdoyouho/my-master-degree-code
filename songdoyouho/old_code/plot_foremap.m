actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
opticFlow = opticalFlowFarneback;
addpath ('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\Oreifej_RPCA\\RASL_toolbox\\');
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        outputvideo = VideoWriter(sprintf('%s\\large_selection\\fore_%d_%d.avi',conf.videopath,vi,j),'Uncompressed AVI');
        open(outputvideo);
        numframe = mov.NumberOfFrames;
        width = mov.Width;
        height = mov.Height;
        U = [];
        V = [];
        for iii = 1 : width
            for jjj = 1 : height
                U(jjj,iii) = iii;
            end
        end
        for jjj = 1 : height
            for iii = 1 : width
                V(jjj,iii) = jjj;
            end
        end
        U = reshape(U,[width*height 1]);
        pre_U = U;
        V = reshape(V,[width*height 1]);
        pre_V = V;
        traj = [];
        for k = 1 : numframe - 1
            thisFrame = read(mov, k);
            frameGray = rgb2gray(thisFrame);
            % get optical flow
            flow = estimateFlow(opticFlow,frameGray);
            Vx = reshape(flow.Vx,[size(flow.Vx,1)*size(flow.Vx,2) 1]);
            Vy = reshape(flow.Vy,[size(flow.Vy,1)*size(flow.Vy,2) 1]);
            now_U = pre_U + Vx;
            set_zero = find(now_U<0);
            now_U(set_zero,:)=0;
            set_max = find(now_U>width);
            now_U(set_max,:)=width;
            now_V = pre_V + Vy;
            set_zero = find(now_V<0);
            now_V(set_zero,:)=0;
            set_max = find(now_V>height);
            now_V(set_max,:)=height;
            pre_U = now_U;
            pre_V = now_V;
            U = cat(2,U,now_U);
            V = cat(2,V,now_V);
        end
        traj = [U V];
        load(sprintf('%s\\large_selection\\EE_%d_%d.mat',conf.videopath,vi,j));
        load(sprintf('%s\\large_selection\\E_%d_%d.mat',conf.videopath,vi,j));
        load(sprintf('%s\\large_selection\\A_%d_%d.mat',conf.videopath,vi,j));
        [ TrajOut,TrajOutLow,TrajOutE ] = after_EE( traj, EE, E, A, 2 );
        for k = 1 : numframe 
            black = zeros(height,width);
            figure(2)
            imshow(black,'border','tight','initialmagnification','fit');
            hold on
            plot(TrajOutE(:,k)',TrajOutE(:,numframe+k)','w.','MarkerSize','40');
            image = getframe(gcf);
            writeVideo(outputvideo,image);
        end
        close(outputvideo);
        clf;
        save(sprintf('%s\\large_selection\\EE_%d_%d.mat',conf.videopath,vi,j),'EE');
    end
end



%         [EE,outindS,inindS,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(traj,1000);
%         [aaa, bbb] = sort(EE,'descend');
%         tmp = 1:size(EE,2);
%         [qwe ,asd, tmpp] = intersect(bbb(1,1:fix(size(bbb,2)/2)),tmp);
%         tmppp = zeros(size(tmp));
%         tmppp(tmpp)=1;
%         final_traj = traj(logical(tmppp),:);

