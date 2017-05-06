function []=trans2perhour(filename,pathname,name,name_qp,class,channel,hou,min,sec,F)

%  trans the original "name_class_.eca" to txt
%  f�Ƕ�ȡ��׺Ϊ.eca���ļ���nameΪ����������name_qpΪ����������ȫƴ��FΪ������
%  save the one of four channel(II,aVL,V5,V6)as "nameab_class_channel.txt"
%  adjust the start time to the real zero point and save as "nameab_class_channel_zero.txt"
%  cut the "name_class_channel.txt" into 24 pieces and the time is real and save as "nameab_class_chanenl_xx_00_xx_59.txt"
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_night.txt":23:00-04:59
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_day1.txt":record start-22:59
%  cut the "name_class_channel.txt" and save as "nameab_class_chanenl_day2.txt":05:00-record end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load original data ".eca"
jindu = waitbar(0,'progress','Name','changing file...');
f=fopen(filename);
[Array_2D,num]=fread(f,'short');
b=reshape(Array_2D,[12 length(Array_2D)/12])';    %��Array_2D���ó�12��length(Array_2D)/12�еľ���
x1=b(:,1);
waitbar(0.05,jindu,['����ת������' num2str(5) '%']);
x2=b(:,2);
waitbar(0.1,jindu,['����ת������' num2str(10) '%']);
x3=b(:,3);
waitbar(0.15,jindu,['����ת������' num2str(15) '%']);
x4=b(:,4);
waitbar(0.20,jindu,['����ת������' num2str(20) '%']);
x5=b(:,5);
waitbar(0.25,jindu,['����ת������' num2str(25) '%']);
x6=b(:,6);
waitbar(0.3,jindu,['����ת������' num2str(30) '%']);
x7=b(:,7);
waitbar(0.35,jindu,['����ת������' num2str(35) '%']);
x8=b(:,8);
waitbar(0.4,jindu,['����ת������' num2str(40) '%']);
x9=b(:,9);
waitbar(0.45,jindu,['����ת������' num2str(45) '%']);
x10=b(:,10);
waitbar(0.5,jindu,['����ת������' num2str(50) '%']);
x11=b(:,11); 
waitbar(0.55,jindu,['����ת������' num2str(55) '%']);
x12=b(:,12);
waitbar(0.6,jindu,['����ת������' num2str(60) '%']);
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
fid = fopen([pathname,num2str(name_qp),'_',num2str(class),'_',num2str(channel),'.txt'],'w');
fprintf(fid,'%g\n',X);      % # \n ����
fclose(fid);
waitbar(0.7,jindu,['����ת������' num2str(70) '%']);
%%fixed parameter
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
% fprintf(fid,'%g\n',aa);      % # \n ����
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
waitbar(0.75,jindu,['����ת������' num2str(75) '%']);
%save data per hour and note the actual time corresponding, save as nameab_class_channel_xx_00_xx_59.txt
pp=0;
for i=1:(total_hou-1)
 pp= rem((hou+i),24);
 fid = fopen([pathname,num2str(name_qp),'_',num2str(class),'_1h_',num2str(channel),'_',num2str(pp),'_00_',num2str(pp),'_59.txt'],'w');
 fprintf(fid,'%g\n',temp(:,i));      % # \n ����
 fclose(fid);
 time=0.75+i*0.25/(total_hou-1);
 waitbar(time,jindu,['����ת������' num2str(round(100*time)) '%']);
end
 fid = fopen([pathname,num2str(name_qp),'_',num2str(class),'_1h_',num2str(channel),'_',num2str(hou),'_XX_',num2str(hou),'_YY.txt'],'w');
 fprintf(fid,'%g\n',temp(:,24));      % # \n ����
 fclose(fid);
 close(jindu); 
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
%  fprintf(fid,'%g\n',night);      % # \n ����
%  fclose(fid);
%  
%  %save as "nameab_class_chanenl_day1.txt":record start-22:59
%  day1=[];
%  day1_hou=22-hou;              %intergral hours   %
%  day1_size=r_size+day1_hou*s_hou; 
%  day1=X(1:day1_size,1);
%  fid = fopen([num2str(name_ab),'_',num2str(class),'_',num2str(channel),'_day1.txt'],'w');
%  fprintf(fid,'%g\n',day1);      % # \n ����
%  fclose(fid);
%  
%  %save as "nameab_class_chanenl_day2.txt":05:00-end record
%  day2=[];
%  day2_str_size=day1_size+6*s_hou+1;
%  day2=X(day2_str_size:l,1);
%  fid = fopen([num2str(name_ab),'_',num2str(class),'_',num2str(channel),'_day2.txt'],'w');
%  fprintf(fid,'%g\n',day2);      % # \n ����
%  fclose(fid);