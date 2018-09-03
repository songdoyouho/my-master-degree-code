% load('D:\jpl\model\allencoding18');
% traindata=allencoding(1:229,:);
% testdata=allencoding(230:717,:);
%
% keyframe=[215];
% keyframe=keyframe-15;
% qid=zeros(size(traindata,1),1);
% label=zeros(size(traindata,1),1);
% % label=[1:size(traindata,1)]';
%
% for i=1:size(keyframe,1);
%     qid(171:229,1)=i;
%     label(keyframe(i,1),1)=200-171+1;
%     for j=1:200-171
%         label(keyframe(i,1)+j,1)=200-171-j+1;
%         label(keyframe(i,1)-j,1)=200-171-j+1;
%     end
% end
%
% fid = fopen('C:\Users\diesel\Desktop\train18', 'w');
% for i=1:size(traindata,1)
%     fprintf(fid,'%d qid:%d ',label(i,1),qid(i,1));
%     for j=1:size(traindata,2)
%         fprintf(fid,'%d:%.10f ',j,traindata(i,j));
%     end
%     fprintf(fid,'\n');
% end
%
% qid=zeros(size(testdata,1),1);
% label=[1:size(testdata,1)]';
% fid = fopen('C:\Users\diesel\Desktop\test18', 'w');
% for i=1:size(testdata,1)
%     fprintf(fid,'%d qid:%d ',label(i,1),qid(i,1));
%     for j=1:size(testdata,2)
%         fprintf(fid,'%d:%.10f ',j,testdata(i,j));
%     end
%     fprintf(fid,'\n');
% end

% load('D:\jpl\model\allencoding2');
% qid=zeros(size(allencoding,1),1);
% label=[1:size(allencoding,1)]';
% fid = fopen('C:\Users\diesel\Desktop\test2', 'w');
% for i=1:size(allencoding,1)
%     fprintf(fid,'%d qid:%d ',label(i,1),qid(i,1));
%     for j=1:size(allencoding,2)
%         fprintf(fid,'%d:%.10f ',j,allencoding(i,j));
%     end
%     fprintf(fid,'\n');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % load fisher vector file
% load('C:\Users\diesel\Desktop\dogcentric\tmp\allencoding1_5.mat');
% mov = VideoReader('C:\Users\diesel\Desktop\dogcentric\1_5.avi');
% numberOfFrames = mov.NumberOfFrames;
% % save training image
% for frame=1:numberOfFrames
%     thisframe=read(mov, frame);
%     figure(1);
%     imshow(thisframe);
%     hold on
%     imwrite(thisframe,sprintf('C:\\Users\\diesel\\Desktop\\images\\%d.jpg',frame));
% end
% fid = fopen('C:\\Users\\diesel\\Desktop\\allencoding1_5', 'w');
% % setting keyframe
% keyframe=[25 35 45 55]';
% keyframe=keyframe-15;
% % setting label and qid
% qid=zeros(size(allencoding,1),1);
% label=zeros(size(allencoding,1),1);
% label=[1:size(allencoding,1)]';
% for i=1:size(keyframe,1)
%     qid(keyframe(i,1)-4:keyframe(i,1)+4,1)=i;
%     label(keyframe(i,1),1)=5;
%     label(keyframe(i,1)+1,1)=4;
%     label(keyframe(i,1)-1,1)=4;
%     label(keyframe(i,1)+2,1)=3;
%     label(keyframe(i,1)-2,1)=3;
%     label(keyframe(i,1)+3,1)=2;
%     label(keyframe(i,1)-3,1)=2;
%     label(keyframe(i,1)+4,1)=1;
%     label(keyframe(i,1)-4,1)=1;
% end
% % output training file
% for i=1:size(allencoding,1)
%     fprintf(fid,'%d qid:%d ',label(i,1),qid(i,1));
%     for j=1:size(allencoding,2)
%         fprintf(fid,'%d:%.10f ',j,allencoding(i,j));
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);
% % output testing file
% for j=2:18
%     load(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\tmp\\allencoding%d_5.mat',j));
%     fid = fopen(sprintf('C:\\Users\\diesel\\Desktop\\allencoding%d_5',j), 'w');
%
%     qid=zeros(size(allencoding,1),1);
%     label=zeros(size(allencoding,1),1);
% %     label=[1:size(allencoding,1)]';
%
%     for i=1:size(allencoding,1)
%         fprintf(fid,'%d qid:%d ',label(i,1),qid(i,1));
%         for j=1:size(allencoding,2)
%             fprintf(fid,'%d:%.10f ',j,allencoding(i,j));
%         end
%         fprintf(fid,'\n');
%     end
%     fclose(fid);
% end

% % train model
% cd('C:\Users\diesel\Desktop\seg');
% system('svmtrain allencoding1_5');
%
% % testing
% for i=2:18
%     system(sprintf('svmpredict allencoding%d_5 allencoding1_5.model result%d_5',i,i));
% end

% plot figure
for i=2:18
    R=load(sprintf('C:\\Users\\diesel\\Desktop\\seg\\result%d_5',i));
    t=1:size(R,1);
    t=t';
    figure(1);
    plot(t,R);
    hold on;
    % find all local minium and maximum
    localframe=[];
    init=0;
    for k=2:size(R,1)
        if k==2 % initial sign
            d=R(k,1)-R(k-1,1);
            nowsai=sign(d);
            beforesai=nowsai;
        else
            beforesai=nowsai;
            d=R(k,1)-R(k-1,1);
            nowsai=sign(d);
        end
        if nowsai~=beforesai % 有正負號改變
            if init == 0
%                 figure(1)
%                 plot(k-1,R(k-1,1),'+'); % 畫在圖上
                localframe=[localframe; k-1];
                init=1;
            else
                check=k-1-localframe;
                if check(size(check,1),1) >= 1
%                     figure(1)
%                     plot(k-1,R(k-1,1),'+'); % 畫在圖上
                    localframe=[localframe; k-1];
                end
            end
        end
    end 
    
    % find selectframe
    selectnumindex=ceil(size(R,1)/10);
    [B I]=sort(R,'descend');
    selectframe=[];
    init=0;
    selectnum=0;
    while (selectnum<selectnumindex&&isempty(I)==0)
        if init==0
            tmpselect=I(1,1);
            selectframe=[selectframe; tmpselect]; % 第一高分ㄉ
%             figure(1);
%             plot(tmpselect,R(tmpselect,1),'*');
            hold on;
            selectnum=selectnum+1;
            init=1;
        else
            indexa=I<tmpselect-5;
            indexb=I<=tmpselect+5;
            indexsum=indexa+indexb;
            indexinv=indexsum==1;
            index=~indexinv;
            I=I(index,1);
            tmpselect=I(1,1);
            selectframe=[selectframe; tmpselect];
%             figure(1);
%             plot(tmpselect,R(tmpselect,1),'*');
            hold on;
            selectnum=selectnum+1;
%             check=abs(I(j,1)-tmpselect) > 5;
%             if check==1
%                 tmpselect=I(j,1);
%                 selectframe=[selectframe; tmpselect];
%             end
        end       
    end
    
    % compare selectframe and localframe
    finalframe=intersect(localframe,selectframe);
    figure(1);
    for iii=1:size(finalframe,1)
        plot(finalframe(iii,1),R(finalframe(iii,1)),'*');
    end
    finalframe=finalframe+15;
    
    
    
    
    % output image
    mov = VideoReader(sprintf('C:\\Users\\diesel\\Desktop\\dogcentric\\%d_5.avi',i));
    numberOfFrames = mov.NumberOfFrames;
    mkdir(sprintf('C:\\Users\\diesel\\Desktop\\seg\\%d_5',i));
    for k=1:size(finalframe,1)
        thisframe=read(mov, finalframe(k,1));
        imwrite(thisframe,sprintf('C:\\Users\\diesel\\Desktop\\seg\\%d_5\\%d.jpg',i,finalframe(k,1)));
    end
    saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\seg\\%dscore.jpg',i));
    clf;
end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % load video and save image
    % saveimage=0;
    % if saveimage==1
    %     mov = VideoReader('C:\Users\diesel\Desktop\dogcentric\5_5.avi');
    %     numberOfFrames = mov.NumberOfFrames;
    %
    %     for frame=1:numberOfFrames
    %         thisframe=read(mov, frame);
    %         figure(1);
    %         imshow(thisframe);
    %         hold on
    %         saveas(gcf,sprintf('C:\\Users\\diesel\\Desktop\\123\\%d.jpg', frame));
    %     end
    % end
    % clf
    
    % % setting keyframe
    % keyframe=[35]; % here 影片的keyframe num
    % keyframe=keyframe-15; % improved trajectory 的初始feature一定是從第15張frame後開始取的，所以要-15
    % label=[1:size(allencoding,1)]'; % 給 label or qid 從1-t張frame對應1-t的label or qid 滿足(f(x)>f(x-1))
    % for i=1:size(keyframe,2) % 對每個keyframe的位置，讓他成為local maximum，這邊可以改
    %     k=keyframe(1,i);
    %     label(k,1)=label(k,1)+10;
    %     label(k+1,1)=label(k+1,1)+8;
    %     label(k+2,1)=label(k+2,1)+6;
    %     label(k+3,1)=label(k+3,1)+4;
    %     label(k+4,1)=label(k+4,1)+2;
    %     label(k-1,1)=label(k-1,1)+8;
    %     label(k-2,1)=label(k-2,1)+6;
    %     label(k-3,1)=label(k-3,1)+4;
    %     label(k-4,1)=label(k-4,1)+2;
    % end
    %
    % % training liblinear
    % C=1;
    % model=train(double(label),sparse(double(allencoding)),sprintf('-c %1.6f -s 11 -q',C));
    % w=model.w'; % get weight
    % score=allencoding*w; % get score
    % t=1:size(score,1); % plot score
    % t=t';
    % figure(1);
    % plot(t,score);
    % hold on;
    %
    % % load test data
    % load('C:\Users\diesel\Desktop\dogcentric\tmp\allencoding5_5.mat');
    % % label=zeros(size(allencoding,1),1);
    % % [predicted_label, accuracy, decision_values] = predict(double(label), double(sparse(allencoding)), model);
    %
    % score=allencoding*w; % get score
    % t=1:size(score,1);
    % t=t';
    % figure(2);
    % plot(t,score);
    % hold on;
