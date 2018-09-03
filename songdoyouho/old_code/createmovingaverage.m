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
		% 上面都是load encoding per frame fisher vector，把每一張frame排起來
		% 直的(行)是時間軸 t 橫的是 FV
		
		% if 裡面是前 k 張 frame 做 average，else拿前面50張frame做average
		% 50是區間，可以弄一個變數來改
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        movingaverage=[];
        for k=1:size(allencoding,1)
            mean = sum(allencoding(1:k,:),1) / k;
            if k <= 50
                movingaverage=[movingaverage; mean];
            else
                average=sum(allencoding(k-49:k,:)) / 50;
                movingaverage=[movingaverage; average];
            end
        end		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% 這個部分應該要寫在darwin的code裡面，把原本timevarymean那段換掉
		% input一樣放原本的per frame FV
		
        clear allencoding;
        save(sprintf('%s\\movingaverage\\movingaverage%d_%d.mat',conf.tmppath,vi,j),'movingaverage');
        W3 = VideoDarwin(movingaverage);
        clear movingaverage;
        W3 = W3';
        save(sprintf('%s\\W3\\W3%d_%d.mat',conf.tmppath,vi,j),'W3');
        clear W3;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\allencoding\\allencoding%d_%d.mat', conf.tmppath, vi, j));
        fprintf('%s\\allencoding\\allencoding%d_%d.mat\n', conf.tmppath, vi, j);
        movingaverage=[];
        for k=1:size(allencoding,1)
            mean = sum(allencoding(1:k,:),1) / k;
            if k <= 50
                movingaverage=[movingaverage; mean];
            else
                average=sum(allencoding(k-49:k,:)) / 50;
                movingaverage=[movingaverage; average];
            end
        end
        clear allencoding;
        save(sprintf('%s\\movingaverage\\movingaverage%d_%d.mat',conf.tmppath,vi,j),'movingaverage');
        W3 = VideoDarwin(movingaverage);
        clear movingaverage;
        W3 = W3';
        save(sprintf('%s\\W3\\W3%d_%d.mat',conf.tmppath,vi,j),'W3');
        clear W3;
    end
end