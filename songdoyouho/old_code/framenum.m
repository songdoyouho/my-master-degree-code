actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
info = [];
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        info=[info; vi j endframe];
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        info=[info; vi j endframe];
    end
end