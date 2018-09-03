opticalflow = opticalFlowFarneback;

alpha = 0.01;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

cellsize=3;
gridspacing=1;
SIFTflowpara.alpha=2*255;
SIFTflowpara.d=40*255;
SIFTflowpara.gamma=0.005*255;
SIFTflowpara.nlevels=4;
SIFTflowpara.wsize=2;
SIFTflowpara.topwsize=10;
SIFTflowpara.nTopIterations = 60;
SIFTflowpara.nIterations= 30;

mov = VideoReader('C:\\Users\diesel\Desktop\456.avi');
% mov = VideoReader('I:\\jpl_seg\1_4.avi');
endframe = mov.NumberOfFrames;

matrix_x = zeros(mov.height,mov.width);
matrix_y = zeros(mov.height,mov.width);
for iii = 1 : mov.width
    for jjj = 1 : mov.height
        matrix_x(jjj,iii) = iii;
        matrix_y(jjj,iii) = jjj;
    end
end

% create traj matrix
traj = zeros( mov.height*mov.width, 2 * (endframe-1));
count = 1;
for iii = 1 : mov.width
    for jjj = 1 : mov.height
        traj(count,1) = iii;
        traj(count,2) = jjj;
        count = count + 1;
    end
end
% opticalvideo = VideoWriter('C:\\Users\diesel\Desktop\optical.avi');
% opticalvideo.FrameRate = 5;
% open(opticalvideo);
for k = 1 : endframe - 1
    k
    thisframe = read(mov,k);
    nextframe = read(mov,k+1);
    % brox
%         [Vx, Vy, x, y, im] = optic_flow_brox(thisframe, nextframe, 10, 100, 3, 1, 0);
    %     figure(4)
    %     imshow(thisframe,'border','tight');
    %     hold on
    % farneback
%         frameGray = rgb2gray(thisframe);
%         flow = estimateFlow(opticalflow,frameGray);
%         Vx = flow.Vx;
%         Vy = flow.Vy;
    %     plot(flow,'DecimationFactor',[5 5]);
    %     image = getframe(gcf);
    %     clf
    %     writeVideo(opticalvideo,image);
    
    % TVL1
%     [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
    
    % SIFT flow
    sift1 = mexDenseSIFT(thisframe,cellsize,gridspacing);
    sift2 = mexDenseSIFT(nextframe,cellsize,gridspacing);
    [Vx,Vy,energylist]=SIFTflowc2f(sift1,sift2,SIFTflowpara);    
    
    out_index = [];
    if k == 1 % initial
        for mmm = 1 : size(traj,1)
            tmp_x = traj(mmm,1);
            tmp_y = traj(mmm,2);
            % 找 u , v
            tmp_u = Vx(tmp_y,tmp_x);
            tmp_v = Vy(tmp_y,tmp_x);
            xxx = tmp_x + tmp_u;
            yyy = tmp_y + tmp_v;
            % 如果超出邊界，就等於邊界
            if xxx < 1
                xxx = 1;
            end
            if yyy < 1
                yyy = 1;
            end
            if xxx > mov.width
                xxx = mov.width;
            end
            if yyy > mov.height
                yyy = mov.height;
            end
            traj(mmm,3) = xxx;
            traj(mmm,4) = yyy;
        end
    else
        tmp_x = traj(:,2*k-1);
        tmp_y = traj(:,2*k);
        tmp_u = interp2(matrix_x,matrix_y,Vx,tmp_x,tmp_y);
        tmp_v = interp2(matrix_x,matrix_y,Vy,tmp_x,tmp_y);
        xxx = tmp_x + tmp_u;
        yyy = tmp_y + tmp_v;
        
        min_x = xxx < 1;
        max_x = xxx > mov.width;
        min_y = yyy < 1;
        max_y = yyy > mov.height;
        xxx(min_x) = 1;
        xxx(max_x) = mov.width;
        yyy(min_y) = 1;
        yyy(max_y) = mov.height;
        
        traj(:,2*k-1+2) = xxx;
        traj(:,2*k+2) = yyy;
    end
end
% close(opticalvideo);
for mmm = 1 : size(traj,1)
    tmp_xxx = traj(mmm,end-1);
    tmp_yyy = traj(mmm,end);
    if (tmp_xxx == 1 || tmp_yyy == 1 || tmp_xxx == mov.width || tmp_yyy == mov.height)
        out_index = [out_index; 0];
    else
        out_index = [out_index; 1];
    end
end
traj = traj(logical(out_index),:);
save('C:\\Users\diesel\Desktop\traj.mat','traj');
load('C:\\Users\diesel\Desktop\traj.mat');
% decompose traj
U = traj(:,1:2:size(traj,2)-1);
V = traj(:,2:2:size(traj,2));
TRAJ = [U V];
[video_TrajAc,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,video_TrajOutE] = MotionDecomp(TRAJ,0.01);
fprintf('decompose finish\n');
% plot traj and save
% outputvideo = VideoWriter('C:\\Users\diesel\Desktop\1_4_result_TVL1.avi');
outputvideo = VideoWriter('C:\\Users\diesel\Desktop\456result_SIFT.avi');
% globalvideo = VideoWriter('C:\\Users\diesel\Desktop\456result1.avi');
outputvideo.FrameRate = 5;
open(outputvideo);
% globalvideo.FrameRate = 5;
% open(globalvideo);
endframe = mov.NumberOfFrames;
for k = 1 : endframe - 2
    thisframe = read(mov,k);
    figure(1)
    imshow(thisframe,'border','tight');
%     figure(2)
%     imshow(thisframe,'border','tight');
    figure(3)
    imshow(thisframe,'border','tight');
    % 畫線 or 箭頭?
    figure(1)
    line_x = video_TrajOut(1:100:end,1:k+1);
    line_y = video_TrajOut(1:100:end,size(video_TrajOut,2)/2+1:size(video_TrajOut,2)/2+k+1);
    line(line_x',line_y','Color','blue');
    text(1, 5, 'original local traj');
    image1 = getframe(gcf);
    clf
    %     figure(2)
    %     line_x = video_TrajOutE(:,1:k+1);
    %     line_y = video_TrajOutE(:,size(video_TrajOutE,2)/2+1:size(video_TrajOutE,2)/2+k+1);
    %     line(line_x',line_y','Color','blue');
    %     text(1, 5, 'after decomp local traj');
    %     image2 = getframe(gcf);
    %     image = cat(2,image1.cdata,image2.cdata);
    %     writeVideo(outputvideo,image);
    %     clf
    figure(3)
    %     line_x = video_TrajIn(:,1:k+1);
    %     line_y = video_TrajIn(:,size(video_TrajIn,2)/2+1:size(video_TrajIn,2)/2+k+1);
    %     line(line_x',line_y','Color','blue');
    %     text(1, 5, 'after decomp global traj');
    line_x = U(1:100:end,1:k+1);
    line_y = V(1:100:end,1:k+1);
    line(line_x',line_y','Color','blue');
    text(1, 5, 'after decomp global traj');
    image3 = getframe(gcf);
    image = cat(2,image3.cdata,image1.cdata);
    writeVideo(outputvideo,image);
    %     writeVideo(globalvideo,image3);
    clf
    %             pause(0.5)
end
close(outputvideo);
% close(globalvideo);


% X1 = x(:,2:31);
% U = X1(:,1:2:29);
% V = X1(:,2:2:30);
% Traj = [U V];
% [video_TrajAc,video_outindex,EE,outinds,video_TrajOut,video_TrajIn,video_TrajOutLow,video_TrajOutE] = MotionDecomp(Traj,0.2);
% video_outX = x(video_outindex,:);
%
% % plot traj and save
% outputvideo = VideoWriter('C:\\Users\diesel\Desktop\myresult.avi');
% outputvideo.FrameRate = 5;
% open(outputvideo);
%
% endframe = mov.NumberOfFrames;
% for k = 15 : endframe - 2
%     thisframe = read(mov,k);
%     index=x(:,1)==k;
%     tmpX=x(index,:);
%
%     figure(1)
%     imshow(thisframe,'border','tight');hold on
%     figure(2)
%     imshow(thisframe,'border','tight');hold on
%     % 畫線 or 箭頭?
%     figure(1)
%     plot(tmpX(:,2),tmpX(:,3),'r*'); hold on
%     U = tmpX(:,2:2:30);
%     V = tmpX(:,3:2:31);
%     line(U',V','Color','blue');
%     text(1, 5, 'all input traj');
%     %                 pause(0.5);
%     image1 = getframe(gcf);
%     clf
%
%     index=video_outX(:,1)==k;
%     tmp_pervideo_outX=video_outX(index,:);
%     figure(2)
%     plot(tmp_pervideo_outX(:,2),tmp_pervideo_outX(:,3),'r*'); hold on
%     U = tmp_pervideo_outX(:,2:2:30);
%     V = tmp_pervideo_outX(:,3:2:31);
%     line(U',V','Color','blue');
%     text(1, 5, 'local traj');
%     image2 = getframe(gcf);
%     clf
%     image = cat(2,image1.cdata,image2.cdata);
%     writeVideo(outputvideo,image);
% end
% close(outputvideo);

