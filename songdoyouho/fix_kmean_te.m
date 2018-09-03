actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
trajlength = conf.trajlength;

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
        fid = fopen(sprintf('%s\\fix_decompose_traj\\Et_center%d_%d.txt',conf.videopath,vi,j),'wt');
        for k = 1 : endframe - trajlength
            load(sprintf('%s\\fix_decompose_traj\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+trajlength));
            tmp_traj = video_TrajEt(:,1:trajlength * 2);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
                tic
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/10));
                toc
                center = C;

                for iii = 1 : size(center,1)
                    for jjj = 1 : size(center,2)
                        fprintf(fid, '%f ', center(iii,jjj));
                    end
                    fprintf(fid,'%d',k);
                    fprintf(fid,'\n');
                end
            else
                for iii = 1 : size(video_TrajEt,1)
                    for jjj = 1 : size(video_TrajEt,2) - 1
                        fprintf(fid, '%f ', video_TrajEt(iii,jjj));
                    end
                    fprintf(fid,'%d',k);
                    fprintf(fid,'\n');
                end
            end
        end        
        fclose(fid);
    end
end