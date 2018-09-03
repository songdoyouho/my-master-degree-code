actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

addpath(genpath(conf.liblinear));
addpath(genpath(conf.videodarwin));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        meanminus=[];
        for k=1:size(allencoding,1)
            if k == 1
                mean = allencoding(1:k,:);
                meanminus=[meanminus; mean];
            else
                average=sum(allencoding(1:k-1,:),1) / (k-1);
                meanminus=[meanminus; allencoding(k,:)-average];
            end
        end
        clear allencoding;
        save(sprintf('%s\\meanminus\\meanminus%d_%d.mat',conf.tmppath,vi,j),'meanminus');
        W4 = VideoDarwin(meanminus);
        clear meanminus;
        W4 = W4';
        save(sprintf('%s\\W4\\W4%d_%d.mat',conf.tmppath,vi,j),'W4');
        clear W4;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        meanminus=[];
        for k=1:size(allencoding,1)
            if k == 1
                mean = allencoding(1:k,:);
                meanminus=[meanminus; mean];
            else
                average=sum(allencoding(1:k-1,:),1) / (k-1);
                meanminus=[meanminus; allencoding(k,:)-average];
            end
        end
        clear allencoding;
        save(sprintf('%s\\meanminus\\meanminus%d_%d.mat',conf.tmppath,vi,j),'meanminus');
        W4 = VideoDarwin(meanminus);
        clear meanminus;
        W4 = W4';
        save(sprintf('%s\\W4\\W4%d_%d.mat',conf.tmppath,vi,j),'W4');
        clear W4;
    end
end