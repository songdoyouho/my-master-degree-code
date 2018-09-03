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
        frameaverage=zeros(size(allencoding,1)*2,size(allencoding,2));
        for k=1:size(allencoding,1)
            if k==size(allencoding,1)
                frameaverage=[allencoding(k,:); allencoding(k,:)];
            else
                average=(allencoding(k,:) + allencoding(k+1,:)) / 2;
                frameaverage=[allencoding(k,:); average];
            end
        end
        clear allencoding;
        save(sprintf('%s\\frameaverage\\frameaverage%d_%d.mat',conf.tmppath,vi,j),'frameaverage');
        W5 = VideoDarwin(frameaverage);
        clear frameaverage;
        W5 = W5';
        save(sprintf('%s\\W5\\W5%d_%d.mat',conf.tmppath,vi,j),'W5');
        clear W5;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        frameaverage=zeros(size(allencoding,1)*2,size(allencoding,2));
        for k=1:size(allencoding,1)
            if k==size(allencoding,1)
                frameaverage=[allencoding(k,:); allencoding(k,:)];
            else
                average=(allencoding(k,:) + allencoding(k+1,:)) / 2;
                frameaverage=[allencoding(k,:); average];
            end
        end
        clear allencoding;
        save(sprintf('%s\\frameaverage\\frameaverage%d_%d.mat',conf.tmppath,vi,j),'frameaverage');
        W5 = VideoDarwin(frameaverage);
        clear frameaverage;
        W5 = W5';
        save(sprintf('%s\\W5\\W5%d_%d.mat',conf.tmppath,vi,j),'W5');
        clear W5;
    end
end