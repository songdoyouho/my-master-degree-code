actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\seg0.2timevarymean%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\seg0.2W2%d_%d.mat',conf.modelpath,vi,j));
        load(sprintf('%s\\keyframe0.2%d_%d.mat',conf.keyframepath,vi,j));
        if size(keyframe,1)==1
            WWW=W2(1,1:109056);
            score=timevarymean*WWW';
            figure(1);
            t=1:size(timevarymean,1);
            plot(t,score);
            hold on;
        else
            WWW=W2(1,1:109056);
            score=timevarymean*WWW';
            figure(1);
            plot(keyframe,score);
            hold on;
        end
        % save picture
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsegscore\\%d_%d.jpg', vi, j));
        clf
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\seg0.2timevarymean%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\seg0.2W2%d_%d.mat',conf.modelpath,vi,j));
        load(sprintf('%s\\keyframe0.2%d_%d.mat',conf.keyframepath,vi,j));
        if size(keyframe,1)==1
            WWW=W2(1,1:109056);
            score=timevarymean*WWW';
            figure(1);
            t=1:size(timevarymean,1);
            plot(t,score);
            hold on;
        else
            WWW=W2(1,1:109056);
            score=timevarymean*WWW';
            figure(1);
            plot(keyframe,score);
            hold on;
        end
        % save picture
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsegscore\\%d_%d.jpg', vi, j));
        clf
    end
end
close all;