% LICENSE & TERMS OF USE
% ----------------------
% VideoDarwin code implements a sequence representation technique.
% This specific version uses Hollywood2 dataset.
% You may need to download video data for Hollywood2 dataset.
% You need to download train/test splits mat file from http://users.cecs.anu.edu.au/~basura/data/train_test_split.mat
% Copyright (C) 2015  Basura Fernando
%
% 
% Terms of Use
% --------------
% This VideoDarwin software is strictly for non-commercial academic use only. 
% This VideoDarwin code or any modified version of it may not be used for any commercial activity, such as:
% a.	Commercial production development, Commercial production design, design validation or design assessment work.
% b.	Commercial manufacturing engineering work
% c.	Commercial research.
% d.	Consulting work performed by academic students, faculty or academic account staff
% e.	Training of commercial company employees.
% 
% License 
% -------
% The analysis work performed with the program(s) must be non-proprietary work. 
% Licensee and its contract users must be or be affiliated with an academic facility. 
% Licensee may additionally permit individuals who are students at such academic facility 
% to access and use the program(s). Such students will be considered contract users of licensee. 
% The program(s) may not be used for competitive analysis 
% (such as benchmarking) or for any commercial activity, including consulting.
%   
% 
% Inputs (optional)
% -----------------
% strst  : string start file index 
% strend : end file index 
%
% Instructions
% ------------
% Note : Please check TODOs : change the paths etc..
% Dependency : vlfeat-0.9.18, opencv-2.4.9, liblinear-1.93, libsvm-3.18 improved trajectory implementation (binary)
%
% Version      : 1.0
% Release date : 2015/07/21
% 
% Cite
% ----
% Modeling Video Evolution for Action Recognition
% Basura Fernando, Efstratios Gavves, Jose Oramas M., Amir Ghodrati, Tinne Tuytelaars; 
% The IEEE Conference on Computer Vision and Pattern Recognition (CVPR), 2015, pp. 5378-5387
%
% bibtex and the paper url : 
% http://www.cv-foundation.org/openaccess/content_cvpr_2015/html/Fernando_Modeling_Video_Evolution_2015_CVPR_paper.html
%
%
function Hollywood2_VideoDarwin(strst,strend)
    % TODO Add paths
    addpath('~/lib/vlfeat/toolbox');
    vl_setup();
	% TODO Add paths
	% add open cv to LD_LIB Path
    setenv('LD_LIBRARY_PATH','~/lib/OpenCV/OpenCV-2.4.2/build/lib'); 
	% TODO
	% add lib linear to path
	addpath('~/lib/liblinear/matlab');
	% TODO
	% add lib svm to path
    addpath('~/lib/libsvm/matlab');
    % TODO change paths inside getConfig
    [fullvideoname, videoname, classlabel,vocabDir,featDir,actionName,descriptor_path] = getConfig();
    
    if nargin < 1
        st = 1;
        send = 14000;
    else
        if ischar(strst)
            st = str2double(strst);
            send = str2double(strend); 
        else
            st = strst;
            send = strend;
        end
    end
	fprintf('Start : %d \n',st);
    fprintf('End : %d \n',send);
    
	
    % call this function (genDescriptors) Need a large amount of disk and good IO. This function generate dense features and save to disk.
    genDescriptors(st,send,fullvideoname,descriptor_path);     

    % create GMM model and BOW model. Look at this function see if parameters are okay for you.
    [gmm,vocab] = getGMMAndBOW(fullvideoname,vocabDir,descriptor_path);        

    % generate BOW, SPatial Pyramids and Fisher Vectors
    getBOWHistograms(fullvideoname,gmm,vocab,st,send,featDir,descriptor_path)    ;
    
    
    % Type of features that should be used for evaluation. You can also just use a single feature. e.g. feats = {'hog'}
    %feats = {'hog','hof','mbh'};    
    feats = {'mbh'};    
    for f = 1 : numel(feats)
        [VideoDarwinFeats,MaxPooledFeats,MeanPooledFeats] = getVideoDarwin(feats{f},featDir,videoname,0,st,send);
        ALL_Data_cell{f} = VideoDarwinFeats;  
    end   
    
    load('train_test_split.mat');    
    classid = classlabel;          
    trn_indx = cur_train_indx{1};
    test_indx = cur_test_indx{1};   
    
    Options.KERN = 5;    % non linear kernel
    Options.Norm =2;   % L2 normalization

	if Options.KERN == 5        
        for ch = 1 : size(ALL_Data_cell,2)                
            ALL_Data_cell{ch} = rootKernelMap(ALL_Data_cell{ch});
        end
    end  	
    
	
	if Options.Norm == 2       
         for ch = 1 : size(ALL_Data_cell,2)                 
            ALL_Data_cell{ch} = normalizeL2(ALL_Data_cell{ch});
        end
    end  
    
    if Options.Norm == 1       
         for ch = 1 : size(ALL_Data_cell,2)                 
            ALL_Data_cell{ch} = normalizeL1(ALL_Data_cell{ch});
        end
    end 
   
  
    % if there are multiple features (mbh,hog,hof,trj) then add weights to them
    if size(ALL_Data_cell,2) == 1
        weights = 1;
    end

    if size(ALL_Data_cell,2) == 2 || size(ALL_Data_cell,2) == 6 
        weights = [0.5 0.5];
    end

    if size(ALL_Data_cell,2) > 2 && size(ALL_Data_cell,2) ~= 6
        nch = size(ALL_Data_cell,2) ;
        weights = ones(1,nch) * 1/nch;
    end      
    		
    TrainClass = classid(trn_indx,:);
    TestClass = classid(test_indx,:);      
    for ch = 1 : size(ALL_Data_cell,2)        
        ALL_Data = ALL_Data_cell{ch};
        TrainData = ALL_Data(trn_indx,:);        
        TestData = ALL_Data(test_indx,:);

        TrainData_Kern_cell{ch} = [TrainData * TrainData'];    
        TestData_Kern_cell{ch} = [TestData * TrainData'];                        
        clear TrainData; clear TestData; clear ALL_Data;            
    end
        
    for cl = 1 : size(classid,2)            
        trnLBLB = TrainClass(:,cl);
        testLBL = TestClass(:,cl);        
        for wi = 1 : size(weights,1)
            TrainData_Kern = zeros(size(TrainData_Kern_cell{1}));
            TestData_Kern = zeros(size(TestData_Kern_cell{1}));
            if size(ALL_Data_cell,2) < 6
                 for ch = 1 : size(ALL_Data_cell,2)     
                     TrainData_Kern = TrainData_Kern + weights(wi,ch) * TrainData_Kern_cell{ch};
                     TestData_Kern = TestData_Kern + weights(wi,ch) * TestData_Kern_cell{ch};
                 end    
            else
                for ch = 1 : 3     
                     TrainData_Kern = TrainData_Kern + weights(wi,1) * TrainData_Kern_cell{ch};
                     TestData_Kern = TestData_Kern + weights(wi,1) * TestData_Kern_cell{ch};
                end
                for ch = 4 : 6     
                     TrainData_Kern = TrainData_Kern + weights(wi,2) * TrainData_Kern_cell{ch};
                     TestData_Kern = TestData_Kern + weights(wi,2) * TestData_Kern_cell{ch};
                end   
            end               
            ap_class(cl) = train_and_classify(TrainData_Kern,TestData_Kern,trnLBLB,testLBL);       
        end                   
    end
    for cl = 1 : size(classid,2)
            fprintf('%s = %1.2f \n',actionName{cl},ap_class(cl));
    end
    fprintf('mean = %1.2f \n',mean(ap_class));
end

function [gmm,vocab] = getGMMAndBOW(fullvideoname,vocabsDir,descriptor_path)
    samples = 1000000;
    bownumWords = 4000;
    gmmSize = 256;
    pcaFactor = 0.5;
    sampleFeatFile = fullfile(vocabsDir,'featfile.mat');
    modelFilePath = fullfile(vocabsDir,'gmmvocmodel.mat');
    if exist(modelFilePath,'file')
        load(modelFilePath);
        return;
    end
    if ~exist(sampleFeatFile,'file') 
    trjAll = zeros(samples,30); 
    hogAll = zeros(samples,96); 
    hofAll = zeros(samples,108); 
    mbhAll = zeros(samples,96*2); 
	warning('getGMMAndBOW : update num_videos only to include training videos')
    num_videos = size(fullvideoname,1);	% Note : update num_videos only to include training videos.
    st = 1;
    num_samples_per_vid = round(samples/ num_videos);
    for i = 1 : num_videos
        timest = tic();
        [~,partfile,~] = fileparts(fullvideoname{(i)});
        descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));
        if exist(descriptorFile,'file')
            load(descriptorFile);
        else
			warning('Descriptor file not found\n');
            [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(fullvideoname{i}) ;
            save(descriptorFile,'hog','hof','mbhx','mbhy','trj','obj','-v7.3');
        end
        hog = sqrt(hog); hof = sqrt(hof); mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
        
        rnsam = randperm(size(trj,1));
		if numel(rnsam) > num_samples_per_vid
            rnsam = rnsam(1:num_samples_per_vid);
        end
        send = st + numel(rnsam) - 1;
        trjAll(st:send,:) = trj(rnsam,:);
        hogAll(st:send,:) = hog(rnsam,:);
        hofAll(st:send,:) = hof(rnsam,:);
        mbhAll(st:send,:) = [mbhx(rnsam,:) mbhy(rnsam,:)];
        st = st + numel(rnsam);        
        timest = toc(timest);
        fprintf('%d/%d -> %s --> %1.2f sec\n',i,num_videos,fullvideoname{(i)},timest);
    end
    if send ~= samples
        trjAll(send+1:samples,:) = [];
        hogAll(send+1:samples,:) = [];
        hofAll(send+1:samples,:) = [];
        mbhAll(send+1:samples,:) = [];
    end 
        fprintf('start computing pca\n');
        gmm.pcamap.trj = pca(trjAll);
        gmm.pcamap.hog = pca(hogAll);
        gmm.pcamap.hof = pca(hofAll);
        gmm.pcamap.mbh = pca(mbhAll);
        fprintf('start saving descriptors\n');
        save(sampleFeatFile,'trjAll','hogAll','hofAll','mbhAll','gmm','-v7.3');    
    else
        load(sampleFeatFile);
    end    
    
    vocab.trj = [];
    vocab.hog = [];
    vocab.hof = [];
    vocab.mbh = [];
    
    
    fprintf('start create gmm 1\n');
    trjProjected = trjAll * gmm.pcamap.trj(:,1:size(gmm.pcamap.trj,1)*pcaFactor);
    [gmm.means.trj, gmm.covariances.trj, gmm.priors.trj] = vl_gmm(trjProjected', gmmSize);
    
    fprintf('start create gmm 2\n');
    hogProjected = hogAll * gmm.pcamap.hog(:,1:size(gmm.pcamap.hog,1)*pcaFactor);
    [gmm.means.hog, gmm.covariances.hog, gmm.priors.hog] = vl_gmm(hogProjected', gmmSize);
    
    fprintf('start create gmm 3\n');
    hofProjected = hofAll * gmm.pcamap.hof(:,1:size(gmm.pcamap.hof,1)*pcaFactor);
    [gmm.means.hof, gmm.covariances.hof, gmm.priors.hof] = vl_gmm(hofProjected', gmmSize);
    
    fprintf('start create gmm 4\n');
    mbhProjected = mbhAll * gmm.pcamap.mbh(:,1:size(gmm.pcamap.mbh,1)*pcaFactor);
    [gmm.means.mbh, gmm.covariances.mbh, gmm.priors.mbh] = vl_gmm(mbhProjected', gmmSize);
    
    fprintf('start saving gmm and bow models\n');
    save(modelFilePath,'vocab','gmm','-v7.3');    
    
end

function genDescriptors(st,send,fullvideoname,descriptor_path)
	totalSize = 0;
	num_videos = size(fullvideoname,1);	
    for i = st : min(send,numel(fullvideoname))  			
		timest = tic();        
        [~,partfile,~] = fileparts(fullvideoname{i});
        descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));		
        if exist(descriptorFile,'file')
            %load(descriptorFile);            
        else
			try 
            [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(fullvideoname{i}) ;
            save(descriptorFile,'hog','hof','mbhx','mbhy','trj','obj','-v7.3');
			catch e
				fprintf('ERROR %s\n');
				e
			end
        end
		sDescription = dir(descriptorFile);
		sizef = sDescription.bytes / (1024 * 1024);
		timest = toc(timest);		
		fprintf('%d -> %s --> size %1.1f Mb--> %1.1f sec.\n',i,descriptorFile,sizef,timest);
    end
end

function getBOWHistograms(fullvideoname,gmm,vocab,st,send,featDir,descriptor_path)    
    pcaFactor = 0.5;    
    dict_size = size(vocab.trj,2);
    if ~exist(fullfile(featDir,'mbh'),'dir')
    mkdir(fullfile(featDir,'trj'));
    mkdir(fullfile(featDir,'hog'));
    mkdir(fullfile(featDir,'hof'));
    mkdir(fullfile(featDir,'mbh'));
    end
    for i = st : min(size(fullvideoname,1),send)   
        [~,partfile,~] = fileparts(fullvideoname{i});
        file = fullfile(featDir,'mbh',sprintf('%s-fv.mat',partfile));         
        descriptorFile = fullfile(descriptor_path,sprintf('%s.mat',partfile));
        if exist(file,'file')
			fprintf('%d --> %s Exists \n',i,file);            
            continue;
        end
		timest = tic();
		fprintf('Processing Video file %s\n',partfile);
        
		
        if exist(descriptorFile,'file')
            load(descriptorFile);
        else
			try 
				[obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(fullvideoname{i}) ;
			catch e
				e
				continue;
			end
            %save(descriptorFile,'hog','hof','mbhx','mbhy','trj','obj','-v7.3');
        end
        hog = sqrt(hog); hof = sqrt(hof); mbhx = sqrt(mbhx);mbhy = sqrt(mbhy);
		mbh = [mbhx mbhy];
        frames = unique(obj(:,1));
        
        %hist_trj = zeros( numel(frames),dict_size);
        %hist_hog = zeros( numel(frames),dict_size);
        %hist_hof = zeros( numel(frames),dict_size);
        %hist_mbh = zeros( numel(frames),dict_size);
        
        fv_trj = zeros( numel(frames),pcaFactor*size(gmm.pcamap.trj,1)*2*size(gmm.means.trj,2));
        fv_hog = zeros( numel(frames),pcaFactor*size(gmm.pcamap.hog,1)*2*size(gmm.means.hog,2));
        fv_hof = zeros( numel(frames),pcaFactor*size(gmm.pcamap.hof,1)*2*size(gmm.means.hof,2));
        fv_mbh = zeros( numel(frames),pcaFactor*size(gmm.pcamap.mbh,1)*2*size(gmm.means.mbh,2));
        
        %sp_trj = zeros( numel(frames),dict_size*5);
        %sp_hog = zeros( numel(frames),dict_size*5);
        %sp_hof = zeros( numel(frames),dict_size*5);
        %sp_mbh = zeros( numel(frames),dict_size*5);
        
        
        for frm = 1 : numel(frames)
            frm_indx = find(obj(:,1)==frames(frm));            
            
            %sp_trj(frm,:) = getSPM(obj,frm_indx,trj,vocab.trj);
            %sp_hog(frm,:) = getSPM(obj,frm_indx,hog,vocab.hog);
            %sp_hof(frm,:) = getSPM(obj,frm_indx,hof,vocab.hof);
            %sp_mbh(frm,:) = getSPM(obj,frm_indx,mbh,vocab.mbh);
            
            %hist_trj(frm,:)= getHistogram(trj,vocab.trj,frm_indx,dict_size);
            %hist_hof(frm,:)= getHistogram(hog,vocab.hog,frm_indx,dict_size);
            %hist_hog(frm,:)= getHistogram(hof,vocab.hof,frm_indx,dict_size);
            %hist_mbh(frm,:)= getHistogram(mbh,vocab.mbh,frm_indx,dict_size);            
            
            fv_trj(frm,:) = getFv(trj,gmm.means.trj, gmm.covariances.trj, gmm.priors.trj,gmm.pcamap.trj,pcaFactor,frm_indx)   ;
            fv_hog(frm,:) = getFv(hog,gmm.means.hog, gmm.covariances.hog, gmm.priors.hog,gmm.pcamap.hog,pcaFactor,frm_indx)   ;
            fv_hof(frm,:) = getFv(hof,gmm.means.hof, gmm.covariances.hof, gmm.priors.hof,gmm.pcamap.hof,pcaFactor,frm_indx)   ;
            fv_mbh(frm,:) = getFv(mbh,gmm.means.mbh, gmm.covariances.mbh, gmm.priors.mbh,gmm.pcamap.mbh,pcaFactor,frm_indx)   ;     
            
        end
        %save_mat_file('trj',hist_trj,partfile,featDir)    ;
        %save_mat_file('hog',hist_hog,partfile,featDir)    ;
        %save_mat_file('hof',hist_hof,partfile,featDir)    ;
        %save_mat_file('mbh',hist_mbh,partfile,featDir)    ;       
        
        %save_mat_file_sp('trj',sp_trj,partfile,featDir)    ;
        %save_mat_file_sp('hog',sp_hog,partfile,featDir)    ;
        %save_mat_file_sp('hof',sp_hof,partfile,featDir)    ;
        %save_mat_file_sp('mbh',sp_mbh,partfile,featDir)    ;
        
        save_mat_file_fv('trj',fv_trj,partfile,featDir)    ;
        save_mat_file_fv('hog',fv_hog,partfile,featDir)    ;
        save_mat_file_fv('hof',fv_hof,partfile,featDir)    ;
        save_mat_file_fv('mbh',fv_mbh,partfile,featDir)    ;
        timest = toc(timest);
		fprintf('%d--> %s done --> time  %1.1f sec \n',i,file,timest);
    end
end

function h = getHistogram(descr,dict,indx,dict_size)
    [~, binsa] = min(vl_alldist(dict, descr(indx,:)' ), [], 1) ;
    h = hist(binsa,1:dict_size);
end

function h = getFv(descr,means, covariances, priors,pcamap,pcaFactor,indx)  
    comps = pcamap(:,1:size(pcamap,1)*pcaFactor);
    h = vl_fisher( (descr(indx,:)*comps)', means, covariances, priors);
end

function h = getSPM(obj,frm_indx,feats,dict)
    xcordes = obj(frm_indx,8);
    ycordes = obj(frm_indx,9);
    descr = feats(frm_indx,:)';
    model.vocab  = dict;
    width = 1 ;
    height = 1;
    numWords = size(model.vocab, 2) ;
    model.numSpatialX = [ 2 ];
    model.numSpatialY = [ 2 ] ;
    [~, binsa] = min(vl_alldist(model.vocab, descr ), [], 1) ;
    SP_SIZE = 0;
    for i = 1:length(model.numSpatialX)
        SP_SIZE = SP_SIZE + model.numSpatialX(i)*model.numSpatialY(i);
    end
    for i = 1:length(model.numSpatialX)
      binsx = vl_binsearch(linspace(0,width,model.numSpatialX(i)+1), xcordes) ;
      binsy = vl_binsearch(linspace(0,height,model.numSpatialY(i)+1), ycordes) ;
      % combined quantization
      bins = sub2ind([model.numSpatialY(i), model.numSpatialX(i), numWords], ...
                     binsy,binsx,binsa') ;
      h = zeros(model.numSpatialY(i) * model.numSpatialX(i) * numWords, 1) ;
      h = vl_binsum(h, ones(size(bins)), bins) ;
    end
    h0 = hist(binsa,1:numWords);
    h = [ h0   h'];    
end

function save_mat_file(feat,histv,indx,featDir)    
        file = fullfile(featDir,feat,sprintf('%s-bow.mat',indx));        
        save(file,'histv')
end

function save_mat_file_fv(feat,histv,indx,featDir)    
        file = fullfile(featDir,feat,sprintf('%s-fv.mat',indx));        
        save(file,'histv')
end

function save_mat_file_sp(feat,histv,indx,featDir)    
        file = fullfile(featDir,feat,sprintf('%s-sp.mat',indx));        
        save(file,'histv')
end

function [fullvideoname, videoname, classlabel,vocabDir,featDir,actionName,descriptor_path] = getConfig()
	% TODO : Change the paths
     if exist('~/remote/Hollywood2/train_test_split.mat','file') == 2     
        load('~/remote/Hollywood2/train_test_split.mat');
     else
         urlwrite('http://users.cecs.anu.edu.au/~basura/data/train_test_split.mat','train_test_split.mat');
         load('train_test_split.mat');
     end
    
	vocabDir = '~/remote/Data/Vocab'; % Path where dictionary/GMM will be saved.
    featDir = '~/remote/Data/feats'; % Path where features will be saved
    descriptor_path = '~/remote/Data/descriptor/'; % change paths here 
    
    for i = 1 : length(fnames)
        fullvideoname{i,1}=fullfile('~/remote/Hollywood2/AVIClips',sprintf('%s.avi',fnames{i}));
        videoname{i,1} = fnames{i};
    end
    classlabel = labels2;    
    actionName = {'AnswerPhone','DriveCar','Eat','FightPerson','GetOutCar','HandShake','HugPerson','Kiss','Run','SitDown','SitUp','StandUp'};		
end

function W = genRepresentation(data,CVAL)
    OneToN = [1:size(data,1)]';    
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_fow = liblinearsvr(getNonLinearity(Data),CVAL,2); 			
    order = 1:size(data,1);
    [~,order] = sort(order,'descend');
    data = data(order,:);
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_rev = liblinearsvr(getNonLinearity(Data),CVAL,2); 			              
    W = [W_fow ; W_rev];
end

function Data = getNonLinearity(Data)
    %Data = sign(Data).*sqrt(abs(Data));
    %Data = vl_homkermap(Data',2,'kchi2');
    %Data =  sqrt(abs(Data));	                	
    Data =  sqrt(Data);	      
end

function [ALL_Data,MAX_Data,MEAN_Data] = getVideoDarwin(featType,featDir,Videos,isIntegral,stpoint,endpoint)
    rankType = 'non-lin';      
    CVAL = 1; % C value for the ranking function or SVR
    GAPF = 1;
    MAXF = 10000;
    feature_out = sprintf('%s/%s',featDir,featType);
    tempfeatDir = '/media/basura/OSDisk/Data';
    OUT_FOLDER = sprintf('%s/representation_fv_%s_%s',tempfeatDir,featType,rankType);   
    if exist(OUT_FOLDER,'dir') == 0
        mkdir(OUT_FOLDER);
    end
    isall = false;
	TOTAL = size(Videos,1);    
    endpoint = min(TOTAL,endpoint);
    if stpoint == 1 && min(endpoint,TOTAL) == TOTAL      
       ALL_Data =  zeros(TOTAL,4001) ;  
       MAX_Data =  zeros(TOTAL,4000) ;
       MEAN_Data =  zeros(TOTAL,4000) ; 
       isall = true;
    else
        ALL_Data = [];MAX_Data = [];MEAN_Data=[];
    end
    
    for i = stpoint : min(endpoint,TOTAL)
        name = Videos{i}; 
        [~,name]=fileparts(name);
        if isIntegral > 0
            if isIntegral == 1
                ActionRepresentationFile = sprintf('%s/%d-Cval%1.6f-Gap%d-Max-%d-integral.mat',OUT_FOLDER,i,CVAL,GAPF,MAXF);
            else
                ActionRepresentationFile = sprintf('%s/%d-Cval%1.6f-Gap%d-Max-%d-integral-%d.mat',OUT_FOLDER,i,CVAL,GAPF,MAXF,isIntegral);
            end
        else            
            ActionRepresentationFile = sprintf('%s/%d-Cval%1.6f-Gap%d-Max-%d.mat',OUT_FOLDER,i,CVAL,GAPF,MAXF);
        end
        fprintf('Process %d/%d \t %s \t  \n',i,numel(stpoint : min(endpoint,TOTAL)),ActionRepresentationFile);
        if exist(ActionRepresentationFile,'file') == 2
            if isall
                load(ActionRepresentationFile);
                WW = W';
                if size(WW,2) ~= size(ALL_Data,2) && i == 1
                     ALL_Data =  zeros(TOTAL,size(WW,2)+1) ;  
                     MAX_Data =  zeros(TOTAL,size(W,2)) ;
                     MEAN_Data =  zeros(TOTAL,size(W,2)) ;
                end
                ALL_Data(i,:) =    [W' 0];  
				if isIntegral == 0
                    if size(maxHog,2) ~= size(MAX_Data,2) && i == 1
                        MAX_Data =  zeros(TOTAL,size(maxHog,2)) ;
                        MEAN_Data =  zeros(TOTAL,size(maxHog,2)) ;
                    end
                    MAX_Data(i,:) = maxHog;
                    MEAN_Data(i,:) = mHog;
				end
            end
            continue;
        end                   
        MATFILE = fullfile(feature_out,sprintf('%s-fv.mat',name));        
        load(MATFILE);
        data  = histv; clear histv;   
        W = genRepresentation(data,CVAL);
        if isall && ~strcmp('analyze',rankType)
            WW = W';
            if size(WW,2) ~= size(ALL_Data,2) && i == 1
                     ALL_Data =  zeros(TOTAL,size(WW,2)) ;  
                     MAX_Data =  zeros(TOTAL,size(W,2)) ;
                     MEAN_Data =  zeros(TOTAL,size(W,2)) ;
            end
            ALL_Data(i,:) = [W' 0];             
        end
        if isIntegral == 0
            maxHog = max(data);            
            mHog = mean(data);
            if isall                
                if size(maxHog,2) ~= size(MAX_Data,2) && i == 1                     
                     MAX_Data =  zeros(TOTAL,size(maxHog,2)) ;
                     MEAN_Data =  zeros(TOTAL,size(mHog,2)) ;
                end
                
                MAX_Data(i,:) = maxHog;
                MEAN_Data(i,:) = mHog;
            end
        end
        
		
        if ~strcmp('analyze',rankType)
            if isIntegral > 0
                save(ActionRepresentationFile,'W');
            else
                save(ActionRepresentationFile,'W','mHog','maxHog');
            end        
        end
    end

end

function X = normalizeL2(X)
	for i = 1 : size(X,1)
		if norm(X(i,:)) ~= 0
			X(i,:) = X(i,:) ./ norm(X(i,:));
		end
    end	   
end

function X = rootKernelMap(X)
    X = sqrt(X);
end

function [ap ] = train_and_classify(TrainData_Kern,TestData_Kern,TrainClass,TestClass)
         nTrain = 1 : size(TrainData_Kern,1);
         TrainData_Kern = [nTrain' TrainData_Kern];         
         nTest = 1 : size(TestData_Kern,1);
         TestData_Kern = [nTest' TestData_Kern];
         C = [0.01 0.1 1 5 10 50 100 500 1000];
		 % TODO : Note that here it is best to do the cross validation on training set.
		 %warning('It is best to do the cross validation on training set. Skipping cross validation!');
		 C = [100];
         model = svmtrain(TrainClass, TrainData_Kern, sprintf('-t 4 -c %1.6f  -q ',C));
         [~, acc, scores] = svmpredict(TestClass, TestData_Kern ,model);	                 
         [rc, pr, info] = vl_pr(TestClass, scores(:,1)) ; 
         ap = info.ap;      
end

function [trn,tst] = generateTrainTest(classid)
    trn = zeros(numel(classid),1);
    tst = zeros(numel(classid),1);
    maxC = max(classid);
    for c = 1 : maxC
        indx = find(classid == c);
        n = numel(indx);
        tindx = indx(1:4);
        testindx = indx(5:end);
        trn(tindx,1) = 1;
        tst(testindx,1) = 1;
    end
end

function [X] = getLabel(classid)
    X = zeros(numel(classid),max(classid))-1;
    for i = 1 : max(classid)
        indx = find(classid == i);
        X(indx,i) = 1;
    end
end

function w = liblinearsvr(Data,C,normD)
    if normD == 2
        Data = normalizeL2(Data);
    end
    
    if normD == 1
        Data = normalizeL1(Data);
    end
    % in case it is complex, takes only the real part.	
    N = size(Data,1);
    Labels = [1:N]';
    model = train(double(Labels), sparse(double(Data)),sprintf('-c %d -s 11 -q',C) );
    w = model.w';
end

% TODO: Change the paths and improved trajectory binary paths
function [obj,trj,hog,hof,mbhx,mbhy] = extract_improvedfeatures(videofile)   
    [~,nameofvideo,~] = fileparts(videofile);
    txtFile = fullfile('~/remote/Data/temp/tmpfiles',sprintf('%s-%1.6f',nameofvideo,tic())); % path of the temporary file
    % Here the path should be corrected
    system(sprintf('~/lib/improved_trajectory_release/release/DenseTrackStab %s > %s',videofile,txtFile));
    data = dlmread(txtFile);
    delete(txtFile);
	obj = data(:,1:10);
    trj = data(:,11:40);
    hog = data(:,41:41+95);    
    hof = data(:,41+96:41+96+107);
    mbhx  = data(:,41+96+108:41+96+108+95);
    mbhy  = data(:,41+96+108+96:41+96+108+96+95);
end
