path='D:\jpl';
modelpath='D:\jpl\model';

load('D:\jpl\model\timevarymean18.mat')
load('D:\jpl\model\W218.mat')
WWW=W2(1,1:109056);
score=timevarymean*WWW';

%% ºâ±×²v
% allrate=[];
% for i=1:size(score,1)-1
%     rate=score(i+1,1)-score(i,1);
%     allrate=[allrate; rate];
% end
fiverate=[];
for j=1:fix(size(score,1)/5)
    rate=(score(j*5,1)-score(j*5-4,1))/5;
    fiverate=[fiverate; rate];    
end

ttt=0;
keyt=[];
for k=1:size(fiverate,1)-1
    ttt=ttt+5;
    if abs(fiverate(k+1,1)-fiverate(k,1))>=0.2
        keyt=[keyt; ttt];
    end
end

keyt=keyt+72;

t=1:size(score,1);
t=t';
figure(1);
plot(t,score);

hold on;
figure(2);
 mov = VideoReader('D:\jpl\c18.avi');
 numberOfFrames = mov.NumberOfFrames;
for frame=1:numberOfFrames
    thisframe=read(mov, frame);
    figure(2);
    imshow(thisframe);
    figure(1);
%     if frame-72>=1
%         plot(t(frame-72,1),score(frame-72,1),'r+');
%         hold on;
%     end
    aaa=intersect(frame,keyt);
    if isempty(aaa)==0;
        plot(t(frame-72,1),score(frame-72,1),'b+');
        hold on;
        imwrite(thisframe,sprintf('%s\\%d.jpg',modelpath,frame));
        %figure;
        %imshow(thisframe);
    else
        pause(0.1);
    end    
end

% for j=1:fix(size(score,1)/5)
%     plot(j*5-4,score(j*5-4,1));  
% end

% featurenum=fix(256000/57);
% numclusters=256;
% XXX=[];
% for i=1:57
%     load(sprintf('%s\\feature%d.mat',path,i));
%     fprintf('%s\\feature%d.mat\n',path,i);
%     % select feature for training GMM
%     if size(X,1)<featurenum
%         XXX=[XXX; X];
%     else
%         idid=randperm(size(X,1),featurenum);
%         X_idx = 1:size(X,1);
%         idx = ismember(X_idx,idid);
%         idx=idx';
%         X = X(idx,:);
%         XXX=[XXX; X];
%     end
% end
%
% X1=XXX(:,2:31);
% X2=XXX(:,32:127);
% X3=XXX(:,128:235);
% X4=XXX(:,236:331);
% X5=XXX(:,332:427);
% % pca for each features
% [coeff1, score1, latent1, tsquare1] = princomp(X1);
% newcoeff1=coeff1(:,1:size(X1,2)/2);
% pcaX1=X1*newcoeff1;
% [coeff2, score2, latent2, tsquare2] = princomp(X2);
% newcoeff2=coeff2(:,1:size(X2,2)/2);
% pcaX2=X2*newcoeff2;
% [coeff3, score3, latent3, tsquare3] = princomp(X3);
% newcoeff3=coeff3(:,1:size(X3,2)/2);
% pcaX3=X3*newcoeff3;
% [coeff4, score4, latent4, tsquare4] = princomp(X4);
% newcoeff4=coeff4(:,1:size(X4,2)/2);
% pcaX4=X4*newcoeff4;
% [coeff5, score5, latent5, tsquare5] = princomp(X5);
% newcoeff5=coeff5(:,1:size(X5,2)/2);
% pcaX5=X5*newcoeff5;
%
% save(sprintf('%s\\coeff1.mat',modelpath),'newcoeff1');
% save(sprintf('%s\\coeff2.mat',modelpath),'newcoeff2');
% save(sprintf('%s\\coeff3.mat',modelpath),'newcoeff3');
% save(sprintf('%s\\coeff4.mat',modelpath),'newcoeff4');
% save(sprintf('%s\\coeff5.mat',modelpath),'newcoeff5');
%
% % train GMM model
% [means, covariances, priors] = vl_gmm(pcaX1',numclusters);
% model1.means=means;
% model1.covariances=covariances;
% model1.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX2',numclusters);
% model2.means=means;
% model2.covariances=covariances;
% model2.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX3',numclusters);
% model3.means=means;
% model3.covariances=covariances;
% model3.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX4',numclusters);
% model4.means=means;
% model4.covariances=covariances;
% model4.priors=priors;
% [means, covariances, priors] = vl_gmm(pcaX5',numclusters);
% model5.means=means;
% model5.covariances=covariances;
% model5.priors=priors;
%
% %save GMM model
% save(sprintf('%s\\model1.mat',modelpath),'model1');
% save(sprintf('%s\\model2.mat',modelpath),'model2');
% save(sprintf('%s\\model3.mat',modelpath),'model3');
% save(sprintf('%s\\model4.mat',modelpath),'model4');
% save(sprintf('%s\\model5.mat',modelpath),'model5');

% load(sprintf('%s\\coeff1.mat',modelpath),'newcoeff1');
% load(sprintf('%s\\coeff2.mat',modelpath),'newcoeff2');
% load(sprintf('%s\\coeff3.mat',modelpath),'newcoeff3');
% load(sprintf('%s\\coeff4.mat',modelpath),'newcoeff4');
% load(sprintf('%s\\coeff5.mat',modelpath),'newcoeff5');
% load(sprintf('%s\\model1.mat',modelpath),'model1');
% load(sprintf('%s\\model2.mat',modelpath),'model2');
% load(sprintf('%s\\model3.mat',modelpath),'model3');
% load(sprintf('%s\\model4.mat',modelpath),'model4');
% load(sprintf('%s\\model5.mat',modelpath),'model5');
% 
% % for i=1:57
%     load(sprintf('%s\\feature30.mat',path));
%     fprintf('%s\\feature30.mat\n',path);
%     startframe=X(1,1);
%     endframe=X(size(X,1),1);
%     allencoding=[];
%     timevarymean=[];
%     for k=1:endframe
%         % take this frame's feature out
%         index=X(:,1)==k;
%         tmpX=X(index,:);
%         check=isempty(tmpX);
%         if check~=1
%             X1=tmpX(:,2:31);
%             X2=tmpX(:,32:127);
%             X3=tmpX(:,128:235);
%             X4=tmpX(:,236:331);
%             X5=tmpX(:,332:427);
%             % PCA
%             pcaX1=X1*newcoeff1;
%             pcaX2=X2*newcoeff2;
%             pcaX3=X3*newcoeff3;
%             pcaX4=X4*newcoeff4;
%             pcaX5=X5*newcoeff5;
%             % encoding fisher vector and normalize
%             E=[];
%             tmpE = vl_fisher(pcaX1', model1.means, model1.covariances, model1.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX2', model2.means, model2.covariances, model2.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX3', model3.means, model3.covariances, model3.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX4', model4.means, model4.covariances, model4.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             tmpE = vl_fisher(pcaX5', model5.means, model5.covariances, model5.priors);
%             sss=sign(tmpE(:,1));
%             tmpE=sss.*sqrt(abs(tmpE(:,1)));
%             tmpE=tmpE/norm(tmpE);
%             E=[E tmpE'];
%             
%             allencoding = [allencoding; E];
%             mean = sum(allencoding,1) / size(allencoding,1);
%             timevarymean = [timevarymean; mean];
%         end
%     end
%     save(sprintf('%s\\allencoding30.mat',modelpath),'allencoding');
%     save(sprintf('%s\\timevarymean30.mat',modelpath),'timevarymean');
%     W1 = VideoDarwin(allencoding);
%     W1 = W1';
%     save(sprintf('%s\\W130.mat',modelpath),'W1');
%     W2 = VideoDarwin(timevarymean);
%     W2 = W2';
%     save(sprintf('%s\\W230.mat',modelpath),'W2');
% end
