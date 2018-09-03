function [  ] = bow( conf, flag )
%BOW Summary of this function goes here
%   Detailed explanation goes here
actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;

if(strcmp(flag, 'train'))
%     for fnum=1:4
%         %load(sprintf('%s\\coeff%d.mat',conf.videopath,fnum));
%         %eval(sprintf('coeff=coeff%d;',fnum));
%         load(sprintf('%s\\codebook%d.mat',conf.videopath,fnum));
%         %eval(sprintf('cubecenters=cubecenters%d;',fnum));
%     end
    load(sprintf('%s\\codebook.mat',conf.tmppath));
    for j=1:actnum
        for i=1:numel(tridx)
            vi=tridx(i);
            X=load(sprintf('%s\\feature%d_%d.txt', conf.videopath, vi, j));
            X1=X(:,236:427);
%             X1=X(:,32:127);
%             X2=X(:,128:235);
%             X3=X(:,236:331);
%             X4=X(:,332:427);
            fprintf('%s\\feature%d_%d.txt\n', conf.videopath, vi, j);
            % hog
            %newcoeff=coeff1(:,1:conf.dim);
            %newX=X1*newcoeff;
            Z1=zeros(1,800);
            for k=1:size(X1,1)
                Y=[];
                for l=1:size(cubecenters1,1)
                    a=X1(k,:);
                    b=cubecenters1(l,:);
                    D = norm(a - b);
                    Y=[Y D];
                end
                [I S]=sort(Y,'descend');
                Z1(1,S(1,1))=Z1(1,S(1,1))+1;
            end
            save(sprintf('%s\\histogram1_%d_%d.mat',conf.tmppath, vi,j),'Z1');
            % hof
            %newcoeff=coeff2(:,1:conf.dim);
            %newX=X2*newcoeff;
%             Z2=zeros(1,conf.numclusters);
%             for k=1:size(X2,1)
%                 Y=[];
%                 for l=1:size(cubecenters2,1)
%                     a=X2(k,:);
%                     b=cubecenters2(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z2(1,S(1,1))=Z2(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram2_%d_%d.mat',conf.tmppath, vi,j),'Z2');
%             % mbhx
%             %newcoeff=coeff3(:,1:conf.dim);
%             %newX=X3*newcoeff;
%             Z3=zeros(1,conf.numclusters);
%             for k=1:size(X3,1)
%                 Y=[];
%                 for l=1:size(cubecenters3,1)
%                     a=X3(k,:);
%                     b=cubecenters3(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z3(1,S(1,1))=Z3(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram3_%d_%d.mat',conf.tmppath, vi,j),'Z3');
%             % mbhy
%             %newcoeff=coeff4(:,1:conf.dim);
%             %newX=X4*newcoeff;
%             Z4=zeros(1,conf.numclusters);
%             for k=1:size(X4,1)
%                 Y=[];
%                 for l=1:size(cubecenters4,1)
%                     a=X4(k,:);
%                     b=cubecenters4(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z4(1,S(1,1))=Z4(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram4_%d_%d.mat',conf.tmppath, vi,j),'Z4');
        end
    end
end

if(strcmp(flag, 'test'))
%     for fnum=1:4
%         load(sprintf('%s\\coeff%d.mat',conf.videopath,fnum));
%         load(sprintf('%s\\codebook%d.mat',conf.videopath,fnum));
%     end
    load(psrintf('%s\\codebook.mat',conf.tmppath));
    
    for j=1:actnum
        for i=1:numel(teidx)
            vi=teidx(i);
            X=load(sprintf('%s\\feature%d_%d.txt', conf.videopath, vi, j));
            fprintf('%s\\feature%d_%d.txt\n', conf.videopath, vi, j);
            X1=X(:,236:427);
%             X1=X(:,32:127);
%             X2=X(:,128:235);
%             X3=X(:,236:331);
%             X4=X(:,332:427);            
            % hog
            %newcoeff=coeff1(:,1:conf.dim);
            %newX=X1*newcoeff;
            Z1=zeros(1,conf.numclusters);
            for k=1:size(X1,1)
                Y=[];
                for l=1:size(cubecenters1,1)
                    a=X1(k,:);
                    b=cubecenters1(l,:);
                    D = norm(a - b);
                    Y=[Y D];
                end
                [I S]=sort(Y,'descend');
                Z1(1,S(1,1))=Z1(1,S(1,1))+1;
            end
            save(sprintf('%s\\histogram1_%d_%d.mat',conf.tmppath, vi,j),'Z1');
            % hof
            %newcoeff=coeff2(:,1:conf.dim);
            %newX=X2*newcoeff;
%             Z2=zeros(1,conf.numclusters);
%             for k=1:size(X2,1)
%                 Y=[];
%                 for l=1:size(cubecenters2,1)
%                     a=X2(k,:);
%                     b=cubecenters2(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z2(1,S(1,1))=Z2(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram2_%d_%d.mat',conf.tmppath, vi,j),'Z2');
%             % mbhx
%             %newcoeff=coeff3(:,1:conf.dim);
%             %newX=X3*newcoeff;
%             Z3=zeros(1,conf.numclusters);
%             for k=1:size(X3,1)
%                 Y=[];
%                 for l=1:size(cubecenters3,1)
%                     a=X3(k,:);
%                     b=cubecenters3(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z3(1,S(1,1))=Z3(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram3_%d_%d.mat',conf.tmppath, vi,j),'Z3');
%             % mbhy
%             %newcoeff=coeff4(:,1:conf.dim);
%             %newX=X4*newcoeff;
%             Z4=zeros(1,conf.numclusters);
%             for k=1:size(X4,1)
%                 Y=[];
%                 for l=1:size(cubecenters4,1)
%                     a=X4(k,:);
%                     b=cubecenters4(l,:);
%                     D = norm(a - b);
%                     Y=[Y D];
%                 end
%                 [I S]=sort(Y,'descend');
%                 Z4(1,S(1,1))=Z4(1,S(1,1))+1;
%             end
%             save(sprintf('%s\\histogram4_%d_%d.mat',conf.tmppath, vi,j),'Z4');            
        end
    end
end
    
end


 