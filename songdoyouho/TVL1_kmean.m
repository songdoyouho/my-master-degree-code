actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
%         cccount = 0;
        fid = fopen(sprintf('%s\\new_decompose_traj_thr_0.1\\Et_center%d_%d.txt',conf.videopath,vi,j),'wt');
        for k = 1 : endframe - 16
            load(sprintf('%s\\new_decompose_traj_thr_0.1\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
            tmp_traj = video_TrajEt(:,1:32);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
                tic
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/10));
                toc
                center = C;
%                   center = tmp_traj;
                
%                 size(center,1)
%                 fix(size(tmp_traj,1)/10)
%                 cccount = cccount + size(center,1);
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

% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
%         fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
%         endframe = mov.NumberOfFrames;
%         fid = fopen(sprintf('%s\\new_decompose_traj\\center%d_%d.txt',conf.videopath,vi,j),'wt');
%         for k = 1 : endframe - 16
%             load(sprintf('%s\\new_decompose_traj\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
%             tmp_traj = video_TrajEt(:,1:32);
%             if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
%                 tic
%                 [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/100));
%                 toc
%                 center = C;
%                 for iii = 1 : size(center,1)
%                     for jjj = 1 : size(center,2)
%                         fprintf(fid, '%f ', center(iii,jjj));
%                     end
%                     fprintf(fid,'%d',k);
%                     fprintf(fid,'\n');
%                 end
%             else
%                 for iii = 1 : size(video_TrajEt,1)
%                     for jjj = 1 : size(video_TrajEt,2) - 1
%                         fprintf(fid, '%f ', video_TrajEt(iii,jjj));
%                     end
%                     fprintf(fid,'%d',k);
%                     fprintf(fid,'\n');
%                 end
%             end
%         end        
%         fclose(fid);
%     end
% end

%%
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         a = load(sprintf('%s\\new_decompose_traj\\%d_%d.txt',conf.videopath,vi,j));
%         fprintf('%s\\new_decompose_traj\\%d_%d.txt\n',conf.videopath,vi,j);
%         fid = fopen(sprintf('%s\\new_decompose_traj\\center%d_%d.txt',conf.videopath,vi,j),'wt');
%         for kkk = 1 : 5 : a(size(a,1),size(a,2))
%             index = a(:,size(a,2)) == kkk;
%             tmpa = a(index,1:size(a,2)-1);
%             if isempty(tmpa) == 0 && size(tmpa,1) >= 100
%                 [L,C] = newkmeans(tmpa',fix(size(tmpa,1)/10));
%                 center = C';
%                 for iii = 1 : size(center,1)
%                     for jjj = 1 : size(center,2)
%                         fprintf(fid, '%f ', center(iii,jjj));
%                     end
%                     fprintf(fid,'%d',kkk);
%                     fprintf(fid,'\n');
%                 end
%             else
%                 for iii = 1 : size(tmpa,1)
%                     for jjj = 1 : size(tmpa,2)
%                         fprintf(fid, '%f ', tmpa(iii,jjj));
%                     end
%                     fprintf(fid,'%d',kkk);
%                     fprintf(fid,'\n');
%                 end
%             end
%         end
%         fclose(fid);
%     end
% end
% 
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         a = load(sprintf('%s\\new_decompose_traj\\%d_%d.txt',conf.videopath,vi,j));
%         fprintf('%s\\new_decompose_traj\\%d_%d.txt\n',conf.videopath,vi,j);
%         fid = fopen(sprintf('%s\\new_decompose_traj\\center%d_%d.txt',conf.videopath,vi,j),'wt');
%         for kkk = 1 : 5 : a(size(a,1),size(a,2))
%             index = a(:,size(a,2)) == kkk;
%             tmpa = a(index,1:size(a,2)-1);
%             if isempty(tmpa) == 0 && size(tmpa,1) >= 100
%                 [L,C] = newkmeans(tmpa',fix(size(tmpa,1)/10));
%                 center = C';
%                 for iii = 1 : size(center,1)
%                     for jjj = 1 : size(center,2)
%                         fprintf(fid, '%f ', center(iii,jjj));
%                     end
%                     fprintf(fid,'%d',kkk);
%                     fprintf(fid,'\n');
%                 end
%             else
%                 for iii = 1 : size(tmpa,1)
%                     for jjj = 1 : size(tmpa,2)
%                         fprintf(fid, '%f ', tmpa(iii,jjj));
%                     end
%                     fprintf(fid,'%d',kkk);
%                     fprintf(fid,'\n');
%                 end
%             end
%         end
%         fclose(fid);
%     end
% end