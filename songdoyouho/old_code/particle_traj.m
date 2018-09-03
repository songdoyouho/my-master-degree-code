mov = VideoReader('C:\\Users\\diesel\\Desktop\\kick.avi');
numframe = mov.NumberOfFrames;
width = mov.Width;
height = mov.Height;
framerate = mov.FrameRate;

for k = 1 : numframe - 1
    if k == 1
        thisframe = read(mov,k);
        nextframe = read(mov,k+1);
        k
        imshow(thisframe);
        hold on 
%         [x, y, u, v, im] = optic_flow_brox(thisframe,nextframe,10,100.0,3,1,0);
%         save('C:\\Users\\diesel\\Desktop\\tmp\\optical1.mat','x','y','u','v','im');
        load('C:\\Users\\diesel\\Desktop\\tmp\\optical1.mat','x','y','u','v','im');
        quiver(x(1:10:576,1:10:720),y(1:10:576,1:10:720),u(1:10:576,1:10:720),v(1:10:576,1:10:720));
        um = nan2zeros(u);
        vm = nan2zeros(v);
        counter = 1;
        pause(0.1)
    else
        thisframe = read(mov,k);
        nextframe = read(mov,k+1);
        k
        imshow(thisframe);
        hold on 
%         [x, y, u, v, im] = optic_flow_brox(thisframe,nextframe,10,100.0,3,1,0);
%         save(sprintf('C:\\Users\\diesel\\Desktop\\tmp\\optical%d.mat',k),'x','y','u','v','im');
        load(sprintf('C:\\Users\\diesel\\Desktop\\tmp\\optical%d.mat',k),'x','y','u','v','im');
        quiver(x(1:10:576,1:10:720),y(1:10:576,1:10:720),u(1:10:576,1:10:720),v(1:10:576,1:10:720));
        um = um + nan2zeros(u);
        vm = vm + nan2zeros(v);
        counter = counter + 1;
        pause(0.1)
    end
end

um = um ./ counter;
vm = vm ./ counter;
x1 = min(x(:));
x2 = max(x(:));
y1 = min(y(:));
y2 = max(y(:));

xmesh = x;
ymesh = y;
dt = 1 / framerate; % ftle_options.step_size
frame_rate = framerate;
t_length = numframe;
u = um;
v = vm;

for t_integration = 1 : t_length - 1;
    index = 1 + t_integration - 1;
%     if ftle_options.directional_segmentation == true
%         [u, v] = normalize_magnitude(u,v);
%         u = nan2zeros(u);
%         v = nan2zeros(v);
%     end 
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%Advection%%%%%%%%%%
    if t_integration == 1
        xflowmap{t_integration} = xmesh;
        yflowmap{t_integration} = ymesh;
    else
        xflowmap{t_integration} = xflowmap{t_integration-1} + dt*interp2(xmesh, ymesh, u, xflowmap{t_integration-1}, yflowmap{t_integration-1}, 'linear', 0);
        yflowmap{t_integration} = yflowmap{t_integration-1} + dt*interp2(xmesh, ymesh, v, xflowmap{t_integration-1}, yflowmap{t_integration-1}, 'linear', 0);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%
end

save('xflowmap.mat','xflowmap');
save('yflowmap.mat','yflowmap');
% load('xflowmap.mat');
% load('yflowmap.mat');
xxx = [];
yyy = [];
for k = 1:size(xflowmap,2)
    tmp_xflowmap = xflowmap{1,k};
    tmp = reshape(tmp_xflowmap,[size(tmp_xflowmap,1)*size(tmp_xflowmap,2) 1]);
    xxx = [xxx tmp];
    tmp_yflowmap = yflowmap{1,k};
    tmp = reshape(tmp_yflowmap,[size(tmp_yflowmap,1)*size(tmp_yflowmap,2) 1]);
    yyy = [yyy tmp];
end

for k = 2 : numframe
    thisframe = read(mov,k);
    imshow(thisframe);
    hold on 
    plot(xxx(1:500:414720,1:k-1)',yyy(1:500:414720,1:k-1)');
    pause(0.1)
end















