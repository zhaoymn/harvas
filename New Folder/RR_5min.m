% %%%%%%%%%%%%20151203%%%%%%%%%%%%%
% %%%%%%%%%%%%BY yz%%%%%%%%%%%%%%%%
% %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
% find and save the consecutive 5min's RR intervals from evert hour of a subject
% 姓名_类别_时长_通道（if necessary）_序号,eg:maoyunlin_00_5min_II_00
% two words name : name1=name(3:10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input the need parameters
clc
clear
%filepath = input('Input the original file path','s') ;
%name_new = input('Input the 全拼 name','s') ;


filepath = cd;

%find all .mat in certain file
A = dir(fullfile(filepath,'*.mat'));
N=size(A);
num=N(1,1);
s=zeros(num,1);
hour=zeros(num,1);
%savepath = ['E:\VNS\cg\5min\',name_new,'\'];



% B=[];
% h_start=0;
% RR=[];


% choose the start time of 5min and save as ........
for i=1:1
    
    name=A(i,1).name;  % string
    temp=load(name);
    C=temp.C;
    len_C=length(C);
    % s(i,1)=str2num(name(regexp(name,'\d')));    
    % B(1:len_C(i,1),i)=C;
    disp(name);
    %Input the time interval need to be deleted 
    start_min = input('Type in the start minute = ');
    start_sec = input('Type in the start second = ');
    start_sum = start_min*60+start_sec;
    end_sum = start_sum+5*60;
    
    %choose the srable 5min 
    sum = 0; 
    for j=1:len_C
        sum = sum + C(j);
        if sum >= start_sum
            start_lab = j;
            break
        end
    end
    sum=0;
    for j=1:len_C
        sum = sum + C(j);
        if sum >= end_sum
            end_lab = j;
            break
        end
    end 
    C1= C(start_lab:(end_lab-1),1);
    
    % save as....
    len_name=length(name);
    for j=1:len_name
        if name(j)== '_'
        name_new=name(1:(j-1));
        name1=name((j+1):len_name);
        break
        end
    end
        len_name1=length(name1);
    for j=1:len_name1
        if name1(j)== '_'
        name_class=name1(1:j);          %'cg_'
        name_end=name1((j+1):len_name1);
        break
        end
    end
    len_name2=length(name_end);
    for j=1:len_name2
        if name_end(j)== '_'
        name_end2=name_end(j:len_name2);
        break
        end
    end
    len_name3=length(name_end2);
    for j=1:len_name3
        if name_end2(j)== '.'
        name_behind=name_end2(1:(j-1));
        break
        end
    end
%    sub_folder = ['E:/VNS/cg/5min/',name_new,'/'];
     sub_folder = ['E:\VNS小组资料\300例癫痫患者心电数据\HRV处理结果\final_result\5min\zhuanghaoxiang\'];
    mkdir(sub_folder); % 创建新子文件夹
    savepath = sub_folder; 
    save([savepath ,num2str(name_new),'_00_5min',num2str(name_behind)],'C1');
    fid = fopen([savepath,num2str(name_new),'_00_5min',num2str(name_behind),'.txt'],'w');
    fprintf(fid,'%g\n',C1);      % # \n 换行
    fclose(fid);     
end



