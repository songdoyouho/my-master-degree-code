%plot darwin score and get keyframes
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\timevarymean%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\W2%d_%d.mat',conf.modelpath,vi,j));

        WWW=W2(1,1:109056);
        score=timevarymean*WWW';

        t=1:size(score,1);
        t=t';
        figure(1);
        plot(t,score);
        hold on;

        % 算斜率，以10張frame為單位
        allrate=[];
        for jj=1:fix(size(score,1)/10)
            rate=(score(jj*10,1)-score(jj*10-9,1))/10;
            allrate=[allrate; rate];
        end
        ttt=0;
        keyframe=[];
        for k=1:size(allrate,1)-1
            ttt=ttt+10;
            if abs(allrate(k+1,1)-allrate(k,1)) >= 0.2
                figure(1)
                plot(ttt,score(ttt,1),'*');
                hold on;
                keyframe=[keyframe; ttt];
            end
        end
        % save picture
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotscore\\%d_%d.jpg', vi, j));
        clf
        % 加15拿到真正的frame index
        keyframe=keyframe+15;
        keyframe=[keyframe; size(timevarymean,1)+15];
        save(sprintf('%s\\keyframe0.2%d_%d.mat', conf.keyframepath, vi, j),'keyframe');
        % show
        %         figure(2);
        %         mov = VideoReader(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\%d_%d.avi', vi, j));
        %         numberOfFrames = mov.NumberOfFrames;
        %         for frame=1:numberOfFrames
        %             thisframe=read(mov, frame);
        %             figure(2);
        %             imshow(thisframe);
        %             figure(1);
        %             aaa=intersect(frame,keyframe);
        %             if isempty(aaa)==0; % plot key frame position
        %                 plot(t(frame-15,1),score(frame-15,1),'b+');
        %                 hold on;
        %             else
        %                 pause(0.1);
        %             end
        %         end
        %         figure(1);
        %         clf;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\timevarymean%d_%d.mat',conf.tmppath,vi,j));
        load(sprintf('%s\\W2%d_%d.mat',conf.modelpath,vi,j));

        WWW=W2(1,1:109056);
        score=timevarymean*WWW';

        t=1:size(score,1);
        t=t';
        figure(1);
        plot(t,score);
        hold on;

        % 算斜率，以10張frame為單位
        allrate=[];
        for jj=1:fix(size(score,1)/10)
            rate=(score(jj*10,1)-score(jj*10-9,1))/10;
            allrate=[allrate; rate];
        end
        ttt=0;
        keyframe=[];
        for k=1:size(allrate,1)-1
            ttt=ttt+10;
            if abs(allrate(k+1,1)-allrate(k,1)) >= 0.2
                figure(1)
                plot(ttt,score(ttt,1),'*');
                hold on;
                keyframe=[keyframe; ttt];
            end
        end
        % save picture
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotscore\\%d_%d.jpg', vi, j));
        clf

        % 加15拿到真正的frame index
        keyframe=keyframe+15;
        keyframe=[keyframe; size(timevarymean,1)+15];
        save(sprintf('%s\\keyframe0.2%d_%d.mat', conf.keyframepath, vi, j),'keyframe');
        % show
        %         figure(2);
        %         mov = VideoReader(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\%d_%d.avi', vi, j));
        %         numberOfFrames = mov.NumberOfFrames;
        %         for frame=1:numberOfFrames
        %             thisframe=read(mov, frame);
        %             figure(2);
        %             imshow(thisframe);
        %             figure(1);
        %             aaa=intersect(frame,keyframe);
        %             if isempty(aaa)==0; % plot key frame position
        %                 plot(t(frame-15,1),score(frame-15,1),'b+');
        %                 hold on;
        %             else
        %                 pause(0.1);
        %             end
        %         end
        %         figure(1);
        %         clf;
    end
end
close all;