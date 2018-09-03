actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
lut = [zeros(1,50) ones(1,156) zeros(1,50)];
f = @(x) lut(x);
k=strel('diamond',3);
for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
%         mkdir(sprintf('E:\\final_saliency\\%d_%d',vi,j));
%         path = sprintf('E:\\saliency\\%d_%d',vi,j);
%         name = dir(path);
        
        
        for iii=3:size(name,1)
            img = imread(sprintf('E:\\final_saliency\\%d_%d\\%d.jpg',vi,j,iii+12));
            %             figure(1)
            %             imshow(img);
            img=img+1;
            newimg = arrayfun(f,img,'UniformOutput', true);
            %             figure(2)
            %             imshow(newimg);
            finalimg=imdilate(newimg,k);
            %             figure(3)
            %             imshow(finalimg);
            %             pause(0.5)
            imwrite(finalimg,sprintf('E:\\final_saliency\\%d_%d\\%d.jpg',vi,j,iii+12),'jpg');
        end
    end
end