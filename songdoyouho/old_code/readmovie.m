function [  ] = readmovie( filename )
%READMOVIE Summary of this function goes here
%   Detailed explanation goes here
mov = VideoReader(filename);
numberOfFrames = mov.NumberOfFrames;
width=mov.Width;
height=mov.Height;
snippet=zeros(height,width,numberOfFrames);
for frame = 1 : numberOfFrames    
    thisFrame = read(mov, frame);
    %imshow(thisFrame);
%     thisFrame=rgb2gray(thisFrame);
    imwrite(thisFrame,sprintf('C:\\Users\\diesel\\Desktop\\images\\%d.jpg',frame),'jpg');
%     snippet(:,:,frame)=thisFrame;
end
%close Figure 1;
end

