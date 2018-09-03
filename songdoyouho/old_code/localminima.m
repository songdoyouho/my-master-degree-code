%plot darwin score and get keyframes
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% vi=1;
% j=1;
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
        
        % 算 score 的正負號改變
        keyframe=[];
        init=0;
        for k=2:size(score,1)
            if k==2 % initial sign
                d=score(k,1)-score(k-1,1);
                nowsai=sign(d);
                beforesai=nowsai;
            else
                beforesai=nowsai;
                d=score(k,1)-score(k-1,1);
                nowsai=sign(d);
            end
            if nowsai~=beforesai % 有正負號改變
                if init == 0
                    figure(1)
                    plot(k-1,score(k-1,1),'+'); % 畫在圖上
                    keyframe=[keyframe; k-1];
                    init=1;
                else
                    check=k-1-keyframe;
                    if check(size(check,1),1) >= 20
                        figure(1)
                        plot(k-1,score(k-1,1),'+'); % 畫在圖上
                        keyframe=[keyframe; k-1];
                    end
                end
            end
        end
        % save picture
        mkdir(sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d', vi,j));
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d.jpg', vi, j));
        % 加15拿到真正的frame index
        keyframe=keyframe+15;
        %keyframe=[keyframe; size(timevarymean,1)+15];
        save(sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\signkeyframe%d_%d.mat', vi, j),'keyframe');
        % show
        figure(2);
        mov = VideoReader(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\%d_%d.avi', vi, j));
        numberOfFrames = mov.NumberOfFrames;
        for frame=1:numberOfFrames
            thisframe=read(mov, frame);
            figure(2);
            imshow(thisframe);
            figure(1);
            aaa=intersect(frame,keyframe);
            if isempty(aaa)==0; % plot key frame position
                plot(t(frame-15,1),score(frame-15,1),'b+');
                hold on;
                % save picture
                figure(2);
                saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d\\%d.jpg', vi, j, frame));
            else
                pause(0.00001);
            end
        end
        figure(1);
        clf;
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
        
        % 算 score 的正負號改變
        keyframe=[];
        init=0;
        for k=2:size(score,1)
            if k==2 % initial sign
                d=score(k,1)-score(k-1,1);
                nowsai=sign(d);
                beforesai=nowsai;
            else
                beforesai=nowsai;
                d=score(k,1)-score(k-1,1);
                nowsai=sign(d);
            end
            if nowsai~=beforesai % 有正負號改變
                if init == 0
                    figure(1)
                    plot(k-1,score(k-1,1),'+'); % 畫在圖上
                    keyframe=[keyframe; k-1];
                    init=1;
                else
                    check=k-1-keyframe;
                    if check(size(check,1),1) >= 20
                        figure(1)
                        plot(k-1,score(k-1,1),'+'); % 畫在圖上
                        keyframe=[keyframe; k-1];
                    end
                end
            end
        end
        % save picture
        mkdir(sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d', vi,j));
        saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d.jpg', vi, j));
        % 加15拿到真正的frame index
        keyframe=keyframe+15;
        %keyframe=[keyframe; size(timevarymean,1)+15];
        save(sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\signkeyframe%d_%d.mat', vi, j),'keyframe');
        % show
        figure(2);
        mov = VideoReader(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\%d_%d.avi', vi, j));
        numberOfFrames = mov.NumberOfFrames;
        for frame=1:numberOfFrames
            thisframe=read(mov, frame);
            figure(2);
            imshow(thisframe);
            figure(1);
            aaa=intersect(frame,keyframe);
            if isempty(aaa)==0; % plot key frame position
                plot(t(frame-15,1),score(frame-15,1),'b+');
                hold on;
                % save picture
                figure(2);
                saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\plotsignscore\\%d_%d\\%d.jpg', vi, j, frame));
            else
                pause(0.00001);
            end
        end
        figure(1);
        clf;
        
    end
end
close all;