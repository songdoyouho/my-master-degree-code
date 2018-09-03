function [  ] = getfeature( conf )
%GETFEATURE Summary of this function goes here
% compile iscameramotion_no_homo_1.cpp first 
% put iscameramotion_no_homo_1.exe and videos and Et_center?_?.txt in the same file
% the output is t x1 y1 x2 y2...x15 y15 disp_x1 disp_y1...disp_x15 disp_y15 HOG HOF MBHX MBHY 
%   Detailed explanation goes here
actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;

cd(sprintf('%s\\new_decompose_traj',conf.videopath));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        fprintf('iscameramotion_no_homo_1.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt\n',vi ,j ,vi ,j,vi , j);
        system(sprintf('iscameramotion_no_homo_1.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt',vi ,j ,vi ,j,vi , j));
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        fprintf('iscameramotion_no_homo_1.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt\n',vi ,j ,vi ,j,vi , j);
        system(sprintf('iscameramotion_no_homo_1.exe %d_%d.avi feature%d_%d.txt Et_center%d_%d.txt',vi ,j ,vi ,j,vi , j));
    end
end

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        X=load(sprintf('%s\\new_decompose_traj\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\new_decompose_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
        save(sprintf('%s\\new_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        X=load(sprintf('%s\\new_decompose_traj\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\new_decompose_traj\\feature%d_%d.txt\n', conf.videopath, vi, j);
        save(sprintf('%s\\new_decompose_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end

cd C:\Users\diesel\Desktop\songdoyouho
end

