% 把dogcentric影片轉成圖片
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mkdir(sprintf('E:\\dogcentric_images\\%d_%d',vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        numberOfFrames = mov.NumberOfFrames;
        for k=15:numberOfFrames
            thisFrame = read(mov, k);
            imwrite(thisFrame,sprintf('E:\\dogcentric_images\\%d_%d\\%d.jpg',vi,j,k),'jpg');
        end
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mkdir(sprintf('E:\\dogcentric_images\\%d_%d',vi,j));
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        numberOfFrames = mov.NumberOfFrames;
        for k=15:numberOfFrames
            thisFrame = read(mov, k);
            imwrite(thisFrame,sprintf('E:\\dogcentric_images\\%d_%d\\%d.jpg',vi,j,k),'jpg');
        end
    end
end