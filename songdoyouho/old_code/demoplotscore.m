tmppath='C:\Users\diesel\Desktop\dogcentric\tmp';
load(sprintf('%s\\allencoding\\allencoding1_3.mat',tmppath));
load(sprintf('%s\\movingaverage\\movingaverage1_3.mat',tmppath));
load(sprintf('%s\\timevarymean\\timevarymean1_3.mat',tmppath));
load(sprintf('%s\\W1\\W11_3.mat',tmppath));
load(sprintf('%s\\W2\\W21_3.mat',tmppath));
load(sprintf('%s\\W3\\W31_3.mat',tmppath));


WWW=W1(1,1:109056);
score=allencoding*WWW';
t=1:size(score,1);
t=t';
figure(1);
plot(t,score);
hold on;

% WWW=W1(1,1:109056);
% score=timevarymean*WWW';
% t=1:size(score,1);
% t=t';
% figure(2);
% plot(t,score);
% hold on;
% 
% WWW=W1(1,1:109056);
% score=movingaverage*WWW';
% t=1:size(score,1);
% t=t';
% figure(3);
% plot(t,score);
% hold on;

% WWW=W2(1,1:109056);
% score=allencoding*WWW';
% t=1:size(score,1);
% t=t';
% figure(4);
% plot(t,score);
% hold on;

WWW=W2(1,1:109056);
score=timevarymean*WWW';
t=1:size(score,1);
t=t';
figure(5);
plot(t,score);
hold on;

% WWW=W2(1,1:109056);
% score=movingaverage*WWW';
% t=1:size(score,1);
% t=t';
% figure(6);
% plot(t,score);
% hold on;
% 
% WWW=W3(1,1:109056);
% score=allencoding*WWW';
% t=1:size(score,1);
% t=t';
% figure(7);
% plot(t,score);
% hold on;
% 
% WWW=W3(1,1:109056);
% score=timevarymean*WWW';
% t=1:size(score,1);
% t=t';
% figure(8);
% plot(t,score);
% hold on;

WWW=W3(1,1:109056);
score=movingaverage*WWW';
t=1:size(score,1);
t=t';
figure(9);
plot(t,score);
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% keyframe
% fiverate=[];
% for j=1:fix(size(score,1)/10)
%     rate=(score(j*10,1)-score(j*10-9,1))/10;
%     fiverate=[fiverate; rate];
% end
% 
% ttt=0;
% keyt=[];
% for k=1:size(fiverate,1)-1
%     ttt=ttt+10;
%     if abs(fiverate(k+1,1)-fiverate(k,1))>=0.05
% %         figure(1)
% %         plot(ttt,score(ttt,1),'*');
% %         hold on;
%         keyt=[keyt; ttt];
%     end
% end
% keyt=keyt+15;
% 
% figure(2);
% mov = VideoReader('C:\Users\diesel\Desktop\dogcentric\1_10.avi');
% numberOfFrames = mov.NumberOfFrames;
% for frame=1:numberOfFrames
%     thisframe=read(mov, frame);
%     figure(2);
%     imshow(thisframe);
%     figure(1);
% %     if frame-15>=1
% %         plot(t(frame-15,1),score(frame-15,1),'+');
% %         hold on;
% %     end
%     aaa=intersect(frame,keyt);
%     if isempty(aaa)==0;
%         plot(t(frame-15,1),score(frame-15,1),'b+');
%         hold on;
% %         imwrite(thisframe,sprintf('%s\\%d.jpg',modelpath,frame));
% %         figure(3);
% %         imshow(thisframe);
%          pause;
%     else
%         pause(0.1);
%     end
% end
% close all;