% LICENSE & TERMS OF USE
% ----------------------
% VideoDarwin code implements a sequence representation technique.
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
% Inputs
% ------
% data   : row vector data matrix of the sequence
% CVAL   : C value [set to 1]
%
% Output
% ------
%
% W : Sequence representation
%
% Instructions
% ------------
% 
% Dependency : liblinear
%
% Version      : 1.0
% Release date : 2015/09/20
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
function W = VideoDarwin(data,CVAL)
    if nargin < 2
	CVAL = 1;
    end	
    OneToN = [1:size(data,1)]';    
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_fow = liblinearsvr(getNonLinearity(Data),CVAL,2); clear Data; 
	
    order = 1:size(data,1);
    [~,order] = sort(order,'descend');
    data = data(order,:);
    Data = cumsum(data);
    Data = Data ./ repmat(OneToN,1,size(Data,2));
    W_rev = liblinearsvr(getNonLinearity(Data),CVAL,2); 			              
    W = [W_fow ; W_rev]; 
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
    model = train(double(Labels), sparse(double(Data)),sprintf('-c %1.6f -s 11 -q',C) );
    w = model.w';    
end

function Data = getNonLinearity(Data)
    Data = sign(Data).*sqrt(abs(Data));    
    %Data = vl_homkermap(Data',2,'kchi2');    
end

function x = normalizeL2(x)
    x=x./repmat(sqrt(sum(x.*conj(x),2)),1,size(x,2));
end
