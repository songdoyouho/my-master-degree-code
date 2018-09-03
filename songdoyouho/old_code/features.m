function [ ] = features( conf, flag )
%FEATURES Summary of this function goes here
%   Detailed explanation goes here
trainnum=conf.trvideo;
testnum=conf.trvideo;
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
% split features
%         X1=X(:,2:31);  % trajectory
%         X2=X(:,32:127); % hog
%         X3=X(:,128:235); % hof
%         X4=X(:,236:331); % mbhx
%         X5=X(:,332:427); % mbhy

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
        
        s=X(1,1,1);
        s1=s+3;
        e=numberOfFrames;
        fish=mod(e,6);
        e=e-fish;
        count=e/6;     
        
        tic;
        pagerankX=[];
        for aa=1:count
            for bb=1:3
                tmp=[];
                song=[];
                you=[];
                for cc=1:size(X,1)
                    if X(cc,1)==s
                        % get frame a features
                        song=[song;X(cc,:)];
                    end
                    if X(cc,1)==s1
                        %get frame b features
                        you=[you;X(cc,:)];
                    end
                end
                
                TF1=isempty(song);
                TF2=isempty(you);
                
                if (TF1==0)&&(TF2==0)
                    % combine two
                    fff=[song;you];
                    % check which size is bigger ,S=number of features we want
                    a=size(song,1);
                    b=size(you,1);                    
                    
                    if a>b
                        S=b;
                    elseif a<b
                        S=a;
                    else
                        S=a;
                    end
                    
                    % compute adjacent matrix
                    adj1=zeros(a+b,a+b);
                    adj2=zeros(a+b,a+b);
                    
                    % normalize
                    for ii=1:size(fff,1)
                        tmp1=fff(ii,32:127);
                        tmp2=fff(ii,128:235)/norm(fff(ii,128:235));
                        tmp3=fff(ii,236:331)/norm(fff(ii,236:331));
                        tmp4=fff(ii,332:427)/norm(fff(ii,332:427));
                        tmp=[tmp1 tmp2 tmp3 tmp4];
                        fff(ii,32:size(fff,2))=tmp;
                    end
                    
                    % calculate distance
                    for ii=1:size(adj1,1)
                        for jj=1:size(adj1,2)
                            if ii==jj
                                adj1(ii,jj)=0;
                                adj2(ii,jj)=0;
                            else
                                ds=sqrt(sum((fff(ii,32:size(fff,2)) - fff(jj,32:size(fff,2))) .^ 2));
                                dp=sqrt(sum((fff(ii,2:3) - fff(jj,2:3)) .^ 2));
                                
                                if dp<=400
                                    ds=0;
                                end
                                
                                adj1(ii,jj)=ds;
                                adj2(ii,jj)=dp;
                            end
                        end
                    end
                    asd=zeros(size(adj1,1),1);
                    for ddd=1:size(adj1,1)
                        asd(ddd,1)=sum(adj1(ddd,:));
                    end
                    qwe=sum(asd);
                    qwe=qwe/size(adj1,1);
                    
                    for ddd=1:size(adj1,1)
                        if asd(ddd,1)>=qwe
                            adj1(ddd,:)=0;
                            adj1(:,ddd)=0;
                        end
                    end
 
                    % page rank
                    adj=adj1;
                    RRRR=pagerankv2(adj, 1e-2, .85);
                    [BB, II]=sort(RRRR,'ascend');
                                        
                    % choose the good features
                    for num=1:S
                        pagerankX=[pagerankX; fff(II(num,1),:)];
                    end
                end
                
                s=s+1;
                s1=s1+1;
            end
            s=s-1;
            s1=s1-1;
            s=s1+1;
            s1=s+3;
        end
        toc;
        % save
        save(sprintf('%s\\pagerankF%d_%d.mat',conf.tmppath,vi,j),'pagerankX');
        
        % show result!
        disp('show video');
        for frame = 1 : numberOfFrames
            thisFrame = read(mov, frame);
            subplot(1,2,1);
            imshow(thisFrame);
            hold on;
            subplot(1,2,2);
            imshow(thisFrame);
            hold on;
            % plot rest of points
            for aaa=1:size(pagerankX,1)
                if frame==pagerankX(aaa,1);
                    subplot(1,2,1);
                    plot(pagerankX(aaa,2),pagerankX(aaa,3),'r+');
                    hold on;
                end
            end
            
            for bbb=1:size(X,1)
                if frame==X(bbb,1)
                    subplot(1,2,2);
                    plot(X(bbb,2),X(bbb,3),'r+');
                    hold on;
                end
            end            
            pause(0.1);
        end
    end
end
end

