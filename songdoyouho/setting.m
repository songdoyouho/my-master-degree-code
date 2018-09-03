ccc
tic;
hwait=waitbar(0,'PLZ WAIT>>>>>>>>');
choose_dataset = 'dog'; % jpl or dog
for nnn = 1:100
    waitbar(nnn/100,hwait,sprintf('GOGOGO %d percent',nnn));
    if strcmp(choose_dataset,'dog')
        % parameter
        conf.actnum=10;
        conf.numclusters=256;
        conf.videonumber=209;
        conf.nnn=nnn;
        % path
        conf.resultname=sprintf('test_result');
        conf.indexpath='H:\dogcentric\index';
        conf.videopath='H:\dogcentric';
        conf.tmppath='H:\dogcentric\tmp';
        conf.modelpath='H:\dogcentric\model';
        conf.resultpath='H:\dogcentric\result';
        conf.keyframepath='H:\dogcentric\keyframe';
        conf.layeronepath='H:\dogcentric\layerone';
    end
    if strcmp(choose_dataset,'jpl')
        % parameter
        conf.actnum=7;
        conf.numclusters=256;
        conf.videonumber=84;
        conf.nnn=nnn;
        % path
        conf.resultname=sprintf('codebook_result');
        conf.indexpath='I:\jpl_seg\index';
        conf.videopath='I:\jpl_seg';
        conf.tmppath='I:\jpl_seg\tmp';
        conf.modelpath='I:\jpl_seg\model';
        conf.resultpath='I:\jpl_seg\result';
        conf.keyframepath='I:\jpl_seg\keyframe';
        conf.layeronepath='I:\jpl_seg\layerone';
    end
    % toolbox path
    conf.svmpath='C:\Users\diesel\Desktop\libsvm-3.21\matlab';
    conf.vlfeatpath='C:\Users\diesel\Desktop\vlfeat-0.9.20';
    conf.liblinear='C:\Users\diesel\Desktop\liblinear-2.1';
    conf.videodarwin='C:\Users\diesel\Desktop\bfernando-videodarwin-18dc16901e35';
    conf.opticalflow='C:\\Users\diesel\Desktop\TVL1';
    % load label
    conf.load_encoding=1; %fisher vector
    conf.load_W=0; % video darwin
    conf.load_relevance_encoding=0;
    conf.load_relevance_W=0;
    
    conf.trajlength = 11;
    % load tridx and teidx
    load(sprintf('%s\\tridx%d.mat',conf.indexpath,nnn));
    load(sprintf('%s\\teidx%d.mat',conf.indexpath,nnn));
    conf.tridx=tridx;
    conf.teidx=teidx;
end
close(hwait);
toc;
clc

