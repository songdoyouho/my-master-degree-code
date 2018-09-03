function [TrajAc,EE,outindex,TrajOut,TrajIn,TrajOutLow,TrajOutE] =  MotionDecomp0(Traj,FACTOR) %TrajAc,perc,inindS,
% addpath ([pwd '\RASL_toolbox\']);

% 重新排列成paper的格式
chunksz = size(Traj,2)/2;
Xs = Traj(:,1:chunksz)';
Ys = Traj(:,chunksz+1:end)';
perc = length( find((std(Xs) + std(Ys))<4) )/length(Xs);
X = zeros(2.*size(Xs,1),size(Xs,2));
for i=1:size(Xs,1);
    u1 = Xs(i,:);
    v1 = Ys(i,:);
    X(2*i-1:2*i,:) = [u1(:)'; v1(:)'];
end

% FACTOR = .1;%.05;%.1%1;   lambda決定output數量
% lambda = 0.1*1.1/sqrt(size(X,1));

lambda = FACTOR*1.1/sqrt(size(X,1));
tol = 1.0000e-006;
maxIter = 1000;
[A, E, numIter] = rasl_inner_ialm_noT(X, lambda, tol, maxIter); 
% X = paper 中的 M，他們有在裡面做normalize，而且還有兩個!
EE = sum(E.^2);
% 改大於零的看看
outindS = find(EE > 0);
count = 1 : size(EE,2);
[outindex www] = ismember(count,outindS);
inindS = find(EE <= 0);

% 改區間
% index1 = EE > max(EE)./900;
% index2 = EE > max(EE)./1000;
% index3 = index1 + index2;
% outindS = index3 == 1;
% inindS = outindS == 0;
% count = 1 : size(EE,2);
% [outindex www] = ismember(count,outindS);

% outindS = find(EE > max(EE)./thr);% find(EE > max(EE)./650); 
% inindS = find(EE <= max(EE)./thr);% find(EE <= max(EE)./650);


% [U,S,V] = svd(A);
[U,S,V] = svd(A,'econ');
S2 = 0.*S;
S2(1,1) = S(1,1);
S2(2,2) = S(2,2);
S2(3,3) = S(3,3);
%S2(4,4) = S(4,4);
A2 = U*S2*V'; % Ac camera motion component


XsoS = Xs(:,outindS);
YsoS = Ys(:,outindS);
XsiS = Xs(:,inindS);
YsiS = Ys(:,inindS);
if perc < .5 % moving camera
    XoLow = A(:,outindS);
    %XoE = E(:,outindS);
    
    XoE = E(:,outindS) + A(:,outindS) - A2(:,outindS); % Et
	
	Ac = A2; % Ac
	
	XAc = Ac(1:2:end,:);
    YAc = Ac(2:2:end,:);
    
    XsoSLow = XoLow(1:2:end,:);
    YsoSLow = XoLow(2:2:end,:);
    XsoSE = XoE(1:2:end,:) + repmat(XsoSLow(1,:),[size(XsoSLow,1) 1]) ;
    YsoSE = XoE(2:2:end,:) + repmat(YsoSLow(1,:),[size(YsoSLow,1) 1]) ;
else
    XoLow = X(:,outindS);
    XoE = XoLow;
    
    Ac = A2; % Ac
	
	XAc = Ac(1:2:end,:);
    YAc = Ac(2:2:end,:);
    
    XsoSLow = XoLow(1:2:end,:);
    YsoSLow = XoLow(2:2:end,:);
    XsoSE = XsoSLow;
    YsoSE = YsoSLow;
end

% Final Result
TrajOut = [XsoS;YsoS]';  % original out
TrajIn = [XsiS;YsiS]';  % original in
TrajOutLow = [XsoSLow;YsoSLow]';  % A ,global camera flow
TrajOutE = [XsoSE;YsoSE]';  % Et ,object flow
TrajAc = [XAc; YAc]'; % Ac

