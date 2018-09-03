function [  ] = getfeature( conf )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
oldpath=pwd;
path=conf.videopath;
cd (path);
actionidx=1;
videoidx=1;
while(exist(sprintf('%d_%d.avi', actionidx, videoidx),'file')==2)
    while(exist(sprintf('%d_%d.avi', actionidx, videoidx), 'file')==2)
        % first do it once
        fprintf('getfeature %d_%d.avi feature%d_%d.txt .......\n', actionidx, videoidx, actionidx, videoidx);
        system(sprintf('getfeature %d_%d.avi feature%d_%d.txt', actionidx,videoidx, actionidx, videoidx));
%         if videoidx==5||videoidx==7
%             fprintf('sqrt %d_%d.avi feature%d_%d.txt .......\n', actionidx, videoidx, actionidx, videoidx);
%             system(sprintf('sqrt %d_%d.avi feature%d_%d.txt', actionidx,videoidx, actionidx, videoidx));
%         end
        videoidx=videoidx+1;
    end
    videoidx=1;
    actionidx=actionidx+1;
end
cd (oldpath);
end

