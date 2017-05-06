% % %%%%%%%%%%%%20150922%%%%%%%%%%%%%
% %%%%%%%%%%%%BY yz%%%%%%%%%%%%%%%%
% %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
%  trans the original "name_class_.eca" to txt
%  save the one of four channel(II,aVL,V5,V6)as "nameab_class_channel.txt"
%  adjust the start time to the real zero point and save as "nameab_class_channel_zero.txt"
%  cut the "name_class_channel.txt" into 24 pieces and the time is real and save as "nameab_class_chanenl_xx_00_xx_59.txt"
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_night.txt":23:00-04:59
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_day1.txt":record start-22:59
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_day2.txt":05:00-record end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input the need parameters
clc
clear
name = input('Input the original patient name','s') ;
name_qp = input('Input the quanpin of name','s') ;
class = input('Input the class','s') ;
channel = input('Input the channel,II,aVL,V5,V6,','s') ;
%Input the initial time 
hou = input('Type in the initial hour = ');
min = input('Type in the initial minute = ');
sec = input('Type in the initial second = ');


% load original data ".eca"
f=fopen([num2str(name),'_',num2str(class),'.eca']);
[Array_2D,num]=fread(f,'short');
b=reshape(Array_2D,[12 length(Array_2D)/12])';
x1=b(:,1);
x2=b(:,2);
x3=b(:,3);
x4=b(:,4);
x5=b(:,5);
x6=b(:,6);                                                                                                                                                                                                                       
x7=b(:,7);
x8=b(:,8);
x9=b(:,9);
x10=b(:,10);
x11=b(:,11);                                       
x12=b(:,12);

% save as name_class_channel.txt
X=[];
switch channel
    case 'II'
        X=x2;
    case 'aVL'
        X=x4;
    case 'V5'
        X=x11;
    case 'V6'
        X=x12;
    otherwise 
        disp('error');
end
fid = fopen([num2str(name_qp),'_',num2str(class),'_',num2str(channel),'.txt'],'w');
fprintf(fid,'%g\n',X);      % # \n 换行
fclose(fid);


%%fixed parameter
F=500;  %sample frequency
s_min=F*60;     %num of a min
s_hou=F*3600;      %num of a hour
l=size(X);       %length of X
l=l(1);
total_hou=l/s_hou;
total_hou=ceil(total_hou);     %total hour


r_sec=60-sec;
r_min=59-min;
r_hou=23-hou;
r_time=60*r_min+r_sec;            %actual start to the first integral o'clock,initial part
r_size=F*r_time;
l_size=l-s_hou*23-r_size;         %length of last part
l_last=l_size+r_size;             %length of initial part and last part
z_time=3600*r_hou+60*r_min+r_sec;         %actual start to the zero point o'clock
z_size=F*z_time;

% %adjust the start time to the real zero point and save as "nameqp_class_channel_zero.txt"
% aa=zeros(l,1);
% b_temp=zeros(z_size,1);
% c_temp=zeros((l-z_size),1);
% b_temp=X(1:z_size,1);       %%%%
% c_temp=X((z_size+1):l,1);   %%%%
% aa(1:(l-z_size),1)=c_temp;
% aa((l-z_size+1):l,1)=b_temp;
% 
% fid = fopen([num2str(name_qp),'_',num2str(class),'_',num2str(channel),'_zero.txt'],'w');
% fprintf(fid,'%g\n',aa);      % # \n 换行
% fclose(fid);

 
% segment and save as x:00:00-x:59:59.txt
i=0;j=0;
temp=zeros(s_hou,24); 
med_size=l-r_size;
med_hou=ceil(med_size/s_hou);            %remove the initial part and calculate the hours left
%%%%%% %temp1=zeros(l_last,1);
for i=1:(med_hou-1)
    j=rem((hou+i),24);
    temp(:,i)=X((r_size+1+s_hou*(i-1)):(r_size+s_hou*i),1);
end
if med_hou==24 && l_size>0
    temp(1:l_size,total_hou)=X((l-l_size+1):l,1);
    temp((s_hou-r_size+1):s_hou,total_hou)=X(1:r_size,1);
else if l_size<=0
    temp(1:(l-r_size-s_hou*i),med_hou)=X((r_size+s_hou*i+1):l,1);
    temp(1:r_size,24)=X(1:r_size,1);
    else
        disp('error');
    end
end


%save data per hour and note the actual time corresponding, save as nameab_class_channel_xx_00_xx_59.txt
pp=0;
for i=1:(total_hou-1)
 pp= rem((hou+i),24);
 fid = fopen([num2str(name_qp),'_',num2str(class),'_1h_',num2str(channel),'_',num2str(pp),'_00_',num2str(pp),'_59.txt'],'w');
 fprintf(fid,'%g\n',temp(:,i));      % # \n 换行
 fclose(fid);
end
 fid = fopen([num2str(name_qp),'_',num2str(class),'_1h_',num2str(channel),'_',num2str(hou),'_XX_',num2str(hou),'_YY.txt'],'w');
 fprintf(fid,'%g\n',temp(:,24));      % # \n 换行
 fclose(fid);
 
%  %save 23:00-04:59 as  "nameab_class_chanenl_night.txt":23:00-04:59
%  ni_sta_hou=23-hou;
%  ni_end_hou=ni_sta_hou+5;
%  night=zeros(s_hou*6,1);
%  night1=[];
%  night1=temp(:,ni_sta_hou:ni_end_hou);
%  for i=1:6
%      night((s_hou*(i-1)+1):(s_hou*i),1)=night1(:,i);
%  end
%  fid = fopen([num2str(name_ab),'_',num2str(class),'_',num2str(channel),'_night.txt'],'w');
%  fprintf(fid,'%g\n',night);      % # \n 换行
%  fclose(fid);
%  
%  %save as "nameab_class_chanenl_day1.txt":record start-22:59
%  day1=[];
%  day1_hou=22-hou;              %intergral hours   %
%  day1_size=r_size+day1_hou*s_hou; 
%  day1=X(1:day1_size,1);
%  fid = fopen([num2str(name_ab),'_',num2str(class),'_',num2str(channel),'_day1.txt'],'w');
%  fprintf(fid,'%g\n',day1);      % # \n 换行
%  fclose(fid);
%  
%  %save as "nameab_class_chanenl_day2.txt":05:00-end record
%  day2=[];
%  day2_str_size=day1_size+6*s_hou+1;
%  day2=X(day2_str_size:l,1);
%  fid = fopen([num2str(name_ab),'_',num2str(class),'_',num2str(channel),'_day2.txt'],'w');
%  fprintf(fid,'%g\n',day2);      % # \n 换行
%  fclose(fid);
 
 














