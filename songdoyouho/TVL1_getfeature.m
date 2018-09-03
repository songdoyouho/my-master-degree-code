actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

cd(sprintf('%s\\fix_decompose_traj',conf.videopath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        fprintf('fix_iscameramotion_no_homo.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt\n',vi ,j ,vi ,j,vi , j);
        system(sprintf('fix_iscameramotion_no_homo.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt',vi ,j ,vi ,j,vi , j));
    end
end


for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        X=load(sprintf('%s\\fix_decompose_traj\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\fix_decompose_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
        save(sprintf('%s\\fix_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end

cd C:\Users\diesel\Desktop\songdoyouho