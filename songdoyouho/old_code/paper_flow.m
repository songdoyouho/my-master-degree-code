mov = VideoReader('C:\\Users\diesel\Desktop\small123.avi');
endframe = mov.NumberOfFrames;
% load u , v
load('C:\\Users\diesel\Desktop\123UUU.mat');
load('C:\\Users\diesel\Desktop\123VVV.mat');
um = nan2zeros(UUU(:,:,1));
vm = nan2zeros(VVV(:,:,1));

xmesh = zeros(mov.Height,mov.Width);
ymesh = zeros(mov.Height,mov.Width);
for iii = 1 : mov.width
    for jjj = 1 : mov.height
        xmesh(jjj,iii) = iii;
        ymesh(jjj,iii) = jjj;
    end
end

t_length = endframe - 1 + 1;

u = um;
v = vm;

for t_integration = 1 : t_length   
    if t_integration == 1
        
        xflowmap{t_integration} = xmesh;
        
        yflowmap{t_integration} = ymesh;
        
    else
        um =  nan2zeros(UUU(:,:,t_integration));
        vm =  nan2zeros(VVV(:,:,t_integration));
        
%         um = medfilt2(um,[3 3]);
%         vm = medfilt2(vm,[3 3]);
        
        counter = counter + 1;

        u = um;
        v = vm;
        
        xflowmap{t_integration} = xflowmap{t_integration-1} + interp2(xmesh, ymesh, u , xflowmap{t_integration-1}, yflowmap{t_integration-1}, 'linear', 0);
        
        yflowmap{t_integration} = yflowmap{t_integration-1} + interp2(xmesh, ymesh, v , xflowmap{t_integration-1}, yflowmap{t_integration-1}, 'linear', 0);
        
    end
end

xxx = [];
yyy = [];
% plot flow
for iii = 1 : endframe - 1
    % 把座標點串起來
    tmpx = reshape(xflowmap{1,iii},size(u,1)*size(u,2),1);
    tmpy = reshape(yflowmap{1,iii},size(v,1)*size(v,2),1);
    xxx = [xxx tmpx];
    yyy = [yyy tmpy];
end

Traj = [xxx yyy];
[TrajAc,outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,0.08);

outputvideo = VideoWriter('C:\\Users\diesel\Desktop\123test1.avi');
outputvideo.FrameRate = 5;
open(outputvideo);
endframe = mov.NumberOfFrames;
for k = 1 : endframe - 2
    thisframe = read(mov,k);
    figure(2)
    imshow(thisframe,'border','tight');
    figure(3)
    imshow(thisframe,'border','tight');
    figure(2)
    line_x = TrajOut(:,1 : k + 1);
    line_y = TrajOut(:,size(TrajOut,2)/2+1 : size(TrajOut,2)/2 + k + 1);
    line(line_x',line_y','Color','blue');

    image1 = getframe(gcf);
    clf
    figure(3)
    line_x = xxx(1:100:end,1:k+1);
    line_y = yyy(1:100:end,1:k+1);
    line(line_x',line_y','Color','blue');    
 
    image3 = getframe(gcf);
    image = cat(2,image3.cdata,image1.cdata);
    writeVideo(outputvideo,image);
    clf
end
close(outputvideo);