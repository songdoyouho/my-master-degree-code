function [ ] = get_bbox( conf )
%GETBBOX Summary of this function goes here
%   Detailed explanation goes here
%   讀每部影片，拿到想要的bounding box，存下來

actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
numidx = 0;
pos=[];
neg=[];
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        numberOfFrames = mov.NumberOfFrames;
        for frame = 1 : numberOfFrames
            thisFrame = read(mov, frame);
            up = thisFrame(1:size(thisFrame,1)/2,:,:);
            down = thisFrame(size(thisFrame,1)/2+1:end,:,:);
            %             figure(1)
            %             imshow(up);
            figure(2)
            imshow(down);
            if mod(frame,50) == 0
                w = waitforbuttonpress;
                if w == 0
                    numidx=numidx+1;
                    rect = getrect;
                    rectangle('Position',rect,'EdgeColor','r','LineWidth',3);
                    imwrite(down, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx));
                    imwrite(up, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx));
                    pos(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx);
                    pos(numidx).x1 = rect(1,1);
                    pos(numidx).y1 = rect(1,2);
                    pos(numidx).x2 = rect(1,1) + rect(1,3);
                    pos(numidx).y2 = rect(1,2) + rect(1,4);
%                     neg(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx);
                else
                    neg(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx);
                end
            end
        end
    end
end
save('C:\Users\diesel\Desktop\train_car_images\pos.mat','pos');
save('C:\Users\diesel\Desktop\train_car_images\neg.mat','neg');
end

