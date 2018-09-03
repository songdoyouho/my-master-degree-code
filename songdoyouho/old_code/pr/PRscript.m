weight=[0.75 0.25];
threshold=[200];
number=[0.9];
allacc=[];

% parameter
conf.actnum=10;
conf.numclusters=256;
conf.videonumber=209;
% path
conf.resultname=sprintf('pr_weight_%d_result',weight);
conf.pr_matrixpath='D:\pr_matrix';
conf.indexpath='C:\Users\diesel\Desktop\dogcentric\index';
conf.videopath='C:\Users\diesel\Desktop\dogcentric';
conf.tmppath='C:\Users\diesel\Desktop\dogcentric\tmp';
conf.modelpath='C:\Users\diesel\Desktop\dogcentric\model';
conf.resultpath='C:\Users\diesel\Desktop\dogcentric\pr_result';
conf.keyframepath='C:\Users\diesel\Desktop\dogcentric\keyframe';
conf.layeronepath='C:\Users\diesel\Desktop\dogcentric\layerone';
conf.svmpath='C:\Users\diesel\Desktop\libsvm-3.21\matlab';
conf.vlfeatpath='C:\Users\diesel\Desktop\vlfeat-0.9.20';
conf.liblinear='C:\Users\diesel\Desktop\liblinear-2.1';
conf.videodarwin='C:\Users\diesel\Desktop\bfernando-videodarwin-18dc16901e35';
% load label
conf.loadencoding=0; %fisher vector
conf.loadselect=1; % for page rank
conf.loadW=0; % video darwin
conf.loadsegW=1; % video darwin segmentation
conf.loadpoolingW=0; % maxpooling

for wnum=1:size(weight,2);
    tic;
    hwait=waitbar(0,'PLZ WAIT>>>>>>>>');
    load(sprintf('%s\\tridx1.mat',conf.indexpath));
    load(sprintf('%s\\teidx1.mat',conf.indexpath));
    conf.tridx=tridx;
    conf.teidx=teidx;
    pr_loop(conf, weight(1,wnum), threshold, number);
    prgetfisher;
    prvideodarwin;
    for nnn=1:100
        waitbar(nnn/100,hwait,sprintf('GOGOGO %d percent',nnn));
        conf.nnn=nnn;
        % load tridx and teidx
        load(sprintf('%s\\tridx%d.mat',conf.indexpath,nnn));
        load(sprintf('%s\\teidx%d.mat',conf.indexpath,nnn));
        conf.tridx=tridx;
        conf.teidx=teidx;
               
        disp('intosvm-train');
        newintosvm(conf,'train');
        disp('intosvm-test');
        newintosvm(conf,'test');
    end
    dogconfusion(conf);
    acc=matchresult(conf);
    allacc=[allacc; acc];
    toc;
end