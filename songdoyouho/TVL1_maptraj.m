% 把軌跡map到有bbox的白色區域

actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\map\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\map\\%d_%d.avi\n', conf.videopath, vi, j);
        ori = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        X = load(sprintf('%s\\new_decompose_traj_thr_0.1\\Et_center%d_%d.txt',conf.videopath,vi,j));
        fid = fopen(sprintf('%s\\new_decompose_traj_thr_0.1\\new_Et_center%d_%d.txt',conf.videopath,vi,j),'wt');
        newX = [];
        for k = 1 : endframe
            thisframe = read(mov,k);
%             oriframe = read(ori,k);
%             imshow(thisframe,'border','tight');
%             hold on
            index = X(:,33) == k;
            nowX = X(index,:);
            allindex = [];
            for aaa = 1 : size(nowX,1)
                %  check boundary
                if nowX(aaa,17) <= 240 && nowX(aaa,1) <= 320 && nowX(aaa,17) >= 1 && nowX(aaa,1) >= 1               
                    index = thisframe(fix(nowX(aaa,17)),fix(nowX(aaa,1)),1) == 255;
                    allindex = [allindex; index];
                else
                    index = 0;
                    allindex = [allindex; index];
                end
            end
            selectX = nowX(logical(allindex),:);
%             imshow(oriframe);
            % plot traj
%             if isempty(selectX) == 0
%                 plot(selectX(:,1),selectX(:,17),'r*'); hold on
%                 U = selectX(:,1:16);
%                 V = selectX(:,17:32);
%                 line(U',V','Color','green');
%             end
%             clf
            newX = [newX; selectX];
        end
        for iii = 1 : size(newX,1)
            for jjj = 1 : size(newX,2)
                fprintf(fid, '%f ', newX(iii,jjj));
            end 
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
end