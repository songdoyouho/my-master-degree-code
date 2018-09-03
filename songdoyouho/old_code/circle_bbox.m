%   用滑鼠把bbox框出來
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
            %             up = thisFrame(1:size(thisFrame,1)/2,:,:);
            %             down = thisFrame(size(thisFrame,1)/2+1:end,:,:);
            %             figure(1)
            %             imshow(up);
            figure(2)
            %             imshow(down);
            imshow(thisFrame);
            if j==1
%                 if mod(frame,5) == 0
%                     w = waitforbuttonpress;
%                     if w == 0
%                         numidx=numidx+1;
%                         rect = getrect;
%                         rectangle('Position',rect,'EdgeColor','r','LineWidth',3);
%                         imwrite(thisFrame, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx));
%                         %                     imwrite(up, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx));
%                         pos(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx);
%                         pos(numidx).x1 = rect(1,1);
%                         pos(numidx).y1 = rect(1,2);
%                         pos(numidx).x2 = rect(1,1) + rect(1,3);
%                         pos(numidx).y2 = rect(1,2) + rect(1,4);
%                         %                     neg(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx);
%                     else
%                         fprintf('skip\n');
%                     end                    
%                 end      
            else
                if mod(frame,50) == 0
%                     w = waitforbuttonpress;
%                     if w == 0
%                         numidx=numidx+1;
%                         rect = getrect;
%                         rectangle('Position',rect,'EdgeColor','r','LineWidth',3);
%                         imwrite(thisFrame, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx));
%                         %                     imwrite(up, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx));
%                         pos(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\pos\\%d.jpg',numidx);
%                         pos(numidx).x1 = rect(1,1);
%                         pos(numidx).y1 = rect(1,2);
%                         pos(numidx).x2 = rect(1,1) + rect(1,3);
%                         pos(numidx).y2 = rect(1,2) + rect(1,4);
%                         %                     neg(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx);
%                     else
                        numidx=numidx+1;
                        neg(numidx).im = sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx);
                        imwrite(thisFrame, sprintf('C:\\Users\\diesel\\Desktop\\train_car_images\\neg\\%d.jpg',numidx));
%                     end                    
                end                 
            end
        end
    end
end
% save('C:\Users\diesel\Desktop\train_car_images\pos.mat','pos');
save('C:\Users\diesel\Desktop\train_car_images\neg.mat','neg');


