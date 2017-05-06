% %%%%%%%%%%%%20150829%%%%%%%%%%%%%
% %%%%%%%%%%%%BY yz%%%%%%%%%%%%%%%%
% %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
%  delete the unuseful signal(null or noise)from the 1h txt:00:00-59:59
%  and adjust the prename to "nameab_class_chanenl_xx_00_xx_59_new.txt"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input the need parameters
clc
clear
filename = input('Input the original file name','s') ;
%Input the time interval need to be deleted 
start_min = input('Type in the start minute = ');
start_sec = input('Type in the start second = ');
stop_min = input('Type in the stop minute = ');
stop_sec = input('Type in the stop second = ');


% load original data ".txt"
Y=load([num2str(filename),'.txt']);

%%fixed parameterF=500;  %sample frequency
F=500;
s_min=F*60;     %num of a min
%s_hou=F*3600;      %num of a hour
l=size(Y);       %length of Y
l=l(1);
time=l/500;
start_num=(start_min *60+start_sec)*500+1;
stop_num=(stop_min *60+stop_sec)*500;
delete_l=stop_num-start_num+1;
data=zeros((l-delete_l),1);
if (start_num>1)&&(stop_num<l)    
    data(1:(start_num-1),1)=Y(1:(start_num-1),1) ;         %%%cut off the middile interval
    data(start_num:(l-delete_l),1)=Y((stop_num+1):l);
else if start_num==1
        data(:,1)=Y((stop_num+1:l),1);                     %%%cut off from 00:00
    else if stop_num==l
            data(:,1)=Y(1:(start_num-1),1);                %%%cut off end 59:59
        end
    end
end


fid = fopen([num2str(filename),'_new.txt'],'w');
fprintf(fid,'%g\n',data);      % # \n »»ÐÐ
fclose(fid);







