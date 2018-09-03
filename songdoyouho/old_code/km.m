function [  ] = km( conf )
%KM Summary of this function goes here
%   Detailed explanation goes here
trainnum=conf.trvideo;
testnum=conf.trvideo;
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;

% build codebook
%X=[];
cbcount=1;
for j=1:actnum
    for i=1:numel(tridx)
        vi=tridx(i);
        a=load(sprintf('%s\\feature%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\feature%d_%d.txt\n', conf.videopath, vi, j);
        if size(a,1)<conf.trfnum
            %X=cat(1,X,a);
            X1=a(:,236:427);
            pool = parpool;                      % Invokes workers
            stream = RandStream('mlfg6331_64');  % Random number stream
            options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
            tic; % Start stopwatch timer
            [idx,cubecenters1,sumd,D] = kmeans(X1,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
            toc % Terminate stopwatch timer
            delete(pool);
            save(sprintf('%s\\codebook%d.mat', conf.tmppath,cbcount), 'cubecenters1');
            cbcount=cbcount+1;
        else
            fnum=conf.trfnum;
            fidx=randperm(size(a,1),fnum);
            X=[];
            for k=1:numel(fidx)
                X=cat(1,X,a(fidx(k),:));
            end
            X1=X(:,236:427);
            pool = parpool;                      % Invokes workers
            stream = RandStream('mlfg6331_64');  % Random number stream
            options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
            tic; % Start stopwatch timer
            [idx,cubecenters1,sumd,D] = kmeans(X1,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
            toc % Terminate stopwatch timer
            delete(pool);
            save(sprintf('%s\\codebook%d.mat', conf.tmppath,cbcount), 'cubecenters1');
            cbcount=cbcount+1;
        end
        disp('ok');
    end
end
save(sprintf('%s\\allfeature.mat',conf.tmppath), 'X');
%         X1=X(:,2:31);  % trajectory
%         X2=X(:,32:127); % hog
%         X3=X(:,128:235); % hof
%         X4=X(:,236:331); % mbhx
%         X5=X(:,332:427); % mbhy

% kmeans
X=[];
for i=1:actnum*trainnum
    load(sprintf('%s\\codebook%d.mat',conf.tmppath,i));
    X=[X;cubecenters1];
end
pool = parpool;                      % Invokes workers
stream = RandStream('mlfg6331_64');  % Random number stream
options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
tic; % Start stopwatch timer
[idx,cubecenters1,sumd,D] = kmeans(X,800,'Options',options,'MaxIter',10000,'Replicates',10);
toc % Terminate stopwatch timer
delete(pool);
save(sprintf('%s\\codebook.mat', conf.tmppath), 'cubecenters1');

% disp('codebook1...');
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,cubecenters1,sumd,D] = kmeans(X1,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
% toc % Terminate stopwatch timer
% delete(pool);
% save(sprintf('%s\\codebook1.mat', conf.tmppath), 'cubecenters1');

% disp('codebook2...');
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,cubecenters2,sumd,D] = kmeans(X2,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
% toc % Terminate stopwatch timer
% delete(pool);
% save(sprintf('%s\\codebook2.mat', conf.tmppath), 'cubecenters2');
% 
% disp('codebook3...');
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,cubecenters3,sumd,D] = kmeans(X3,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
% toc % Terminate stopwatch timer
% delete(pool);
% save(sprintf('%s\\codebook3.mat', conf.tmppath), 'cubecenters3');
% 
% disp('codebook4...');
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,cubecenters4,sumd,D] = kmeans(X4,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
% toc % Terminate stopwatch timer
% delete(pool);
% save(sprintf('%s\\codebook4.mat', conf.tmppath), 'cubecenters4');
% 
% disp('codebook5...');
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,cubecenters5,sumd,D] = kmeans(X5,numclusters,'Options',options,'MaxIter',10000,'Replicates',10);
% toc % Terminate stopwatch timer
% delete(pool);
% save(sprintf('%s\\codebook5.mat', conf.tmppath), 'cubecenters5');

end

