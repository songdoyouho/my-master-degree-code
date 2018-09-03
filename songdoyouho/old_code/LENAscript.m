% loop 100 times
% tic;
% for nnn=1:100
    conf.trvideo=10;
    conf.tevideo=10;
    conf.actnum=13;
    conf.videonumber=260;
    conf.numclusters=256;
    conf.nnn=nnn;
    % path
    conf.resultname='fisher_result';
    conf.videopath='D:\LENA_Downsampled';
    conf.tmppath='D:\LENA_Downsampled\tmp';
    conf.modelpath='D:\LENA_Downsampled\model';
    conf.resultpath='D:\LENA_Downsampled\result';
    conf.layeronepath='C:\Users\diesel\Desktop\dogcentric\layerone';
    conf.svmpath='C:\Users\diesel\Desktop\libsvm-3.21\matlab';
    conf.vlfeatpath='C:\Users\diesel\Desktop\vlfeat-0.9.20';
    conf.liblinear='C:\Users\diesel\Desktop\liblinear-2.1';
    conf.videodarwin='C:\Users\diesel\Desktop\bfernando-videodarwin-18dc16901e35';
    
    % load label
    conf.loadencoding=1; %fisher vector
    conf.loadselect=0; % for page rank
    conf.loadW=0; % video darwin
    conf.loadseg2W=0; % video darwin segmentation
    conf.loadseg03W=0;
    % random index
    folder=dir('D:\LENA_Downsampled\feature');
    tridx=cell(13,1);
    teidx=cell(13,1);
    for l=3:12
        path=['D:\LENA_Downsampled\feature\' folder(l).name '\'];
        filelist=dir(path);
        file=strvcat(filelist(3:end).name);
        index=randperm(size(file,1));
        tridx{l-2,1}=index(1,1:fix(size(index,2)/2));
        teidx{l-2,1}=index(1,fix(size(index,2)/2)+1:size(index,2));
    end
    conf.tridx=tridx;
    conf.teidx=teidx;
    %conf.nnn=nnn;
    %getfeature(conf);
%     disp('getfisher-train');
%     getfisher(conf,'train');
%     disp('getfisher-test');
%     getfisher(conf,'test');
%     disp('intosvm-train');
%     newintosvm(conf,'train');
%     disp('intosvm-test');
%     newintosvm(conf,'test');
% end
% toc;
