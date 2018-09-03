% LICENSE & TERMS OF USE
% ----------------------
% VideoDarwin code implements a sequence representation technique.
% This code shows how to apply VideoDarwin for gesture recognition.
% We use skeleton data provide with chalearn http://gesture.chalearn.org/
% In this experiment we use vector quantized features (dictionary of 100).
% Train data is used for training and val data is used for testing. 
% 
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
%
%
% Instructions
% ------------
% Note : Please check TODOs : change the paths etc..
% Dependency : vlfeat-0.9.18, liblinear-1.93, libsvm-3.18 
%
% Version      : 1.0
% Release date : 2015/08/02
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
function ChaLearn_VideoDarwin()    
    % TODO
    addpath('~/lib/vlfeat/toolbox');
    vl_setup();		
    % TODO
	% add lib linear to path
	addpath('~/lib/liblinear/matlab');
	% TODO
	% add lib svm to path
    addpath('~/lib/libsvm/matlab');
    
    %data downloads and pre-process
    if exist('ChaLearn_train_test_split.mat','file') ~= 2            
        urlwrite('http://users.cecs.anu.edu.au/~basura/data/ChaLearn_train_test_split.mat','ChaLearn_train_test_split.mat');
    end
    load('ChaLearn_train_test_split.mat');    
    if exist('scaledExamples','dir') == 7 && numel(dir(sprintf('scaledExamples/*.mat'))) == 13883
        fprintf('Dataset exists..\n');
    else
        fprintf('Start downloading dataset..\n');
        urlwrite('http://users.cecs.anu.edu.au/~basura/data/scaledExamples.tar.gz','scaledExamples.tar.gz');
        system('tar -zxvf scaledExamples.tar.gz');
    end
    videoname = fnames;	
    feats = {'scaledExamples'};   
    for f = 1 : numel(feats)
        file = sprintf('%s.mat',feats{f});
        if exist(file,'file') ~= 2
            [VideoDarwinFeats,MaxPooledFeats,MeanPooledFeats] = getVideoDarwin(feats{f},videoname);
            save(file,'VideoDarwinFeats','MaxPooledFeats','MeanPooledFeats');
        else
            load(file);
        end
        ALL_Data_cell{f} = VideoDarwinFeats;  
    end    
    Options.KERN = 0;    % non linear kernel
    Options.Norm =2;     % L2 normalization

	if Options.KERN == 5        
        for ch = 1 : size(ALL_Data_cell,2)                
            x = vl_homkermap(ALL_Data_cell{ch}', 2, 'kchi2') ;  
            ALL_Data_cell{ch} = x';
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
    
    classid = labels2;  
    trn_indx = [cur_train_indx]; % [cur_train_indx  cur_val_indx]; 
    test_indx = [cur_val_indx];  % cur_test_indx     
    TrainClass_ALL = classid(trn_indx,:);
    TestClass_ALL = classid(test_indx,:);   
   [~,TrainClass] = max(TrainClass_ALL,[],2);
   [~,TestClass] = max(TestClass_ALL,[],2);   		
      
    for ch = 1 : size(ALL_Data_cell,2)        
        ALL_Data = ALL_Data_cell{ch};
        TrainData = ALL_Data(trn_indx,:);        
        TestData = ALL_Data(test_indx,:);

        TrainData_Kern_cell{ch} = [TrainData * TrainData'];    
        TestData_Kern_cell{ch} = [TestData * TrainData'];                        
        clear TrainData; clear TestData; clear ALL_Data;            
    end
    
    for wi = 1 : size(weights,1)
        TrainData_Kern = zeros(size(TrainData_Kern_cell{1}));
        TestData_Kern = zeros(size(TestData_Kern_cell{1}));
            for ch = 1 : size(ALL_Data_cell,2)     
                TrainData_Kern = TrainData_Kern + weights(wi,ch) * TrainData_Kern_cell{ch};
                TestData_Kern = TestData_Kern + weights(wi,ch) * TestData_Kern_cell{ch};
            end
            [precision(wi,:),recall(wi,:),acc(wi) ] = train_and_classify(TrainData_Kern,TestData_Kern,TrainClass,TestClass);       
    end          
            
    [~,indx] = max(acc);            
    precision = precision(indx,:);
    recall = recall(indx,:); 
    F = 2*(precision .* recall)./(precision+recall);
    fprintf('Mean F score = %1.2f\n',mean(F));
    save(sprintf('results.mat'),'precision','recall','F');
        
    
end


function W = genRepresentation(data,CVAL)
    Data =  zeros(size(data,1)-1,size(data,2));
    for j = 2 : size(data,1)                
        Data(j-1,:) = mean(data(1:j,:));
    end                            
    Data = vl_homkermap(Data',2,'kchi2');
    Data = Data';

    W_fow = liblinearsvr(Data,CVAL,2); 			
    order = 1:size(data,1);
    [~,order] = sort(order,'descend');
    data = data(order,:);
    Data =  zeros(size(data,1)-1,size(data,2));
    for j = 2 : size(data,1)                
        Data(j-1,:) = mean(data(1:j,:));
    end            
    Data = vl_homkermap(Data',2,'kchi2');
    Data = Data';            
    W_rev = liblinearsvr(Data,CVAL,2); 			              
    W = [W_fow ; W_rev];  


end

function [ALL_Data,MAX_Data,MEAN_Data] = getVideoDarwin(featType,Videos)    
    CVAL = 1; % C value for the ranking function or SVR    
	TOTAL = size(Videos,2);  
    for i = 1:TOTAL
        name = Videos{i};         
        MATFILE = fullfile(featType,sprintf('%s.mat',name));        
        load(MATFILE);
        data  = clustDist';  clear clustDist;
        W = genRepresentation(data,CVAL); 
        maxPooled = max(data);            
        meanPooled = mean(data);
        if i == 1
             ALL_Data =  zeros(TOTAL,size(W,1)) ;          
             MAX_Data =  zeros(TOTAL,size(maxPooled,2)) ;
             MEAN_Data =  zeros(TOTAL,size(meanPooled,2)) ;
        end
        if mod(i,100) == 0
            fprintf('.')
        end
        ALL_Data(i,:) = W';
        MAX_Data(i,:) = maxPooled';
        MEAN_Data(i,:) = meanPooled';
    end
    fprintf('Complete...\n')
end

function X = normalizeL2(X)
	for i = 1 : size(X,1)
		if norm(X(i,:)) ~= 0
			X(i,:) = X(i,:) ./ norm(X(i,:));
		end
    end	   
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
    
    N = size(Data,1);
    Labels = [1:N]';
    model = train(double(Labels), sparse(double(Data)),sprintf('-c %d -s 11 -q',C) );
    w = model.w';
end

function [precision,recall,acc ] = train_and_classify(TrainData_Kern,TestData_Kern,TrainClass,TestClass)
         nTrain = 1 : size(TrainData_Kern,1);
         TrainData_Kern = [nTrain' TrainData_Kern];         
         nTest = 1 : size(TestData_Kern,1);
         TestData_Kern = [nTest' TestData_Kern];         
         C = [1 10 100 500 1000 ];
         for ci = 1 : numel(C)
             model(ci) = svmtrain(TrainClass, TrainData_Kern, sprintf('-t 4 -c %1.6f -v 2 -q ',C(ci)));               
         end        
         
         [~,max_indx]=max(model);
         
         C = C(max_indx);
         
         for ci = 1 : numel(C)
             model = svmtrain(TrainClass, TrainData_Kern, sprintf('-t 4 -c %1.6f  -q ',C(ci)));
             [predicted, acc, scores{ci}] = svmpredict(TestClass, TestData_Kern ,model);	                 
             [precision(ci,:) , recall(ci,:)] = perclass_precision_recall(TestClass,predicted);
             accuracy(ci) = acc(1,1);
         end        
         
        [acc,cindx] = max(accuracy);   
        scores = scores{cindx};
        precision = precision(cindx,:);
        recall = recall(cindx,:);
end

function [precision , recall] = perclass_precision_recall(label,predicted)

    
    
    
    for cl = 1 : 20
        true_pos = sum((predicted == cl) .* (label == cl));
        false_pos = sum((predicted == cl) .* (label ~= cl));
        false_neg = sum((predicted ~= cl) .* (label == cl));
        precision(cl) = true_pos / (true_pos + false_pos);
        recall(cl) = true_pos / (true_pos + false_neg);
        
    end


end
