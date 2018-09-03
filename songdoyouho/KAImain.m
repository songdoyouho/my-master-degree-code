% reset the path to your path first and add "draw" folder in your matlab path
% conf = path and some parameter input for each function
% other parameter setting are also provided

% rng('shuffle');
tic;
hwait=waitbar(0,'PLZ WAIT>>>>>>>>');
choose_dataset = 'jpl'; % jpl or dog
if strcmp(choose_dataset,'dog')
    % parameter
    conf.actnum=10;
    conf.videonumber=209;
    conf.nnn=nnn;
    % path
    conf.resultname=sprintf('test_result');
    conf.indexpath='H:\dogcentric\index';
    conf.videopath='H:\dogcentric';
    conf.tmppath='H:\dogcentric\tmp';
    conf.modelpath='H:\dogcentric\model';
    conf.resultpath='H:\dogcentric\result';
end
if strcmp(choose_dataset,'jpl')
    % parameter
    conf.actnum=7;
    conf.videonumber=84;
    conf.nnn=nnn;
    % path
    conf.resultname=sprintf('test_result');
    conf.indexpath='I:\jpl_seg\index';
    conf.videopath='I:\jpl_seg';
    conf.tmppath='I:\jpl_seg\tmp';
    conf.modelpath='I:\jpl_seg\model';
    conf.resultpath='I:\jpl_seg\result';
end
mkdir(conf.resultpath);
mkdir(conf.modelpath);
mkdir(conf.tmppath);

% toolbox path
conf.svmpath='C:\\Users\diesel\Desktop\libsvm-3.21\matlab';
conf.vlfeatpath='C:\\Users\diesel\Desktop\vlfeat-0.9.20';
conf.liblinear='C:\\Users\diesel\Desktop\liblinear-2.1';
conf.videodarwin='C:\\Users\diesel\Desktop\bfernando-videodarwin-18dc16901e35';
conf.decomposition='C:\\Users\diesel\Desktop\Oreifej_RPCA';
conf.opticalflow='C:\\Users\diesel\Desktop\TVL1';

conf.trajlength = 16;
conf.numclusters=256; % GMM cluster num

getopticalflow(conf);
mymotiondecomp(conf, 0.1); % decomp thr = 0.1
performkmean(conf, 10); % kmean cluster = traj number / 10
getfeature(conf);
fisher(conf);
darwin(conf);

% loop svm 100 times
for nnn = 1 : 100
    waitbar(nnn/100,hwait,sprintf('GOGOGO %d percent',nnn));
    
    % load label
    conf.load_encoding=1; %fisher vector
    conf.load_W=1; % video darwin
    
    %     % produce random index
    %     folder=dir('I:\jpl_seg\feature');
    %     tridx=cell(7,1);
    %     teidx=cell(7,1);
    %     for l=3:9
    %         path=['I:\jpl_seg\feature\' folder(l).name '\'];
    %         filelist=dir(path);
    %         file=strvcat(filelist(3:end).name);
    %         index=randperm(size(file,1));
    %         tridx{l-2,1}=index(1,1:fix(size(index,2)/2));
    %         teidx{l-2,1}=index(1,fix(size(index,2)/2)+1:size(index,2));
    %     end
    %     save(sprintf('%s\\tridx%d.mat',conf.indexpath,nnn),'tridx');
    %     save(sprintf('%s\\teidx%d.mat',conf.indexpath,nnn),'teidx');
    
    % load tridx and teidx
    load(sprintf('%s\\tridx%d.mat',conf.indexpath,nnn));
    load(sprintf('%s\\teidx%d.mat',conf.indexpath,nnn));
    conf.tridx=tridx;
    conf.teidx=teidx;
    
    relevance_intosvm(conf,'train');
    relevance_intosvm(conf,'test');
end

% calculate accuracy and display
cccount = matchresult(conf);
[B I] = sort(cccount(:,4),'descend');
cccount = cccount(I,:);
if strcmp(choose_dataset,'dog')
    dogconfusion(conf);
end
if strcmp(choose_dataset,'jpl')
    confusion(conf);
end
close(hwait);
toc;



