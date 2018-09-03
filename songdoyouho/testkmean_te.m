% test differnet kmean method
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
        %         fid = fopen(sprintf('%s\\new_decompose_traj_thr_0.1\\deletekmean%d_%d.txt',conf.videopath,vi,j),'wt');
        %         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\Et_iscamkmean%d_%d.avi',conf.videopath,vi,j));
        outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\deletekmean%d_%d.avi',conf.videopath,vi,j));
        outputvideo.FrameRate = 10;
        open(outputvideo);
        for k = 1 : endframe - 16
            load(sprintf('%s\\new_decompose_traj_thr_0.1\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
            tmp_traj = video_TrajEt(:,1:32);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/10));
                dispx = [];
                dispy = [];
                % turn to displacement
                for kkk = 1 : 15
                    dispxx = abs(C(:,kkk+1) - C(:,kkk));
                    dispyy = abs(C(:,kkk+1+16) - C(:,kkk+16));
                    dispx = [dispx dispxx];
                    dispy = [dispy dispyy];
                end
                newC = [dispx dispy];
                [prof_L,prof_C] = fastkmeans(newC, 4);
%                 center = prof_C;
                k
                % draw kmean result
                thisframe = read(mov,k+15);
                figure(1)
                imshow(thisframe,'border','tight');
                hold on
                figure(2)
                imshow(thisframe,'border','tight');
                hold on
                figure(3)
                imshow(thisframe,'border','tight');
                hold on
                figure(4)
                imshow(thisframe,'border','tight');
                hold on
                figure(5)
                imshow(thisframe,'border','tight');
                hold on
                figure(6)
                imshow(thisframe,'border','tight');
                hold on
                if isempty(C) == 0
                    % all traj
%                     figure(1)
%                     plot(C(:,1),C(:,17),'r*'); hold on
%                     U = C(:,1:16);
%                     V = C(:,17:32);
%                     line(U',V','Color','green');
%                     text(1, 5, 'all traj');
%                     image1 = getframe(gcf);
                    
                    % show traj after clustering
                    figure(2)
                    index = prof_L == 1;
                    C_1 = C(index,:);
                    plot(C_1(:,1),C_1(:,17),'r*'); hold on
                    U = C_1(:,1:16);
                    V = C_1(:,17:32);
                    line(U',V','Color','blue'); hold on
%                     plot(center(1,1),center(1,17),'r*'); hold on
%                     U = center(1,1:16);
%                     V = center(1,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(3)
                    index = prof_L == 2;
                    C_2 = C(index,:);
                    plot(C_2(:,1),C_2(:,17),'r*'); hold on
                    U = C_2(:,1:16);
                    V = C_2(:,17:32);
                    line(U',V','Color','red');
%                     plot(center(2,1),center(2,17),'r*'); hold on
%                     U = center(2,1:16);
%                     V = center(2,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(4)
                    index = prof_L == 3;
                    C_3 = C(index,:);
                    plot(C_3(:,1),C_3(:,17),'r*'); hold on
                    U = C_3(:,1:16);
                    V = C_3(:,17:32);
                    line(U',V','Color','yellow'); hold on
%                     plot(center(3,1),center(3,17),'r*'); hold on
%                     U = center(3,1:16);
%                     V = center(3,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(5)
                    index = prof_L == 4;
                    C_4 = C(index,:);
                    plot(C_4(:,1),C_4(:,17),'r*'); hold on
                    U = C_4(:,1:16);
                    V = C_4(:,17:32);
                    line(U',V','Color','green'); hold on
%                     plot(center(4,1),center(4,17),'r*'); hold on
%                     U = center(4,1:16);
%                     V = center(4,17:32);
%                     line(U',V','Color','white'); hold on
                    
%                     figure(6)
%                     index = prof_L == 5;
%                     C_5 = C(index,:);
%                     plot(C_5(:,1),C_5(:,17),'r*'); hold on
%                     U = C_5(:,1:16);
%                     V = C_5(:,17:32);
%                     line(U',V','Color','black'); hold on
%                     plot(center(5,1),center(5,17),'r*'); hold on
%                     U = center(5,1:16);
%                     V = center(5,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    % density score
%                     cx = sum(C_1(:,1)) / size(C_1,1);
%                     cy = sum(C_1(:,17)) / size(C_1,1);                                     
%                     density1 = (sum(abs(C_1(:,1) - cx)) + sum(abs(C_1(:,17) - cy))) / size(C_1,1);
%                     cx = sum(C_2(:,1)) / size(C_2,1);
%                     cy = sum(C_2(:,17)) / size(C_2,1);
%                     density2 = (sum(abs(C_2(:,1) - cx)) + sum(abs(C_2(:,17) - cy))) / size(C_2,1);
%                     cx = sum(C_3(:,1)) / size(C_3,1);
%                     cy = sum(C_3(:,17)) / size(C_3,1);
%                     density3 = (sum(abs(C_3(:,1) - cx)) + sum(abs(C_3(:,17) - cy))) / size(C_3,1);
%                     cx = sum(C_4(:,1)) / size(C_4,1);
%                     cy = sum(C_4(:,17)) / size(C_4,1);
%                     density4 = (sum(abs(C_4(:,1) - cx)) + sum(abs(C_4(:,17) - cy))) / size(C_4,1);
%                     cx = sum(C_5(:,1)) / size(C_5,1);
%                     cy = sum(C_5(:,17)) / size(C_5,1);
%                     density5 = (sum(abs(C_5(:,1) - cx)) + sum(abs(C_5(:,17) - cy))) / size(C_5,1);
                    
                    % traj average motion magnitude
                    %                     magn1 = 0;
                    %                     magn2 = 0;
                    %                     magn3 = 0;
                    %                     magn4 = 0;
                    %                     magn5 = 0;
                    %                     for kkk = 1 : 15
                    %                         tmpx = abs(C_1(:,kkk+1) - C_1(:,kkk));
                    %                         tmpy = abs(C_1(:,kkk+17) - C_1(:,kkk+16));
                    %                         magn1 = magn1 + (sum(tmpx) + sum(tmpy));
                    %                         tmpx = abs(C_2(:,kkk+1) - C_2(:,kkk));
                    %                         tmpy = abs(C_2(:,kkk+17) - C_2(:,kkk+16));
                    %                         magn2 = magn2 + (sum(tmpx) + sum(tmpy));
                    %                         tmpx = abs(C_3(:,kkk+1) - C_3(:,kkk));
                    %                         tmpy = abs(C_3(:,kkk+17) - C_3(:,kkk+16));
                    %                         magn3 = magn3 + (sum(tmpx) + sum(tmpy));
                    %                         tmpx = abs(C_4(:,kkk+1) - C_4(:,kkk));
                    %                         tmpy = abs(C_4(:,kkk+17) - C_4(:,kkk+16));
                    %                         magn4 = magn4 + (sum(tmpx) + sum(tmpy));
                    %                         tmpx = abs(C_5(:,kkk+1) - C_5(:,kkk));
                    %                         tmpy = abs(C_5(:,kkk+17) - C_5(:,kkk+16));
                    %                         magn5 = magn5 + (sum(tmpx) + sum(tmpy));
                    %                     end
                    %                     magn1 = magn1/size(C_1,1);
                    %                     magn2 = magn2/size(C_2,1);
                    %                     magn3 = magn3/size(C_3,1);
                    %                     magn4 = magn4/size(C_4,1);
                    %                     magn5 = magn5/size(C_5,1);
                end
                
                % save the group 
%                 density = [density1 density2 density3 density4 density5];
%                 [III SSS] = sort(density,'descend');
%                 
%                 figure(2)
%                 index = prof_L == SSS(1,1);
%                 center = C(index,:);
%                 plot(center(:,1),center(:,17),'r*'); hold on
%                 U = center(:,1:16);
%                 V = center(:,17:32);
%                 line(U',V','Color','yellow');
%                 text(1, 5, 'delete traj'); hold on
%                 image1 = getframe(gcf);
%                 clf
%                 figure(1)
%                 index = prof_L ~= SSS(1,1);
%                 center = C(index,:);
%                 plot(center(:,1),center(:,17),'r*'); hold on
%                 U = center(:,1:16);
%                 V = center(:,17:32);
%                 line(U',V','Color','blue');
%                 text(1, 5, 'cluster traj'); hold on
%                 image2 = getframe(gcf);
%                 clf
%                 image = cat(2,image1.cdata,image2.cdata);
%                 writeVideo(outputvideo,image);
                
                %                 for iii = 1 : size(center,1)
                %                     for jjj = 1 : size(center,2)
                %                         fprintf(fid, '%f ', center(iii,jjj));
                %                     end
                %                     fprintf(fid,'%d',k);
                %                     fprintf(fid,'\n');
                %                 end
            else
                %                 for iii = 1 : size(video_TrajEt,1)
                %                     for jjj = 1 : size(video_TrajEt,2) - 1
                %                         fprintf(fid, '%f ', video_TrajEt(iii,jjj));
                %                     end
                %                     fprintf(fid,'%d',k);
                %                     fprintf(fid,'\n');
                %                 end
            end
        end
        %         fclose(fid);
        close(outputvideo);
    end
end