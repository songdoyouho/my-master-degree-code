actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        ori_mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        fore_mov = VideoReader(sprintf('%s\\large_selection\\fore_%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\large_selection\\fore_%d_%d.avi', conf.videopath, vi, j);
        numframe = ori_mov.NumberOfFrames;
        width = ori_mov.Width;
        height = ori_mov.Height;
        fore_index = zeros(size(X,1),1);
        count = 1;
        for k=1:numframe
            ori_Frame = read(ori_mov, k);
%             figure(1)
%             imshow(ori_Frame,'border','tight');
%             hold on
%             figure(2)
            fore_Frame = read(fore_mov,k);
            gray_fore = rgb2gray(fore_Frame);
%             imshow(fore_Frame,'border','tight');
%             hold on               
            index=X(:,1)==k;
            now_tmpX=X(index,:);
%             figure(2)
            for iii = 1:size(now_tmpX)
                xxx = fix(now_tmpX(iii,2));
                yyy = fix(now_tmpX(iii,3));
                if gray_fore(yyy,xxx) > 0
%                     plot(xxx,yyy,'r*');
%                     hold on 
                    fore_index(count,1) = 1;
                    count = count + 1;
                else
%                     plot(xxx,yyy,'g*');
%                     hold on
                    count = count + 1;
                end
            end            
        end
        fore_feature = X(logical(fore_index),:);
        save(sprintf('%s\\fore_feature\\fore_feature%d_%d.mat',conf.tmppath,vi,j),'fore_feature');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        load(sprintf('%s\\feature%d_%d.mat', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.mat\n', conf.videopath, vi, j);
        ori_mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        fore_mov = VideoReader(sprintf('%s\\large_selection\\fore_%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\large_selection\\fore_%d_%d.avi', conf.videopath, vi, j);
        numframe = ori_mov.NumberOfFrames;
        width = ori_mov.Width;
        height = ori_mov.Height;
        fore_index = zeros(size(X,1),1);
        count = 1;
        for k=1:numframe
            ori_Frame = read(ori_mov, k);
%             figure(1)
%             imshow(ori_Frame,'border','tight');
%             hold on
%             figure(2)
            fore_Frame = read(fore_mov,k);
            gray_fore = rgb2gray(fore_Frame);
%             imshow(fore_Frame,'border','tight');
%             hold on               
            index=X(:,1)==k;
            now_tmpX=X(index,:);
%             figure(2)
            for iii = 1:size(now_tmpX)
                xxx = fix(now_tmpX(iii,2));
                yyy = fix(now_tmpX(iii,3));
                if gray_fore(yyy,xxx) > 0
%                     plot(xxx,yyy,'r*');
%                     hold on 
                    fore_index(count,1) = 1;
                    count = count + 1;
                else
%                     plot(xxx,yyy,'g*');
%                     hold on
                    count = count + 1;
                end
            end            
        end
        fore_feature = X(logical(fore_index),:);
        save(sprintf('%s\\fore_feature\\fore_feature%d_%d.mat',conf.tmppath,vi,j),'fore_feature');
    end
end