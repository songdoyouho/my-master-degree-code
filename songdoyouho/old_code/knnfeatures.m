function [  ] = knnfeatures( conf )
%SHOWFEATURES Summary of this function goes here
%   Detailed explanation goes here
trainnum=conf.trvideo;
testnum=conf.trvideo;
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
show=0;
for j=1:actnum
    for i=1:numel(tridx)
        vi=tridx(i);
        % load features
        X=load(sprintf('%s\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.txt\n', conf.videopath, vi, j);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi',conf.videopath,vi,j));
        numberOfFrames = mov.NumberOfFrames;
        width=mov.Width;
        height=mov.Height;
        NN=[];
        DD=[];
        hwait=waitbar(0,'plz wait');
        tic;
        % do knn find the distance
        for aaa=1:size(X,1)
            [N D]=knnsearch(X(:,2:3),X(aaa,2:3),'k',100);
            D=sum(D);
            NN=[NN; N];
            DD=[DD; D];
            waitbar(aaa/size(X,1),hwait);
        end
        delete(hwait);
        % find the avg distance
        allD=sum(DD);
        avgD=allD/size(DD,1);
        % find the features which have bigger distance
        for aaa=1:size(DD,1)
            if DD(aaa,1)>avgD
                % if bigger set 1
                X(aaa,428)=1;
            else
                X(aaa,428)=0;
            end
        end
        % remove 0=>keep 1=>delete
        newX=[];
        for aaa=1:size(DD,1)
            if X(aaa,428)==0
                newX=[newX;X(aaa,1:427)];
            end
        end
        % save
        save(sprintf('%s\\knn%d_%d.mat',conf.tmppath,vi,j),'newX');
        toc;
        if show==1
            % show feature points!
            disp('show video');
            for frame = 1 : numberOfFrames
                thisFrame = read(mov, frame);
                subplot(1,2,1);
                imshow(thisFrame);
                hold on;
                subplot(1,2,2);
                imshow(thisFrame);
                hold on;
                % plot the rest of points
                for bbb=1:size(newX,1)
                    if frame==newX(bbb,1)
                        subplot(1,2,1);
                        plot(newX(bbb,2),newX(bbb,3),'+');
                        hold on;
                    end
                end
                for bbb=1:size(X,1)
                    if frame==X(bbb,1)
                        subplot(1,2,2);
                        plot(X(bbb,2),X(bbb,3),'+');
                        hold on;
                    end
                end
                pause(0.1);
            end
        end
    end 
end

end

