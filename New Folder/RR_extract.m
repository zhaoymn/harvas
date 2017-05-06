% % % %%%%%%%%%%%%20151130%%%%%%%%%%%%%
% % % %%%%%%%%%%%%BY yz%%%%%%%%%%%%%%%%
% % % %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
% % % extract the RR intervals from evert hour of a subject
% % % and save the RR intervals as .txt and .mat
% % % two words name : name1=name(3:10);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % %Input the need parameters
clc
clear
% % filepath = input('Input the original file path','s') ;
% % name_new = input('Input the 全拼 name','s') ;

filepath = cd;

%find all .mat in certain file
A = dir(fullfile(filepath,'*.mat'));
N=size(A);
num=N(1,1);
%num=24;
len_C=zeros(num,1);
s=zeros(num,1);
hour=zeros(num,1);



B=[];
h_start=0;
RR=[];
RR_day=[];
RR_day1=[];
RR_night1=[];
RR_day4h=[];

%Input the initial time 
h_start = input('Type in the initial hour = ');


% extract and save 1h RR intervals
for i=1:num
    
    name=A(i,1).name;  % string
    temp=load(name);
    C=temp.Res.HRV.Data.RR;
    len_C(i,1)=length(C);
    %取字符串中所有数字
    s(i,1)=str2num(name(regexp(name,'\d')));    
    B(1:len_C(i,1),i)=C;
    len_name=length(name);
    
    if s(i,1)<1000
        hour(i,1)=mod(s(i,1),10);
        %h_start=floor(hour(i,1));
    else if s(i,1)<10000
        hour(i,1)=mod(s(i,1),100);
        %h_start=floor(hour(i,1));
%     else if s(i,1)<1000000000
%         h_temp=mod(s(i,1),1000);  
%         hour(i,1)=floor(h_temp/100);
%     else if s(i,1)<100000000000
%         h_temp=mod(s(i,1),10000);  
%         hour(i,1)=floor(h_temp/100);
%         end
%         end
        end  
     end
    name1=name(1:(len_name-8));  % for 3 words name
    %name1=name(3:11);   % for 2 words name
    
    % save address
    savepath = ['C:\data\RR\300VNS\1h\caixinyu\'];
    save([savepath ,name1],'C');
    fid = fopen([savepath ,name1,'.txt'],'w');
    fprintf(fid,'%g\n',C);      % # \n 换行
    fclose(fid);   
end


for i=1:24
    h_goal=mod((h_start+i),24);
    for j=1:24
        if hour(j)==h_goal
          len_RR=length(RR);
          RR((len_RR+1):(len_RR+len_C(j,1)),1)=B(1:len_C(j,1),j);
        end
    end
end

len_name1=length(name1);
    for j=1:len_name
        if name1(j)== '_'
        name_new=name1(1:(j));
        name2=name1((j+1):len_name1);
        break
        end
    end

len_name2=length(name2);
    for j=1:len_name2
        if name2(j)== '_'
        name_new1=name2(1:(j));
        name3=name2((j+1):len_name2);
        break
        end
    end
    
len_name3=length(name3);
    for j=1:len_name3
        if name3(j)== '_'
        name4=name3((j+1):len_name3);
        break
        end
    end
    
len_name4=length(name4);
    for j=1:len_name4
        if name4(j)== '_'
        name_new2=name4(1:(j));
        break
        end
    end

 save([savepath ,name_new,name_new1,name_new2,'24hRR'],'RR');
 fid = fopen([savepath ,name_new,name_new1,name_new2,'24hRR.txt'],'w');
 fprintf(fid,'%g\n',RR);      % # \n 换行
 fclose(fid);   

%清醒状态下，08:00-20:00的RR间期            
for i=8:20
    h_goal=i;
    for j=1:24
        if hour(j)==h_goal
          len_RR_day=length(RR_day);
          RR_day((len_RR_day+1):(len_RR_day+len_C(j,1)),1)=B(1:len_C(j,1),j);
        end
    end
end

save([savepath ,name_new,name_new1,name_new2,'RR_day'],'RR');
 fid = fopen([savepath ,name_new,name_new1,name_new2,'RR_day.txt'],'w');
 fprintf(fid,'%g\n',RR_day);      % # \n 换行
 fclose(fid);   
 
 %选取的清醒状态下，连续平稳4h的RR间期            
for i=8:12  %8,9,10,11,12=4h
    h_goal=i;
    for j=1:24
        if hour(j)==h_goal
          len_RR_day1=length(RR_day1);
          RR_day1((len_RR_day1+1):(len_RR_day1+len_C(j,1)),1)=B(1:len_C(j,1),j);
        end
    end
end

len_RR_day1=length(RR_day1);
for i=1:len_RR_day1
    sum4h=sum(RR_day1(1:i));
    if sum4h > 4*60*60
        RR_day4h = RR_day1(1:i);
        break;
    end        
end

save([savepath ,name_new,name_new1,name_new2,'RR_day4h'],'RR');
fid = fopen([savepath ,name_new,name_new1,name_new2,'RR_day4h.txt'],'w');
fprintf(fid,'%g\n',RR_day4h);      % # \n 换行
fclose(fid);  

 %选取的03:00-05:00睡眠状态下的RR间期            
for i=3:4   %3,4=2h
    h_goal=i;
    for j=1:24
        if hour(j)==h_goal
          len_RR_night1=length(RR_night1);
          RR_night1((len_RR_night1+1):(len_RR_night1+len_C(j,1)),1)=B(1:len_C(j,1),j);
        end
    end
end

save([savepath ,name_new,name_new1,name_new2,'RR_night1'],'RR');
fid = fopen([savepath ,name_new,name_new1,name_new2,'RR_night1.txt'],'w');
fprintf(fid,'%g\n',RR_night1);      % # \n 换行
fclose(fid);  


