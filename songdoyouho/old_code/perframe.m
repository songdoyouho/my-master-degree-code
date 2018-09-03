function [  ] = perframe( conf )
%PERFRAME Summary of this function goes here
%   Detailed explanation goes here
trainnum=conf.trvideo;
testnum=conf.trvideo;
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
show=1;
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
            % 找出那個frame的所有features，存起來
            tmpX=[];
            for aaaa=1:size(X,1)-2
                if X(aaaa,1)==X(aaa,1)
                    tmpX=[tmpX; X(aaaa,:)];
                elseif X(aaaa,1)==X(aaa,1)+1
                    tmpX=[tmpX; X(aaaa,:)];
                elseif X(aaaa,1)==X(aaa,1)+2
                    tmpX=[tmpX; X(aaaa,:)];
                end                
            end
            [N D]=knnsearch(tmpX(:,2:3),X(aaa,2:3),'k',10);
            D=sum(D);
            NN=[NN; N];
            DD=[DD; D];
            waitbar(aaa/size(X,1),hwait);
        end
        delete(hwait);
        % find the avg distance for each frame!!!

        for aaa=1:size(DD,1)
            tmpDD=[]; % 所有這一張frame的加總距離
            for aaaa=1:size(DD,1)
                if X(aaaa,1)==X(aaa,1)
                    tmpDD=[tmpDD; DD(aaaa,1)];
                end
            end
           allD=sum(tmpDD);
           avgD=allD/size(tmpDD,1);
           % find the features which have bigger distance
           if DD(aaa,1)>avgD
               % if bigger set 1
               X(aaa,428)=1;
           else
               X(aaa,428)=0;
           end            
        end
        % remove
        newX=[];
        for aaa=1:size(DD,1)
            if X(aaa,428)==0
                newX=[newX;X(aaa,1:427)];
            end
        end
        % save
        save(sprintf('%s\\perknn%d_%d.mat',conf.tmppath,vi,j),'newX');
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

