actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        X=load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
        save(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        X=load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\invalid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
        save(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end
% 
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         X=load(sprintf('%s\\valid_dense_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\valid_dense_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\valid_dense_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         X=load(sprintf('%s\\valid_dense_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\valid_dense_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\valid_dense_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end

% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         X=load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\invalid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         X=load(sprintf('%s\\invalid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\invalid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\invalid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end

% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         X=load(sprintf('%s\\valid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\valid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\valid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         X=load(sprintf('%s\\valid_improved_traj\\feature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\valid_improved_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
%         save(sprintf('%s\\valid_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end