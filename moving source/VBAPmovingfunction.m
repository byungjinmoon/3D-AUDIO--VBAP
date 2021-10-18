function output = VBAPmovingfunction(input, start,finish,interval)

load('large_pinna_frontal.mat');

framenumber=0;
%30 degree
y_left=conv(input,left(:,91));
y_right=conv(input,right(:,91));
y_30=[y_left, y_right];
%-30 degree
 y_left=conv(input,left(:,8));
y_right=conv(input,right(:,8));
y_m30=[y_left, y_right];
%-90 degree
 y_left=conv(input,left(:,25));
y_right=conv(input,right(:,25));
y_m90=[y_left, y_right];
%-150 degree
y_left=conv(input,left(:,42));
y_right=conv(input,right(:,42));
y_m150=[y_left, y_right];
%150 degree
y_left=conv(input,left(:,58));
y_right=conv(input,right(:,58));
y_150=[y_left, y_right];

%90 degree
y_left=conv(input,left(:,75));
y_right=conv(input,right(:,75));
y_90=[y_left, y_right];

y_speakers=[y_30 y_m30 y_m90 y_m150 y_150 y_90];

frame=round(length(input)/360);
for pan_dir=start:interval:finish-1
    
%virtual source 
% pan_dir=0;
ls_dirs=[30 -30 -90 -150 150 90];
ls_num = length(ls_dirs);
ls_dirs=[ls_dirs ls_dirs(1)]/180*pi;
panvec=[cos(pan_dir/180*pi) sin(pan_dir/180*pi)];

    
for i=1:ls_num
    lsmat=inv([[cos(ls_dirs(i)) sin(ls_dirs(i))];...
    [cos(ls_dirs(i+1)) sin(ls_dirs(i+1))]]);
    
    tempg=panvec*lsmat;
    if min(tempg)> -0.001
        g=zeros(1, ls_num);
        g([i mod(i,ls_num)+1])=tempg;
        gains=g/sqrt(sum(g.^2));
      break
    end
end


k=find(gains);
if length(k)==1
  y_1=y_speakers(:,k(1)*2-1:k(1)*2)*gains(k(1));
  moving_y_1(frame*framenumber+1:frame*(framenumber+1),1)=y_1(frame*framenumber+1:frame*(framenumber+1),1);
  moving_y_1(frame*framenumber+1:frame*(framenumber+1),2)=y_1(frame*framenumber+1:frame*(framenumber+1),2);

else 
y_1=y_speakers(:,k(1)*2-1:k(1)*2)*gains(k(1));
y_2=y_speakers(:,k(2)*2-1:k(2)*2)*gains(k(2));
moving_y_1(frame*framenumber+1:frame*(framenumber+1),1)=y_1(frame*framenumber+1:frame*(framenumber+1),1);
moving_y_1(frame*framenumber+1:frame*(framenumber+1),2)=y_1(frame*framenumber+1:frame*(framenumber+1),2);
moving_y_2(frame*framenumber+1:frame*(framenumber+1),1)=y_2(frame*framenumber+1:frame*(framenumber+1),1);
moving_y_2(frame*framenumber+1:frame*(framenumber+1),2)=y_2(frame*framenumber+1:frame*(framenumber+1),2);

end
framenumber=framenumber+1;
end
output=moving_y_1+moving_y_2;
