function [  ] = performkmean( conf, cluster )
%PERFORMKMEAN Summary of this function goes here
% fastkmean code using euclidean distance
% output form is the same as the input
% traj form = x1 x2 x3 ...x16 y1 y2 y3... y16 t
% use the traj Et
%   Detailed explanation goes here

actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;
trajlength=conf.trajlength;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
        fid = fopen(sprintf('%s\\new_decompose_traj\\Et_center%d_%d.txt',conf.videopath,vi,j),'wt');
        for k = 1 : endframe - trajlength
            load(sprintf('%s\\new_decompose_traj\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+trajlength-1));
            tmp_traj = video_TrajEt(:,1:trajlength*2);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
%                 tic
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/cluster)); % use euclidean distance and the cluster num is /10 of the traj num
%                 toc
                center = C;
                % save center
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
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
        fid = fopen(sprintf('%s\\new_decompose_traj\\Et_center%d_%d.txt',conf.videopath,vi,j),'wt');
        for k = 1 : endframe - trajlength
            load(sprintf('%s\\new_decompose_traj\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+trajlength-1));
            tmp_traj = video_TrajEt(:,1:trajlength*2);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
%                 tic
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/cluster)); % use euclidean distance and the cluster num is /10 of the traj num
%                 toc
                center = C;
                % save center
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
end

