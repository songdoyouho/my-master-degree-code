% test differnet kmean method
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        endframe = mov.NumberOfFrames;
        
        %         outputvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\kmean5%d_%d.avi',conf.videopath,vi,j));
        %         outputvideo.FrameRate = 5;
        %         open(outputvideo);
        
        resultvideo = VideoWriter(sprintf('%s\\new_decompose_traj_thr_0.1\\eu%d_%d.avi',conf.videopath,vi,j));
        resultvideo.FrameRate = 5;
        open(resultvideo);
        
        for k = 1 : endframe - 16
            load(sprintf('%s\\new_decompose_traj_thr_0.1\\video_TrajEt\\%d_%d\\%d.mat',conf.videopath,vi,j,k+15));
            tmp_traj = video_TrajEt(:,1:32);
            k
            % draw kmean result
            thisframe = read(mov,k+15);
            if isempty(tmp_traj) == 0 && size(tmp_traj,1) >= 100
                [L,C] = fastkmeans(tmp_traj,fix(size(tmp_traj,1)/10));
				% calculate trajectory displacement
                %                 dispx = [];
                %                 dispy = [];
                %                 % turn to displacement
                %                 for kkk = 1 : 15
                %                     %                     dispxx = abs(C(:,kkk+1) - C(:,kkk));
                %                     %                     dispyy = abs(C(:,kkk+1+16) - C(:,kkk+16));
                %                     dispxx = C(:,kkk+1) - C(:,kkk);
                %                     dispyy = C(:,kkk+1+16) - C(:,kkk+16);
                %                     dispx = [dispx dispxx];
                %                     dispy = [dispy dispyy];
                %                 end
                %                 newC = [dispx dispy];
				% fastkmeans is euclidean distance
				% change C to newC if you want to use displacement as input data
                [prof_L,prof_C] = fastkmeans(C, 5);
				% paperkmeans is overall motion displacement distance
                % [prof_L,prof_C] = paperkmeans(C, 5);
							
				
                %                 xxx = C(:,16);
                %                 yyy = C(:,32);
                %                 out_index = [];
                %                 % delete the traj on the edge of image
                %                 for mmm = 1 : size(C,1)
                %                     tmp_xxx = xxx(mmm,1);
                %                     tmp_yyy = yyy(mmm,1);
                %                     if (tmp_xxx <= 1 || tmp_yyy <= 1 || tmp_xxx >= mov.width || tmp_yyy >= mov.height)
                %                         out_index = [out_index; 0];
                %                     else
                %                         out_index = [out_index; 1];
                %                     end
                %                 end
                %                 xxx = xxx(logical(out_index),:);
                %                 yyy = yyy(logical(out_index),:);
				
				% color means use color as input data for kmeans
                %                 color = [];
                %                 for mmm = 1 : size(xxx,1)
                %                     tmp_xxx = fix(xxx(mmm,1));
                %                     tmp_yyy = fix(yyy(mmm,1));
                %                     tmp_color = thisframe(tmp_yyy,tmp_xxx,:);
                %                     color = [color;tmp_color];
                %                 end
                %                 color = reshape(color,size(color,1),3);
                %                 [color_L,color_newC] = fastkmeans(double(color), 5);
                
                %                 color_C = C(logical(out_index),:);
                
                %                 allpixel = reshape(thisframe,320 * 240,3);
                %                 [pixel_L,pixel_newC] = fastkmeans(double(allpixel), 4);
                %                 pixel_L = reshape(pixel_L,240,320);
                %                 figure(2)
                %                 index1 = pixel_L == 1;
                %                 img = double(index1);
                %                 imshow(img,'border','tight');
                %                 image2 = getframe(gcf);
                %                 clf
                %                 figure(3)
                %                 index2 = pixel_L == 2;
                %                 img = double(index2);
                %                 imshow(img,'border','tight');
                %                 image3 = getframe(gcf);
                %                 clf
                %                 figure(4)
                %                 index3 = pixel_L == 3;
                %                 img = double(index3);
                %                 imshow(img,'border','tight');
                %                 image4 = getframe(gcf);
                %                 clf
                %                 figure(5)
                %                 index4 = pixel_L == 4;
                %                 img = double(index4);
                %                 imshow(img,'border','tight');
                %                 image5 = getframe(gcf);
                %                 clf
                %                 figure(6)
                %                 index = pixel_L == 5;
                %                 img = double(index);
                %                 imshow(img,'border','tight');
                %                 image6 = getframe(gcf);
                %                 clf
                %                 figure(1)
                %                 imshow(thisframe,'border','tight');
                %                 image1 = getframe(gcf);
                %                 clf
                
                %                 bottom1 = sum(index1(240,:));
                %                 bottom2 = sum(index2(240,:));
                %                 bottom3 = sum(index3(240,:));
                %                 bottom4 = sum(index4(240,:));
                %
                %                 tmp1 = cat(2,image2.cdata,image3.cdata);
                %                 tmp2 = cat(2,image4.cdata,image5.cdata);
                %                 image = cat(1,tmp1,tmp2);
                %                 writeVideo(resultvideo,image);
                
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
%                     all traj
                    figure(1)
                    plot(C(:,1),C(:,17),'r*'); hold on
                    U = C(:,1:16);
                    V = C(:,17:32);
                    line(U',V','Color','green');
                    text(1, 5, 'all traj');
                    image1 = getframe(gcf);
                    clf
%                     show traj after clustering
                    figure(2)
                    index = prof_L == 1;
%                     index = color_L == 1;
                    C_1 = C(index,:);
%                     C_1 = color_C(index,:);
                    plot(C_1(:,1),C_1(:,17),'r*'); hold on
                    U = C_1(:,1:16);
                    V = C_1(:,17:32);
                    line(U',V','Color','blue'); hold on
                    image2 = getframe(gcf);
                    clf
%                     plot(center(1,1),center(1,17),'r*'); hold on
%                     U = center(1,1:16);
%                     V = center(1,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(3)
                    index = prof_L == 2;
%                     index = color_L == 2;
                    C_2 = C(index,:);
%                     C_2 = color_C(index,:);
                    plot(C_2(:,1),C_2(:,17),'r*'); hold on
                    U = C_2(:,1:16);
                    V = C_2(:,17:32);
                    line(U',V','Color','white');
                    image3 = getframe(gcf);
                    clf
%                     plot(center(2,1),center(2,17),'r*'); hold on
%                     U = center(2,1:16);
%                     V = center(2,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(4)
                    index = prof_L == 3;
%                     index = color_L == 3;
                    C_3 = C(index,:);
%                     C_3 = color_C(index,:);
                    plot(C_3(:,1),C_3(:,17),'r*'); hold on
                    U = C_3(:,1:16);
                    V = C_3(:,17:32);
                    line(U',V','Color','yellow'); hold on
                    image4 = getframe(gcf);
                    clf
%                     plot(center(3,1),center(3,17),'r*'); hold on
%                     U = center(3,1:16);
%                     V = center(3,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(5)
                    index = prof_L == 4;
%                     index = color_L == 4;
                    C_4 = C(index,:);
%                     C_4 = color_C(index,:);
                    plot(C_4(:,1),C_4(:,17),'r*'); hold on
                    U = C_4(:,1:16);
                    V = C_4(:,17:32);
                    line(U',V','Color','green'); hold on
                    image5 = getframe(gcf);
                    clf
%                     plot(center(4,1),center(4,17),'r*'); hold on
%                     U = center(4,1:16);
%                     V = center(4,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    figure(6)
                    index = prof_L == 5;
%                     index = color_L == 5;
                    C_5 = C(index,:);
%                     C_5 = color_C(index,:);
                    plot(C_5(:,1),C_5(:,17),'r*'); hold on
                    U = C_5(:,1:16);
                    V = C_5(:,17:32);
                    line(U',V','Color','black'); hold on
                    image6 = getframe(gcf);
                    clf
%                     plot(center(5,1),center(5,17),'r*'); hold on
%                     U = center(5,1:16);
%                     V = center(5,17:32);
%                     line(U',V','Color','white'); hold on
                    
                    % density score
                    cx = sum(C_1(:,1)) / size(C_1,1);
                    cy = sum(C_1(:,17)) / size(C_1,1);
                    density1 = (sum(abs(C_1(:,1) - cx)) + sum(abs(C_1(:,17) - cy))) / size(C_1,1);
                    cx = sum(C_2(:,1)) / size(C_2,1);
                    cy = sum(C_2(:,17)) / size(C_2,1);
                    density2 = (sum(abs(C_2(:,1) - cx)) + sum(abs(C_2(:,17) - cy))) / size(C_2,1);
                    cx = sum(C_3(:,1)) / size(C_3,1);
                    cy = sum(C_3(:,17)) / size(C_3,1);
                    density3 = (sum(abs(C_3(:,1) - cx)) + sum(abs(C_3(:,17) - cy))) / size(C_3,1);
                    cx = sum(C_4(:,1)) / size(C_4,1);
                    cy = sum(C_4(:,17)) / size(C_4,1);
                    density4 = (sum(abs(C_4(:,1) - cx)) + sum(abs(C_4(:,17) - cy))) / size(C_4,1);
                    cx = sum(C_5(:,1)) / size(C_5,1);
                    cy = sum(C_5(:,17)) / size(C_5,1);
                    density5 = (sum(abs(C_5(:,1) - cx)) + sum(abs(C_5(:,17) - cy))) / size(C_5,1);
                                       
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
                
                % save the result
                tmp1 = cat(2,image1.cdata,image2.cdata,image3.cdata);
                tmp2 = cat(2,image4.cdata,image5.cdata,image6.cdata);
                image = cat(1,tmp1,tmp2);
                writeVideo(resultvideo,image);
                
				% plot optical flow
                %                 figure(1)
                %                 xxx = tmp_traj(:,16);
                %                 yyy = tmp_traj(:,32);
                %                 uuu = tmp_traj(:,16) - tmp_traj(:,15);
                %                 vvv = tmp_traj(:,32) - tmp_traj(:,31);
                %                 quiver(xxx,yyy,uuu,vvv);
                
                %                 figure(2)
                %                 xxx = C_1(:,1);
                %                 yyy = C_1(:,17);
                %                 uuu = C_1(:,2) - C_1(:,1);
                %                 vvv = C_1(:,18) - C_1(:,17);
                %                 quiver(xxx,yyy,uuu,vvv);
                
                % save the grouping result
                %                 density = [density1 density2 density3 density4 density5];
                %                 [III SSS] = sort(density,'descend');
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
                %                 writeVideo(resultvideo,image);
            end
        end
        close(resultvideo);
    end
end